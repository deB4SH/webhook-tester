#!/usr/bin/env bash
# check for all required executables
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
# defaults
REGISTRY="ghcr.io/deb4sh"
# get current tag information
IS_DEV_BUILD=$(git tag -l --contains HEAD)
GIT_TAG=$(git describe --abbrev=0 --tags HEAD)

if [ -z "$IS_DEV_BUILD" ]
then
    TIMESTAMP=$(date +%s)
    TAG=$(echo "$GIT_TAG"-"$TIMESTAMP")
else
    TAG=$GIT_TAG
fi
# build
if [ -x "$(command -v podman)" ]; then
    cli_cmd="podman"
elif [ -x "$(command -v docker)" ]; then
    cli_cmd="docker"
else
    echo "No container cli tool found! Aborting."
    exit -1
fi
${cli_cmd} build -f Dockerfile -t $(echo "$REGISTRY/webhook-tester:$TAG") .