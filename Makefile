# Makefile

# Цвета для вывода в терминал
GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)

# Проверка наличия .env
check-env:
	@if [ ! -f .env ]; then \
		echo "❌ Файл .env не найден!"; \
		echo "👉 Скопируйте шаблон: cp .env.example .env"; \
		exit 1; \
	fi
# Очистка папки application (без подтверждения!)
clean-dir:
	@echo "$(GREEN)==> Очистка папки application$(RESET)"
	@rm -rf application/*

symfony: check-env clean-dir
	@echo "$(GREEN)==> Создание Symfony проекта внутри контейнера$(RESET)"
	@mkdir -p application
	docker compose run --rm app composer create-project symfony/website-skeleton /var/www/application
	@echo "✅ Symfony проект создан в ./application"
	@make build up

laravel-new: check-env clean-dir
	@echo "$(GREEN)==> Создание нового Laravel проекта$(RESET)"
	@mkdir -p application
	docker compose run --rm app composer create-project --prefer-dist laravel/laravel .
	@echo "✅ Laravel проект создан в ./application"
	@make build up

# Установка (проверка + поднятие контейнеров)
up: check-env
	@echo "$(GREEN)==> Запуск контейнеров$(RESET)"
	docker compose up -d --build

# Остановка контейнеров
down:
	@echo "$(GREEN)==> Остановка и удаление контейнеров$(RESET)"
	docker compose down

# Пересборка образов
build:
	@echo "$(GREEN)==> Сборка контейнеров"
	docker compose build

# Логи
logs:
	@echo "$(GREEN)==> Просмотр логов$(RESET)"
	docker compose logs -f

# Вход в PHP-контейнер
shell:
	@echo "$(GREEN)==> Вход в app-контейнер$(RESET)"
	docker compose exec app sh

# Вход в дебаг-контейнер
debug-shell:
	@echo "$(GREEN)==> Вход в app_debug-контейнер$(RESET)"
	docker compose exec app_debug sh

# Проверка PHP версии
php-info:
	@echo "$(GREEN)==> Информация о PHP$(RESET)"
	docker compose exec app php -v

# Очистка неиспользуемых образов
clean:
	@echo "$(GREEN)==> Очистка неиспользуемых образов$(RESET)"
	docker image prune -af

# Справка
help:
	@echo ""
	@echo "$(GREEN)Доступные команды:$(RESET)"
	@echo " make up		- Запустить контейнеры"
	@echo " make down		- Остановить и удалить контейнеры"
	@echo " make build		- Пересобрать образы"
	@echo " make logs		- Посмотреть логи"
	@echo " make shell		- Войти в app-контейнер"
	@echo " make debug-shell	- Войти в app_debug-контейнер"
	@echo " make php-info		- Показать версию PHP"
	@echo " make clean		- Очистить неиспользуемые образы"
	@echo " make symfony		- Создать проект на основе Symfony"
	@echo " make laravel		- Создать проект на основе Laravel"
	@echo ""