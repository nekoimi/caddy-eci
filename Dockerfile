FROM caddy:2.6.2-builder-alpine AS builder

RUN xcaddy build --with github.com/caddy-dns/alidns

FROM caddy:2.6.2-alpine

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
