#!/usr/bin/env bash

OP_SESSION=$(systemctl --user show-environment | grep '^OP_SESSION=' | cut -d= -f2-)
SSID=$(op item get hotspot --field=username --token "$OP_SESSION")
PASSWORD=$(op item get hotspot --field=password --token "$OP_SESSION")

if [ -n "$SSID" ] && [ -n "$PASSWORD" ]; then
  nmcli device wifi connect "$SSID" password "$PASSWORD"
fi
