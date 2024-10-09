FROM php:8.2-fpm

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    nano \
    unzip \
    git \
    curl \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    libxml2-dev \
    unixodbc-dev \
    npm
# Очищаем кэш
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# Устанавливаем расширения PHP
RUN docker-php-ext-install pdo pdo_mysql pgsql pdo_pgsql mbstring zip exif pcntl gd bcmath soap \
    && pecl install pdo_sqlsrv-5.10.1 \
    && docker-php-ext-enable pdo_sqlsrv

# Загружаем актуальную версию Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Создаём пользователя и группу www для приложения Laravel
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www && \ 
    mkdir /var/www/application && \
    chown www:www /var/www/application
# # Копируем содержимое текущего каталога в рабочую директорию
# COPY --chown=www:www application /var/www/application
# # Меняем пользователя на www
USER www

WORKDIR /var/www

# В контейнере открываем 9000 порт и запускаем сервер php-fpm
EXPOSE 9000
CMD ["php-fpm"]