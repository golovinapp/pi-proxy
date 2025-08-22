# threeproxy/Dockerfile
FROM arm32v6/alpine:3.16 AS builder
RUN apk add --no-cache build-base linux-headers git ca-certificates && update-ca-certificates
WORKDIR /build
RUN git clone --depth=1 https://github.com/3proxy/3proxy.git
WORKDIR /build/3proxy
RUN make -f Makefile.Linux && \
    if [ -f bin/3proxy ]; then cp bin/3proxy /tmp/3proxy; else cp src/3proxy /tmp/3proxy; fi

FROM arm32v6/alpine:3.16
RUN apk add --no-cache ca-certificates libstdc++ gettext su-exec tzdata && update-ca-certificates \
 && adduser -D -H -s /sbin/nologin 3proxy
COPY --from=builder /tmp/3proxy /usr/local/3proxy/bin/3proxy
COPY threeproxy.cfg.tpl /etc/3proxy/3proxy.cfg.tpl
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME ["/var/log/3proxy"]
EXPOSE 3128/tcp 1080/tcp
ENTRYPOINT ["/entrypoint.sh"]
