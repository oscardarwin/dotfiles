#!/usr/bin/env bash

OP_SESSION=$(systemctl --user show-environment | grep '^OP_SESSION=' | cut -d= -f2-)
SSID=$(op item get hotspot --field=username --session "$OP_SESSION")
PASSWORD=$(op item get hotspot --field=password --session "$OP_SESSION" --reveal)

if [ -n "$SSID" ] && [ -n "$PASSWORD" ]; then
  nmcli device wifi connect "$SSID" password "$PASSWORD"
fi
