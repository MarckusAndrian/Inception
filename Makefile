NAME = inception

all: up

up:
	@mkdir -p /home/marckus/data/mariadb_data
	@mkdir -p /home/marckus/data/wordpress_data
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

stop:
	docker compose -f srcs/docker-compose.yml stop

start:
	docker compose -f srcs/docker-compose.yml start

clean: down
	docker system prune -af

fclean: clean
	@sudo rm -rf /home/marckus/data/mariadb_data
	@sudo rm -rf /home/marckus/data/wordpress_data
	docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down stop start clean fclean re
