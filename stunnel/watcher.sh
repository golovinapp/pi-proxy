#!/bin/bash
set -e
PID="$1"
FULL="$2"
KEY="$3"
SUM=""
while true; do
  NEWSUM="$(sha256sum "$FULL" "$KEY" 2>/dev/null | sha256sum | awk '{print $1}')"
  if [ "$NEWSUM" != "$SUM" ] && [ -n "$NEWSUM" ]; then
    echo "[stunnel] Certificate changed, reloading stunnel (pid $PID)"
    kill -HUP "$PID" || true
    SUM="$NEWSUM"
  fi
  sleep 300
done