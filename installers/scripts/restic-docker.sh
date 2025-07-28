#!/bin/bash
#
# Restic Docker wrapper script
#
# Prerequisities:
# ---------------
#  - Installed Docker
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

docker run --rm \
    -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
    -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    restic/restic $@
