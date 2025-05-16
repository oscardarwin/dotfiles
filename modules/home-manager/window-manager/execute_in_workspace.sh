#!/bin/sh

SESSION_1PASSWORD_ENV_VAR=$(systemctl --user show-environment | grep OP_SESSION | head -n1)

WORKSPACE_NAME=$2
TO_EXECUTE=$1
WORKSPACE_EXISTS=$(exec swaymsg -t get_workspaces | grep '"name": "'$WORKSPACE_NAME'"')
if [ -n "$WORKSPACE_EXISTS" ]; then exec swaymsg "workspace $WORKSPACE_NAME"
else swaymsg "workspace $WORKSPACE_NAME; exec systemd-run --user --scope --quiet --setenv $SESSION_1PASSWORD_ENV_VAR $TO_EXECUTE"
fi
