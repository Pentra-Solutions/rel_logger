#!/bin/bash

# Configuration
REPO="Pentra-Solutions/rel_logger"
APP_NAME="pentra" 
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -oP '"tag_name": "\K(.*)(?=")')
BIN_DIR="/usr/local/bin"     

# Detect OS and Architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

if [ "$OS" = "Linux" ]; then
    OS="linux"
else
    echo -e "${RED}Unsupported OS: $OS${NC}"
    exit 1
fi

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "arm64" ]; then
    ARCH="arm64"
elif [ "$ARCH" = "386" ]; then
    ARCH="386"
else
    echo -e "${RED}Unsupported architecture: $ARCH${NC}"
    exit 1
fi

# Download the latest release
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_RELEASE/${APP_NAME}_${OS}_${ARCH}.zip"
echo -e "${YELLOW}Downloading $APP_NAME from $DOWNLOAD_URL ...${NC}"
curl -L "$DOWNLOAD_URL" -o "$APP_NAME.zip"

# Extract the binary
echo -e "${YELLOW}Extracting $APP_NAME ...${NC}"
unzip "$APP_NAME.zip"
mv "${APP_NAME}_${OS}_${ARCH}" "$APP_NAME"
chmod +x "$APP_NAME"

# Move the binary to the installation directory
echo -e "${YELLOW}Installing $APP_NAME to $BIN_DIR ...${NC}"
sudo mv "$APP_NAME" "$BIN_DIR/$APP_NAME"

# Clean up
echo -e "${YELLOW}Cleaning up ...${NC}"
rm "$APP_NAME.zip"

echo -e "${GREEN}$APP_NAME installation complete!${NC}"
echo -e "${GREEN}Run '$APP_NAME' to get started.${NC}"
