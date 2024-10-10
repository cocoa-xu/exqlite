#!/bin/sh

set -x

DOCKER_PLATFORM=$1
DOCKER_IMAGE=$2
OTP_VERSION=$3
ELIXIR_VERSION=$4
TARGET_TRIPLET=$5

sudo docker run --privileged --network=host --rm --platform="${DOCKER_PLATFORM}" -v $(pwd):/work "${DOCKER_IMAGE}" \
    sh -c "chmod a+x /work/do-build.sh && /work/do-build.sh ${OTP_VERSION} ${ELIXIR_VERSION} ${TARGET_TRIPLET}"

sudo chmod -R a+r ./cache
