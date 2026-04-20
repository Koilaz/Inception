FROM alpine:3.22

LABEL description="Homemade Nginx Image"

RUN apk update && apk add --no-cache nginx

# 1. Create the exact same user1 with UID 1000 to match WordPress perfectly
RUN addgroup -g 1000 user1 && adduser -u 1000 -G user1 -S user1

# 2. Tell Nginx to run its worker processes as user1 instead of the default 'nginx' user
RUN sed -i 's/user nginx;/user user1;/g' /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/http.d/default.conf

# 3. Create the directory first before modifying permissions, and assign to user1
#RUN mkdir -p /var/www/html \
#	&& chown -R user1:user1 /var/www/html \
#	&& chmod -R 755 /var/www/html

EXPOSE 8080

ENTRYPOINT ["nginx", "-g", "daemon off;"]
