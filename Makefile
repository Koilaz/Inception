NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DOMAIN = $(shell grep -E '^DOMAIN_NAME=' srcs/.env | cut -d '=' -f2)

all: up

host:
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "Adding $(DOMAIN) to /etc/hosts..."; \
		sudo sh -c 'echo "127.0.0.1 $(DOMAIN)" >> /etc/hosts'; \
	fi
dir:
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb

up: host dir
	@$(COMPOSE) up -d

build: host dir
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

stop:
	@$(COMPOSE) stop

start:
	@$(COMPOSE) start

clean: down
	@echo "Clean complete."

fclean: clean
	@$(COMPOSE) down -v --rmi all
	@sudo rm -rf /home/$(USER)/data

re: fclean all

.PHONY: all up build down stop start clean fclean re
