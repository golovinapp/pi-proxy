#!/bin/sh
set -e
: "${PROXY_USER:=vpnuser}"
: "${PROXY_PASS:=changeme}"
: "${TP_PORT:=3128}"
: "${TP_MAXCLIENTS:=100}"
: "${TP_TIMEOUT:=600}"
: "${EXTRA_CONNECT_PORTS:=8443,9443,2053,2083,2087,2096}"
: "${TZ:=UTC}"

ln -sf /usr/share/zoneinfo/$TZ /etc/localtime || true
echo "$TZ" >/etc/timezone || true

# Сгенерим список дополнительных портов CONNECT
PORT_LINES=""
IFS=','; for p in $EXTRA_CONNECT_PORTS; do
  [ -n "$p" ] && PORT_LINES="$PORT_LINES\nConnectPort $p"
done; unset IFS

export PROXY_USER PROXY_PASS TP_PORT TP_MAXCLIENTS TP_TIMEOUT PORT_LINES

# Подставляем env в конфиг
envsubst < /etc/tinyproxy/tinyproxy.conf.tpl > /etc/tinyproxy/tinyproxy.conf

# Запуск в форграунде (логи в stdout)
exec tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf
EOF
chmod +x tinyproxy/entrypoint.sh

# tinyproxy/tinyproxy.conf.tpl
cat > tinyproxy/tinyproxy.conf.tpl <<'EOF'
User nobody
Group nogroup

Port ${TP_PORT}
Listen 0.0.0.0
Timeout ${TP_TIMEOUT}

# Логи идут в stdout при -d, но оставим уровень
LogLevel Info

# Размер пула/воркеров
MaxClients ${TP_MAXCLIENTS}
StartServers 5
MinSpareServers 5
MaxSpareServers 20

# Базовая авторизация прокси
BasicAuth ${PROXY_USER} ${PROXY_PASS}

# ACL: разрешаем всем (опираемся на auth)
Allow 0.0.0.0/0

# Разрешённые CONNECT-порты (по умолчанию есть 443,563; добавим ещё)
ConnectPort 443
ConnectPort 563
${PORT_LINES}

# Без X-Forwarded-For
DisableViaHeader Yes

# Не подменяем заголовки
ViaProxyName "."