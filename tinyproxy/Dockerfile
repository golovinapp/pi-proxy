FROM arm32v6/alpine:3.16
RUN apk add --no-cache tinyproxy tzdata ca-certificates gettext su-exec && update-ca-certificates
ENV TZ=UTC
COPY tinyproxy.conf.tpl /etc/tinyproxy/tinyproxy.conf.tpl
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3128/tcp
ENTRYPOINT ["/entrypoint.sh"]