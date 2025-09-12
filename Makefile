COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

.PHONY: up build down clean fclean re logs

up: build
	$(COMPOSE) up -d

build:
	$(COMPOSE) build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af

re: fclean up

logs:
	$(COMPOSE) logs -f --tail=200

