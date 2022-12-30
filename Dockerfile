FROM caddy:2.6.2-builder-alpine AS builder

ENV GOPROXY=https://mirrors.aliyun.com/goproxy/

RUN xcaddy build --with github.com/caddy-dns/alidns

FROM caddy:2.6.2-alpine

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
