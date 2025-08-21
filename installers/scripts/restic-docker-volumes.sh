#!/bin/bash
# Script for docker multiple volumes backup/restore to S3 using restic
#
# Prerequisities:
# ---------------
#  - Installed docker
#  - Configuration:
#    Set following variables to the /root/restic.env file and protect it (chmod 600 /root/restic.env):
#
#       export RESTIC_REPOSITORY="s3:https://s3.amazonaws.com/safetica-backup-restic/azure/proxy3.safetica.cloud"
#       export AWS_ACCESS_KEY_ID="xxxx"
#       export AWS_SECRET_ACCESS_KEY="xxxx"
#       export RESTIC_PASSWORD="xxxx"
#

set -euo pipefail

if [ ! -f /root/restic.env ]; then
  echo "Error: /root/restic.env not found. Please create the file with the required environment variables."
  exit 1
fi

source /root/restic.env

usage() {
  echo "Script for docker volumes backup/restore using restic"
  echo ""
  echo "Usage:"
  echo "  $(basename "$0") backup [volume1] [volume2] ..."
  echo "  $(basename "$0") restore <snapshot_id> [volume1] [volume2] ..."
  echo "  $(basename "$0") init"
  echo "  $(basename "$0") snapshots"
  echo ""
}

# Validate required variables are present (empty or unset will fail)
: "${RESTIC_REPOSITORY:?RESTIC_REPOSITORY is required}"
: "${RESTIC_PASSWORD:?RESTIC_PASSWORD is required}"
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID is required}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY is required}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not installed!"
  exit 1
fi

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

MODE="$1"
shift

if [ "$MODE" = "help" ] || [ "$MODE" = "-help" ] || [ "$MODE" = "--help" ] || [ "$MODE" = "h" ] || [ "$MODE" = "-h" ]; then
    usage
    exit 0
fi

VOLUMES_V=""
VOLUMES_DIRS=""

if [ "$MODE" = "backup" ]; then
    for i in "$@"; do
        si="${i#/}"
        VOLUMES_V="$VOLUMES_V -v $i:/$si:ro"
        VOLUMES_DIRS="$VOLUMES_DIRS /$si"
    done
    # Trim leading whitespace from VOLUMES_V and VOLUMES_DIRS
    VOLUMES_V="${VOLUMES_V#"${VOLUMES_V%%[![:space:]]*}"}"
    VOLUMES_DIRS="${VOLUMES_DIRS#"${VOLUMES_DIRS%%[![:space:]]*}"}"
    # The --host "$(hostname)" option ensures that restic groups snapshots by the current machine's hostname.
    if [ -z "$VOLUMES_DIRS" ]; then
        echo "No volumes specified for backup."
        exit 1
    fi
    docker run --rm $VOLUMES_V \
        -e RESTIC_REPOSITORY="$RESTIC_REPOSITORY" \
        -e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
        -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
        -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
        restic/restic backup --tag docker-volume --host "$(hostname)" $VOLUMES_DIRS

elif [ "$MODE" = "restore" ]; then
    if [ $# -lt 1 ]; then
        echo "Missing snapshot id"
        exit 1
    fi
    SNAPSHOT_ID="$1"
    shift
    if [ $# -lt 1 ]; then
        echo "Specify at least one volume name or absolute path to restore"
        exit 1
    fi

    for i in "$@"; do
        si="${i#/}"

        # Decide if this is a bind path or a named Docker volume
        if [[ "$i" = /* || "$i" = ./* || "$i" = ../* || "$i" = *"/"* ]]; then
            # Bind path (host filesystem)
            mkdir -p "$i"
            VOLUMES_V="$VOLUMES_V -v $i:/$si"
        else
            # Named Docker volume
            if ! docker volume inspect "$i" >/dev/null 2>&1; then
                docker volume create "$i" >/dev/null
            fi
            VOLUMES_V="$VOLUMES_V -v $i:/$si"
        fi
        # Using --include /$si to restore only the specified volume/directory; remove this if you want to restore the entire snapshot.
        VOLUMES_DIRS="$VOLUMES_DIRS --include /$si"
    done

    docker run --rm $VOLUMES_V \
        -e RESTIC_REPOSITORY="$RESTIC_REPOSITORY" \
        -e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
        -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
        -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
        restic/restic restore "$SNAPSHOT_ID" --target / $VOLUMES_DIRS

elif [ "$MODE" = "init" ]; then
    docker run --rm \
        -e RESTIC_REPOSITORY="$RESTIC_REPOSITORY" \
        -e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
        -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
        -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
        restic/restic init

elif [ "$MODE" = "snapshots" ]; then
    docker run --rm \
        -e RESTIC_REPOSITORY="$RESTIC_REPOSITORY" \
        -e RESTIC_PASSWORD="$RESTIC_PASSWORD" \
        -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
        -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
        restic/restic snapshots

else
    usage
    exit 1
fi
