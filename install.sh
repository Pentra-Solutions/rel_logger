#!/bin/bash

# Configuration
REPO="Pentra-Solutions/rel_logger"
APP_NAME="pentra" 
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
BIN_DIR="/usr/local/bin"     

# Detect OS and Architecture
OS=$(uname -s)
ARCH=$(uname -m)

if [ "$OS" = "Linux" ]; then
    OS="linux"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ]; then
    ARCH="arm64"
elif [ "$ARCH" = "386" ]; then
    ARCH="386"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Download the latest release
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/${APP_NAME}_${OS}_${ARCH}.zip"
echo "Downloading $APP_NAME from $DOWNLOAD_URL ..."
curl -L "$DOWNLOAD_URL" -o "$APP_NAME.zip"

# Extract the binary
echo "Extracting $APP_NAME ..."
unzip "$APP_NAME.zip"
mv "${APP_NAME}_${OS}_${ARCH}" "$APP_NAME"
chmod +x "$APP_NAME"

# Move the binary to the installation directory
echo "Installing $APP_NAME to $BIN_DIR ..."
sudo mv "$APP_NAME" "$BIN_DIR/$APP_NAME"

# Clean up
echo "Cleaning up ..."
rm "$APP_NAME.zip"

echo "$APP_NAME installation complete!"
echo "Run '$APP_NAME' to get started."
