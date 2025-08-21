#!/bin/bash
#
# Restic Docker wrapper script
#
# Prerequisites:
# ---------------
#  - Installed Docker
#  - Configuration:
#    Set following variables to the /root/restic.env file and protect it (chmod 600 /root/restic.env):
#
#       export RESTIC_REPOSITORY="s3:https://s3.amazonaws.com/safetica-backup-restic/azure/proxy3.safetica.cloud"
#       export AWS_ACCESS_KEY_ID="xxxx"
#       export AWS_SECRET_ACCESS_KEY="xxxx"
#       export RESTIC_PASSWORD="xxxx"
#

set -euo pipefail

# Load credentials/config, fail with a clear message if missing
if [[ -f /root/restic.env ]]; then
    # shellcheck source=/root/restic.env
    source /root/restic.env
else
    echo "Error: /root/restic.env not found. Create it and set RESTIC_REPOSITORY, RESTIC_PASSWORD, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY." >&2
    exit 1
fi

# Validate required variables are present (empty or unset will fail)
: "${RESTIC_REPOSITORY:?RESTIC_REPOSITORY is required}"
: "${RESTIC_PASSWORD:?RESTIC_PASSWORD is required}"
: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID is required}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY is required}"

# Ensure Docker is available
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: docker not found in PATH." >&2
    exit 1
fi

exec docker run --rm \
    -e RESTIC_REPOSITORY="${RESTIC_REPOSITORY}" \
    -e RESTIC_PASSWORD="${RESTIC_PASSWORD}" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    restic/restic "$@"
