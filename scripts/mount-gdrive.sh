#!/usr/bin/env bash

# Google Drive Mount Script
MOUNT_POINT="$HOME/GoogleDrive"

# Check if already mounted
if mountpoint -q "$MOUNT_POINT"; then
    echo "Google Drive already mounted at $MOUNT_POINT"
    exit 0
fi

# Create mount point if it doesn't exist
mkdir -p "$MOUNT_POINT"

# Mount Google Drive
echo "Mounting Google Drive to $MOUNT_POINT..."
rclone mount gdrive: "$MOUNT_POINT" --vfs-cache-mode writes --daemon

# Check if mount was successful
sleep 2
if mountpoint -q "$MOUNT_POINT"; then
    echo "✓ Google Drive mounted successfully at $MOUNT_POINT"
else
    echo "✗ Failed to mount Google Drive"
    exit 1
fi