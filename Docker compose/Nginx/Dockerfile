FROM alpine:3.22

LABEL description="Homemade Nginx Image"

RUN apk update && apk add --no-cache nginx openssl

RUN addgroup -g 1000 user1 && adduser -u 1000 -G user1 -S user1

# 2. Tell Nginx to run its worker processes as user1 instead of the default 'nginx' user
RUN sed -i 's/user nginx;/user user1;/g' /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/http.d/default.conf

# Generate a self-signed SSL certificate directly in the Dockerfile
RUN mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=lmarck.42.fr/UID=lmarck"

# 3. Create the directory first before modifying permissions, and assign to user1
RUN mkdir -p /var/www/html \
	&& chown -R user1:user1 /var/www/html \
	&& chmod -R 755 /var/www/html

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]
