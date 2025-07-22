#!/bin/bash

VOCECHAT_SERVER_VERION=$(curl -s curl https://sh.voce.chat/LATEST_SERVER_TAG.txt)
ARCH=$(uname -m)
PLATFORM="x86_64-unknown-linux-musl"
INSTALL_DIR="/tmp/vocechat"

case $ARCH in
  arm64)
    PLATFORM="aarch64-unknown-linux-musl"    
    ;;
  aarch64)
    PLATFORM="aarch64-unknown-linux-musl"
    ;;
  armv7l | arm)
    PLATFORM="armv7-unknown-linux-musleabihf"
    ;;
  x86_64)
    PLATFORM="x86_64-unknown-linux-musl"
    ;;
  *)
    echo -n "error: not supportted arch $(ARCH)!"
    exit
    ;;
esac

BIN_NAME="vocechat-server-$VOCECHAT_SERVER_VERION-$PLATFORM.zip"
BIN_URL="https://sh.voce.chat/$BIN_NAME"

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

download_temp_file="vocechat-server.zip.tmp"
curl -f "$BIN_URL" -o "$download_temp_file"
mv -f "$download_temp_file" vocechat-server.zip
unzip -oq vocechat-server.zip
rm -rf vocechat-server.zip;
chmod a+x vocechat-server
cp -f vocechat-server /usr/bin/vocechat-server

rm -rf "${INSTALL_DIR}"