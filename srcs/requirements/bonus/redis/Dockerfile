FROM alpine:3.22

RUN apk add --no-cache redis

CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
