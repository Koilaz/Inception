FROM alpine:3.22

# Install dependencies
RUN apk update && apk add --no-cache \
	git \
	bash\
	make \
	g++ \
	python3 \
	php82-cgi \
	php82-session

#. Clone git repository
RUN git clone https://github.com/Koilaz/webserv.git /opt/webserv

WORKDIR /opt/webserv

# 3. Compile
RUN make

# Copy local default.conf into the container
COPY ./default.conf /opt/webserv/default.conf

EXPOSE 8080

# Run

CMD ["./webserv", "default.conf"]

