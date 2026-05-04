FROM php:8.2-fpm-alpine AS base

RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev libjpeg-turbo-dev libwebp-dev \
    libzip-dev zip unzip \
    oniguruma-dev \
    && docker-php-ext-install \
        pdo pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY . .

RUN composer dump-autoload --optimize

RUN chown -R www-data:www-data /var/www/html/storage \
                                /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage \
                    /var/www/html/bootstrap/cache

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
