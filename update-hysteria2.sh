#!/bin/bash

# Auto-update Hysteria2
# Usage: Place in cron to run periodically

set -e

LOG="/var/log/hysteria2-update.log"
INSTALL_DIR="/usr/local/bin"
BINARY="$INSTALL_DIR/hysteria"
SERVICE_NAME="hysteria-server"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# Get current version
CURRENT=""
if [ -f "$BINARY" ]; then
    CURRENT=$($BINARY version 2>/dev/null | grep -oP 'v[\d.]+' | head -1 || echo "")
fi

# Get latest version from GitHub
LATEST=$(curl -s https://api.github.com/repos/apernet/hysteria/releases/latest | grep -oP '"tag_name":\s*"app/\K[^"]+' || echo "")

if [ -z "$LATEST" ]; then
    log "ERROR: Failed to fetch latest version"
    exit 1
fi

if [ "$CURRENT" = "$LATEST" ]; then
    log "Already up to date: $CURRENT"
    exit 0
fi

log "Updating from $CURRENT to $LATEST"

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *)       log "ERROR: Unsupported arch $ARCH"; exit 1 ;;
esac

# Download new binary
URL="https://github.com/apernet/hysteria/releases/download/app/${LATEST}/hysteria-linux-${ARCH}"
TMP=$(mktemp)

if ! curl -sL -o "$TMP" "$URL"; then
    log "ERROR: Download failed"
    rm -f "$TMP"
    exit 1
fi

chmod +x "$TMP"

# Stop service, replace binary, restart
systemctl stop "$SERVICE_NAME" 2>/dev/null || true
mv "$TMP" "$BINARY"
systemctl start "$SERVICE_NAME" 2>/dev/null || true

log "Updated to $LATEST successfully"
