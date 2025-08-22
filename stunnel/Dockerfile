FROM arm32v6/alpine:3.16
RUN apk add --no-cache stunnel tzdata bash inotify-tools procps coreutils &&     adduser -D -H -s /sbin/nologin stunnel
COPY stunnel.conf.tpl /etc/stunnel/stunnel.conf.tpl
COPY entrypoint.sh /entrypoint.sh
COPY watcher.sh /watcher.sh
RUN chmod +x /entrypoint.sh /watcher.sh
USER root
EXPOSE 443/tcp
ENTRYPOINT ["/entrypoint.sh"]