#!/bin/sh
set -e
: "${PROXY_USER:=vpnuser}"
: "${PROXY_PASS:=changeme}"
: "${PROXY_MAX_CONN:=2000}"
: "${TZ:=UTC}"
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime || true
echo "$TZ" >/etc/timezone || true
export PROXY_USER PROXY_PASS PROXY_MAX_CONN
mkdir -p /etc/3proxy /var/log/3proxy
envsubst < /etc/3proxy/3proxy.cfg.tpl > /etc/3proxy/3proxy.cfg
chown -R 3proxy:3proxy /var/log/3proxy
exec su-exec 3proxy /usr/local/3proxy/bin/3proxy /etc/3proxy/3proxy.cfg