NAME = inception

all: up

up:
	@mkdir -p /home/kandrian/data/mariadb_data
	@mkdir -p /home/kandrian/data/wordpress_data
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
	@docker run --rm --privileged -v /home/kandrian/data:/data debian:bookworm sh -c "rm -rf /data/*" 2>/dev/null || true
	@rm -rf /home/kandrian/data
	docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down stop start clean fclean re
