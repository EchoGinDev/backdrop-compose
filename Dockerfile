# ---------- Tahap 1: ambil source Backdrop CMS ----------
FROM alpine:3 AS source
RUN apk add --no-cache git \
 && git clone --branch 1.x --depth 1 https://github.com/backdrop/backdrop.git /backdrop \
 && rm -rf /backdrop/.git

# ---------- Tahap 2: image PHP + Apache ----------
FROM php:8.2-apache

# Ekstensi PHP yang dibutuhkan Backdrop + aktifkan clean URL
RUN apt-get update \
 && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install pdo_mysql mysqli gd zip \
 && a2enmod rewrite \
 && rm -rf /var/lib/apt/lists/*

# Izinkan .htaccess bawaan Backdrop dibaca Apache
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Salin source Backdrop dan settings.php kita
COPY --from=source /backdrop /var/www/html
COPY settings.php /var/www/html/settings.php

# Folder yang harus ada dan bisa ditulis Apache
RUN mkdir -p /var/www/html/files/config/active \
             /var/www/html/files/config/staging \
             /var/www/html/modules /var/www/html/themes /var/www/html/layouts \
 && chown -R www-data:www-data /var/www/html

EXPOSE 80
