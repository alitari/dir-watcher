FROM alpine:3.17.2

RUN apk add --no-cache \
    inotify-tools \
    bash \
    curl \
    jq \
    && rm -rf /var/cache/apk/*

COPY watchdir.sh /

ENTRYPOINT ["/watchdir.sh"]
