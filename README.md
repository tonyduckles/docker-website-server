# Docker Website Server

[![CI](https://github.com/tonyduckles/docker-website-server/actions/workflows/ci.yml/badge.svg)](https://github.com/tonyduckles/docker-website-server/actions/workflows/ci.yml)

Customizable and performant container for hosting websites - Powered by Nginx

## _"Why not just use `nginx:alpine`?"_

If you're not really bothered, the default `nginx` container will work just fine for you, however this container has a few modifications which make it more suited to serving sites:

- Use environment variables for [customization](#customization)
- Healthcheck endpoint
- GZIP and Brotli support
- Serve pre-compressed files
- Use `X-Forwarded-For` header when getting client IP

Nginx makes a brilliant file server regardless of how you use it.

## Usage

```yml
version: "2.3"

services:
  web:
    image: ghcr.io/tonyduckles/website-server:latest
    volumes:
      - ".:/srv:ro"
    ports:
      - "80:80"
```

The server will serve files in the `/srv` directory. This directory can be mounted read-only.


## Customization

This image supports some customizations:

- `$PUID`: Set the user nginx runs as (default `1000`)

If you'd rather add some additional configuration yourself, you can mount an additional nginx config at `/etc/nginx/extra.conf`, which will be included in the primary config.
