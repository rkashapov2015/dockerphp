FROM php:8.2-fpm

ENV ACCEPT_EULA=Y

RUN apt-get update && apt-get install -y gnupg2

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
    unixodbc \
    libicu-dev

# НОВЫЙ СПОСОБ установки MSSQL драйверов для Debian 11 (PHP 8.2)
# Используем официальный репозиторий Microsoft
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    && curl -sSL https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        msodbcsql18 \
        mssql-tools18 \
        unixodbc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем расширения PHP
RUN docker-php-ext-install pdo pgsql pdo_pgsql pdo_mysql mbstring zip exif pcntl gd bcmath soap \
    && pecl install sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug

# Загружаем актуальную версию Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Создаём пользователя и группу www для приложения Laravel
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www && \ 
    mkdir /var/www/application && \
    chown www:www /var/www/application

# Добавляем путь до mssql-tools
ENV PATH="/opt/mssql-tools18/bin:${PATH}"

# # Меняем пользователя на www
USER www

WORKDIR /var/www

# В контейнере открываем 9000 порт и запускаем сервер php-fpm
EXPOSE 9000
CMD ["php-fpm"]
