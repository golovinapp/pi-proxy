FROM arm32v6/alpine:3.16
RUN apk add --no-cache curl socat tzdata bash coreutils grep openssl  && adduser -D -H -s /sbin/nologin acme
ENV ACME_DIR=/acme.sh
RUN mkdir -p $ACME_DIR /certs
WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
VOLUME ["/certs", "/acme.sh"]
EXPOSE 80/tcp
ENTRYPOINT ["/entrypoint.sh"]