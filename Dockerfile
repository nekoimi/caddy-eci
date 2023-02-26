FROM caddy:2.6.4-alpine

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

COPY caddy_linux_amd64_cloudflare /usr/bin/caddy

RUN chmod +x /usr/bin/caddy
