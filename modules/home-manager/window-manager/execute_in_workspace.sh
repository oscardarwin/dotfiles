#!/bin/sh
WORKSPACE_NAME=$2
TO_EXECUTE=$1
WORKSPACE_EXISTS=$(exec swaymsg -t get_workspaces | grep '"name": "'$WORKSPACE_NAME'"')
if [ -n "$WORKSPACE_EXISTS" ]; then exec swaymsg "workspace $WORKSPACE_NAME"
else swaymsg "workspace $WORKSPACE_NAME; exec $TO_EXECUTE"
fi
