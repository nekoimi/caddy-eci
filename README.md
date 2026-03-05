# caddy-eci

Caddy 扩展镜像，预装了常用的 DNS 和实用插件。

## 特性

- **多 DNS 支持**: AliDNS, Tencent Cloud DNS, Cloudflare
- **动态 DNS**: 自动更新域名解析
- **WebDAV**: 文件共享和同步
- **响应修改**: 替换响应内容
- **Nginx 配置兼容**: 支持 nginx 配置格式

## 已安装插件

| 插件 | 描述 |
|------|------|
| [alidns](https://github.com/caddy-dns/alidns) | 阿里云 DNS 支持 |
| [tencentcloud](https://github.com/caddy-dns/tencentcloud) | 腾讯云 DNS 支持 |
| [cloudflare](https://github.com/caddy-dns/cloudflare) | Cloudflare DNS 支持 |
| [dynamicdns](https://github.com/mholt/caddy-dynamicdns) | 动态 DNS 更新 |
| [webdav](https://github.com/mholt/caddy-webdav) | WebDAV 服务器 |
| [replace-response](https://github.com/caddyserver/replace-response) | 响应内容替换 |
| [transform-encoder](https://github.com/caddyserver/transform-encoder) | 日志转换编码器 |
| [nginx-adapter](https://github.com/caddyserver/nginx-adapter) | Nginx 配置适配器 |

## 镜像地址

- `ghcr.io/nekoimi/caddy-eci:latest`
- `nekoimi/caddy-eci:latest`

## 使用方法

### Docker Compose

```yaml
version: "3.6"
services:
  caddy-eci:
    image: ghcr.io/nekoimi/caddy-eci:latest
    container_name: caddy-eci
    hostname: caddy-eci
    ports:
      - "80:80"
      - "443:443"
    networks:
      - caddy-eci-net
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy_data:/data/caddy
    environment:
      - CLOUDFLARE_API_TOKEN=your_token_here
    restart: always

networks:
  caddy-eci-net:
    driver: bridge
```

### Caddyfile 示例

#### 基础 HTTPS 站点
```caddy
example.com {
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    respond "Hello, World!"
}
```

#### WebDAV 服务器
```caddy
dav.example.com {
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
    webdav {
        root /data/dav
        prefix /dav
    }
}
```

#### 动态 DNS
```caddy
{
    dynamic_dns {
        provider cloudflare {env.CLOUDFLARE_API_TOKEN}
        domains {
            example.com
        }
    }
}
```

## 环境变量

| 变量 | 说明 |
|------|------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API Token |
| `ALIYUN_ACCESS_KEY_ID` | 阿里云 Access Key ID |
| `ALIYUN_ACCESS_KEY_SECRET` | 阿里云 Access Key Secret |

## License

[MIT](LICENSE)
