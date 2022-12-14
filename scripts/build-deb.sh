#!/usr/bin/env bash
set -euxo pipefail

CHIM_VERSION=$(./scripts/get-version.sh)

tar -xvJf "dist/chim-$CHIM_VERSION-linux-x64.tar.xz"
fpm -s dir -t deb \
	--name chim \
	--license MIT \
	--version "${CHIM_VERSION#v*}" \
	--architecture amd64 \
	--description "Cross-platform binary shims with optional remote fetching" \
	--url "https://chim.sh" \
	--maintainer "Jeff Dickey @jdxcode" \
	chim/bin/chim=/usr/bin/chim

tar -xvJf "dist/chim-$CHIM_VERSION-linux-arm64.tar.xz"
fpm -s dir -t deb \
	--name chim \
	--license MIT \
	--version "${CHIM_VERSION#v*}" \
	--architecture arm64 \
	--description "Cross-platform binary shims with optional remote fetching" \
	--url "https://chim.sh" \
	--maintainer "Jeff Dickey @jdxcode" \
	chim/bin/chim=/usr/bin/chim

mkdir -p dist/deb/pool/main
cp -v ./*.deb dist/deb/pool/main
mkdir -p dist/deb/dists/stable/main/binary-amd64
mkdir -p dist/deb/dists/stable/main/binary-arm64
cd dist/deb
dpkg-scanpackages --arch amd64 pool/ >dists/stable/main/binary-amd64/Packages
dpkg-scanpackages --arch arm64 pool/ >dists/stable/main/binary-arm64/Packages
gzip -9c <dists/stable/main/binary-amd64/Packages >dists/stable/main/binary-amd64/Packages.gz
gzip -9c <dists/stable/main/binary-arm64/Packages >dists/stable/main/binary-arm64/Packages.gz
cd ../..

cd dist/deb/dists/stable
"$GITHUB_WORKSPACE/packaging/deb/generate-release.sh" >Release
gpg -u 7E07A8D14B7A5595 -abs <Release >Release.gpg
gpg -u 7E07A8D14B7A5595 -abs --clearsign <Release >InRelease
cd "$GITHUB_WORKSPACE"
