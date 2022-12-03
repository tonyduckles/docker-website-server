FROM alpine:latest
LABEL maintainer=tonyduckles

ENV	PUID=1000

RUN apk add --no-cache nginx gettext nginx-mod-http-brotli

RUN set -x \
# Forward access and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
# Create /run/nginx directory, for nginx's default PID location
	&& mkdir -p /run/nginx \
# Create empty nginx extra.conf file
	&& touch /etc/nginx/extra.conf

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

COPY ./default.conf /etc/nginx/default.conf.template

# Run envsubst's at build-time, so that the CI `nginx -t` test can verify
# the baseline rendered nginx config file.
RUN set -x \
# Generate nginx config
	&& envsubst < /etc/nginx/default.conf.template > /etc/nginx/http.d/default.conf

EXPOSE 80

HEALTHCHECK CMD nginx -t &>/dev/null \
	&& wget -O - http://localhost:80/.ping &>/dev/null \
	|| exit 1

CMD ["/docker-entrypoint.sh"]
