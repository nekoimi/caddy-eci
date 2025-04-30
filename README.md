# caddy-eci

添加扩展功能

### use

```yaml
version: "3.6"
services:
  caddy-eci:
    image: ghcr.io/nekoimi/caddy-eci:latest
    container_name: caddy-eci
    hostname: caddy-eci
    ports:
      - "443:443"
    networks:
      - caddy-eci-net
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy_data:/data/caddy
    environment:
      K: V
    restart: always

networks:
  caddy-eci-net:
    driver: bridge
```
