#!/bin/sh
set -e
: "${STUNNEL_BACKEND_HOST:=threeproxy}"
: "${STUNNEL_BACKEND_PORT:=3128}"
: "${STUNNEL_ACCEPT_PORT:=443}"
: "${STUNNEL_CERT_FULLCHAIN:=/certs/fullchain.pem}"
: "${STUNNEL_CERT_PRIVKEY:=/certs/privkey.pem}"
: "${TZ:=UTC}"
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime || true
echo "$TZ" >/etc/timezone || true
if [ ! -f "$STUNNEL_CERT_FULLCHAIN" ] || [ ! -f "$STUNNEL_CERT_PRIVKEY" ]; then
  echo "[stunnel] Waiting for certificates in /certs ..."
  while [ ! -f "$STUNNEL_CERT_FULLCHAIN" ] || [ ! -f "$STUNNEL_CERT_PRIVKEY" ]; do
    sleep 2
  done
fi
mkdir -p /etc/stunnel
envsubst < /etc/stunnel/stunnel.conf.tpl > /etc/stunnel/stunnel.conf
stunnel /etc/stunnel/stunnel.conf &
STUNNEL_PID=$!
/watcher.sh "$STUNNEL_PID" "$STUNNEL_CERT_FULLCHAIN" "$STUNNEL_CERT_PRIVKEY" &
wait "$STUNNEL_PID"