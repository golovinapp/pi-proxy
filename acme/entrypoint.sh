#!/bin/bash
set -e
: "${ACME_DOMAIN:?ACME_DOMAIN is required}"
: "${ACME_EMAIL:?ACME_EMAIL is required}"
: "${ACME_STAGING:=0}"
: "${TZ:=UTC}"
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime || true
echo "$TZ" >/etc/timezone || true
ACME_HOME=/acme.sh
CERT_DIR=/certs
if [ ! -x "${ACME_HOME}/acme.sh" ]; then
  echo "[acme] Installing acme.sh ..."
  curl -fsSL https://get.acme.sh | sh -s email=${ACME_EMAIL} --home ${ACME_HOME}
fi
SERVER="letsencrypt"
if [ "$ACME_STAGING" = "1" ]; then
  SERVER="letsencrypt_test"
fi
${ACME_HOME}/acme.sh --set-default-ca --server ${SERVER} --home ${ACME_HOME}
if ! ${ACME_HOME}/acme.sh --home ${ACME_HOME} --list | grep -q " ${ACME_DOMAIN} "; then
  echo "[acme] Issuing new certificate for ${ACME_DOMAIN}"
  ${ACME_HOME}/acme.sh --home ${ACME_HOME} --issue --standalone -d ${ACME_DOMAIN} --keylength ec-256
fi
${ACME_HOME}/acme.sh --home ${ACME_HOME} --install-cert -d ${ACME_DOMAIN} --ecc   --fullchain-file ${CERT_DIR}/fullchain.pem   --key-file ${CERT_DIR}/privkey.pem
echo "[acme] Initial cert ready at ${CERT_DIR}"
while true; do
  ${ACME_HOME}/acme.sh --home ${ACME_HOME} --cron --force --ecc
  ${ACME_HOME}/acme.sh --home ${ACME_HOME} --install-cert -d ${ACME_DOMAIN} --ecc     --fullchain-file ${CERT_DIR}/fullchain.pem     --key-file ${CERT_DIR}/privkey.pem
  sleep 43200
done