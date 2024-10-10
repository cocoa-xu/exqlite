#!/bin/sh

set -x

OTP_VERSION=$1
ELIXIR_VERSION=$2
TARGET_TRIPLET=$3

OTP_MAIN_VER="${OTP_VERSION%%.*}"
export DEBIAN_FRONTEND=noninteractive
export LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

case $TARGET_TRIPLET in
    armv7l-linux-gnueabihf )
        apt-get update && \
        apt-get install -y libncurses-dev libssl-dev make cmake build-essential gcc g++ curl unzip locales locales-all && \
        sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
        locale-gen
        ;;
    *)
        echo "Unknown TRIPLET: ${TARGET_TRIPLET}"
        exit 1
        ;;
esac

ROOTDIR="/work"
OTP_ROOTDIR="${ROOTDIR}/.tools/otp"
ELIXIR_DIR="${ROOTDIR}/.tools/elixir"
export PATH="${OTP_ROOTDIR}/usr/local/bin:${ELIXIR_DIR}/${ELIXIR_VERSION}/bin:${PATH}"
export ERL_ROOTDIR="${OTP_ROOTDIR}/usr/local/lib/erlang"
export ELIXIR_MAKE_CACHE_DIR="${ROOTDIR}/cache"
export CC_PRECOMPILER_PRECOMPILE_ONLY_LOCAL="true"

mkdir -p "${OTP_ROOTDIR}" && \
    mkdir -p "${ELIXIR_DIR}" && \
    mkdir -p "${ELIXIR_MAKE_CACHE_DIR}" && \
    cd "${OTP_ROOTDIR}" && \
    curl -fSL "https://github.com/cocoa-xu/otp-build/releases/download/v${OTP_VERSION}/otp-${TARGET_TRIPLET}.tar.gz" -o "otp-${TARGET_TRIPLET}.tar.gz" && \
    tar -xzf "otp-${TARGET_TRIPLET}.tar.gz" && \
    cd "${ELIXIR_DIR}" && \
    curl -fSL "https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/elixir-otp-${OTP_MAIN_VER}.zip" -o "elixir-otp-${OTP_MAIN_VER}.zip" && \
    unzip -o -q "elixir-otp-${OTP_MAIN_VER}.zip" -d "${ELIXIR_VERSION}" && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd "${ROOTDIR}" && \
    mix deps.get && \
    mix elixir_make.precompile
