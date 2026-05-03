FROM alpine:3.22

RUN apk update && \
	apk add --no-cache redis

# Copy custom config or directly modify the default alpine redis config
RUN sed -i "s|bind 127.0.0.1|bind 0.0.0.0|g" /etc/redis.conf && \
	sed -i "s|# maxmemory <bytes>|maxmemory 256mb|g" /etc/redis.conf && \
	sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis.conf && \
	sed -i "s|daemonize yes|daemonize no|g" /etc/redis.conf

# Do not run as root
USER redis

EXPOSE 6379

CMD ["redis-server", "/etc/redis.conf"]

