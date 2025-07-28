#!/bin/bash
# Script for docker multiple volumes backup/restore to S3 using restic
#
# Prerequisities:
# ---------------
#  - Installed docker
#  - Configuration:
#    Set following variables to the /root/restic.env file and protect it (chmod 600 /root/restic.env):
#
#       export RESTIC_REPOSITORY="s3:https://s3.amazonaws.com/backup-restic/my/server"
#       export AWS_ACCESS_KEY_ID="xxxx"
#       export AWS_SECRET_ACCESS_KEY="xxxx"
#       export RESTIC_PASSWORD="xxxx"
#

set -euo pipefail

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

which docker > /dev/null
if [ $? -ne 0 ]; then
  echo "Docker not installed!"
  exit 1
fi

MODE="$1"
shift

if [ "$MODE" = "help" ] || [ "$MODE" = "-help" ] || [ "$MODE" = "h" ] || [ "$MODE" = "-h" ]; then
    usage
    exit 0
fi

VOLUMES_V=""
VOLUMES_DIRS=""

if [ "$MODE" = "backup" ]; then
    for I in "$@"; do
        VOLUMES_V="$VOLUMES_V -v $I:/$I:ro"
        VOLUMES_DIRS="$VOLUMES_DIRS /$I"
    done
    docker run --rm $VOLUMES_V \
        -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
        -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        restic/restic backup --tag docker-volume --host $(hostname) $VOLUMES_DIRS

elif [ "$MODE" = "restore" ]; then
    SNAPSHOT_ID="$1"
    shift
    for I in "$@"; do
        VOLUMES_V="$VOLUMES_V -v $I:/$I"
        docker volume create $I
    done
    docker run --rm $VOLUMES_V \
        -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
        -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        restic/restic restore "$SNAPSHOT_ID" --target /

elif [ "$MODE" = "init" ]; then
    docker run --rm \
        -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
        -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        restic/restic init

elif [ "$MODE" = "snapshots" ]; then
    docker run --rm \
        -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
        -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
        -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        restic/restic snapshots

else
    usage
    exit 1
fi
