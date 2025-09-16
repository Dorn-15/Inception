COMPOSE = sudo docker compose -f srcs/docker-compose.yml --env-file srcs/.env

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
	sudo docker system prune -af
	sudo rm -rf /home/adoireau/data/mariadb/*
	sudo rm -rf /home/adoireau/data/wordpress/*

re: fclean up

logs:
	$(COMPOSE) logs -f --tail=200

