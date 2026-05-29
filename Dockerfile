FROM php:8.1-fpm-alpine

# Install system dependencies and PHP extensions required by Mautic
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    libxml2-dev \
    imap-dev \
    openssl-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure imap --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) gd bcmath zip intl xml opcache pdo_mysql imap

# Set up working directory
WORKDIR /app

# Copy your actual repository code into the container
COPY . /app

# Install Composer dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Set up permissions for Mautic execution
RUN chown -R www-data:www-data /app

EXPOSE 80

CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
