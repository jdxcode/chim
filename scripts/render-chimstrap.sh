#!/usr/bin/env bash
set -euxo pipefail

# shellcheck disable=SC2016
CHIM_VERSION=$CHIM_VERSION \
	CHIM_CHECKSUM_LINUX_X86_64=$(grep linux-x64.tar.xz "$RELEASE_DIR/$CHIM_VERSION/SHASUMS256.txt") \
	CHIM_CHECKSUM_LINUX_ARM64=$(grep linux-arm64.tar.xz "$RELEASE_DIR/$CHIM_VERSION/SHASUMS256.txt") \
	CHIM_CHECKSUM_MACOS_X86_64=$(grep macos-x64.tar.xz "$RELEASE_DIR/$CHIM_VERSION/SHASUMS256.txt") \
	CHIM_CHECKSUM_MACOS_ARM64=$(grep macos-arm64.tar.xz "$RELEASE_DIR/$CHIM_VERSION/SHASUMS256.txt") \
	envsubst '$CHIM_VERSION,$CHIM_CHECKSUM_LINUX_X86_64,$CHIM_CHECKSUM_LINUX_ARM64,$CHIM_CHECKSUM_MACOS_X86_64,$CHIM_CHECKSUM_MACOS_ARM64' \
	<chim/packaging/chimstrap/chimstrap
