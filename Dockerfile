FROM alpine:3.17.2

RUN apk add --no-cache \
    inotify-tools \
    bash \
    curl \
    jq \
    && rm -rf /var/cache/apk/*

COPY dir-watcher.sh /

ENTRYPOINT ["/dir-watcher.sh"]
