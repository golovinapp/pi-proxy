daemon
maxconn ${PROXY_MAX_CONN}
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
auth strong
users ${PROXY_USER}:CL:${PROXY_PASS}
allow ${PROXY_USER}
log /var/log/3proxy/%y%m%d.log D
rotate 30
proxy -p3128 -a
socks -p1080
flush