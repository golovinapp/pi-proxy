foreground = yes
debug = 3
pid = /var/run/stunnel.pid

[https-proxy]
accept = ${STUNNEL_ACCEPT_PORT}
connect = ${STUNNEL_BACKEND_HOST}:${STUNNEL_BACKEND_PORT}
cert = ${STUNNEL_CERT_FULLCHAIN}
key  = ${STUNNEL_CERT_PRIVKEY}
TIMEOUTclose = 0
options = NO_SSLv2
options = NO_SSLv3
options = NO_TLSv1
options = NO_TLSv1.1