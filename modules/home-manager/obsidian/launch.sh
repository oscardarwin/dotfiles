#!/bin/sh

set -e

NOTES_DIR="$HOME/notes"
REMOTE="gdrive:notes"

if ! mountpoint -q "$NOTES_DIR"; then
  if ! rclone mount "$REMOTE" "$NOTES_DIR" --daemon --vfs-cache-mode full --buffer-size 256M --dir-cache-time 72h --drive-chunk-size 32M; then
    exit 1
  fi
fi

exec systemd-run --user --scope --quiet obsidian
