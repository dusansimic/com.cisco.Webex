#!/bin/sh
set -e

timezone_workaround() {
  if [ -n "$TZ" ]; then
    return
  fi

  if [ ! -f /etc/timezone ]; then
    return
  fi

  zone_name=$(cat /etc/timezone | sed -e 's~[[:space:]]*$~~')

  if [ -z "$zone_name" ] || [ ! -f "/usr/share/zoneinfo/$zone_name" ]; then
    return
  fi

  export TZ="$zone_name"
  echo "Overriting TZ to $zone_name"
}

timezone_workaround

exec env TMPDIR="$XDG_RUNTIME_DIR/app/$FLATPAK_ID" zypak-wrapper /app/bin/CiscoCollabHost "$@" --disable-namespace-sandbox --disable-setuid-sandbox
