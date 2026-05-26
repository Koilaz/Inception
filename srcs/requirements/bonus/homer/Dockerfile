FROM alpine:3.22

RUN apk add --no-cache \
        nginx \
        curl \
        unzip \
    && curl -fsSL \
        "https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip" \
        -o /tmp/homer.zip \
    && mkdir -p /var/www/homer \
    && unzip /tmp/homer.zip -d /var/www/homer \
    && rm /tmp/homer.zip \
    && mkdir -p /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
