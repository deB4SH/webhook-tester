#!/usr/bin/env bash
source ./build.sh

${cli_cmd} run \
    -p 60001:8080 \
    $(echo "$REGISTRY/webhook-tester:$TAG")