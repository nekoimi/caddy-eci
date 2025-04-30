FROM caddy/caddy:builder-alpine as builder

#ENV GO111MODULE=on
#ENV GOPROXY=https://goproxy.cn,direct

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && apk add --no-cache git;

RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/caddy-dns/tencentcloud \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/caddyserver/replace-response \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddyserver/nginx-adapter \
    --with github.com/mholt/caddy-dynamicdns

FROM caddy/caddy:alpine

LABEL maintainer="nekoimi <nekoimime@gmail.com>"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
