FROM php:8.2-fpm

ENV ACCEPT_EULA=Y

RUN apt-get update && apt-get install -y gnupg2

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && echo "Package: unixodbc\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: unixodbc-dev\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: libodbc1:amd64\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: odbcinst\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: odbcinst1debian2:amd64\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft

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
    npm msodbcsql18 mssql-tools18

# Очищаем кэш
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# Устанавливаем расширения PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd bcmath soap \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Загружаем актуальную версию Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Создаём пользователя и группу www для приложения Laravel
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www && \ 
    mkdir /var/www/application && \
    chown www:www /var/www/application

# # Меняем пользователя на www
USER www

WORKDIR /var/www

# В контейнере открываем 9000 порт и запускаем сервер php-fpm
EXPOSE 9000
CMD ["php-fpm"]