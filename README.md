# caddy-eci

Caddy 扩展镜像，预装了常用的 DNS 和实用插件。

## 特性

- **多 DNS 支持**: AliDNS, Tencent Cloud DNS, Cloudflare
- **动态 DNS**: 自动更新域名解析
- **WebDAV**: 文件共享和同步
- **响应修改**: 替换响应内容
- **Nginx 配置兼容**: 支持 nginx 配置格式
- **Docker 服务自动发现**: 根据容器 labels 自动生成并热加载反向代理配置

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
| [caddy-docker-proxy](https://github.com/lucaslorentz/caddy-docker-proxy) | 通过 Docker labels 自动配置 Caddy |

## 镜像地址

- `ghcr.io/nekoimi/caddy-eci:latest`
- `nekoimi/caddy-eci:latest`

## 使用方法

### Docker Compose

```yaml
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
      - ./caddy_config:/config/caddy
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      CLOUDFLARE_API_TOKEN: your_token_here
      CADDY_DOCKER_CADDYFILE_PATH: /etc/caddy/Caddyfile
      CADDY_INGRESS_NETWORKS: caddy-eci-net
    restart: unless-stopped

networks:
  caddy-eci-net:
    external: true
```

首次部署前创建共享网络：

```shell
docker network create caddy-eci-net
```

`CADDY_DOCKER_CADDYFILE_PATH` 指向基础 Caddyfile。基础文件中的全局配置、非 Docker
上游和复杂路由会被保留，容器 labels 生成的站点会追加到该配置中。

### 自动发现服务

将需要代理的服务接入同一个外部网络，并添加 labels：

```yaml
services:
  app:
    image: nginx:alpine
    networks:
      - caddy-eci-net
    labels:
      caddy: app.example.com
      caddy.reverse_proxy: "{{upstreams 80}}"

networks:
  caddy-eci-net:
    external: true
```

启动或更新 `app` 后，Caddy 会自动发现容器并无中断地重新加载配置。生成后的完整
Caddyfile 默认保存在 `/config/caddy/Caddyfile.autosave`。

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
| `CADDY_DOCKER_CADDYFILE_PATH` | 需要与自动生成配置合并的基础 Caddyfile 路径 |
| `CADDY_INGRESS_NETWORKS` | Caddy 与被代理容器共用的 Docker 网络，多个网络用逗号分隔 |

## License

[MIT](LICENSE)
