FROM php:8.0.20-fpm-alpine

RUN set -ex

ARG TMP_PACKAGES='autoconf freetype-dev g++ gd-dev git gmp-dev imagemagick-dev libjpeg-turbo-dev libmemcached-dev libpng-dev libtool libwebp-dev libxpm-dev libzip-dev make'
ARG RUN_PACKAGES='bash cyrus-sasl-dev gd gmp imagemagick libltdl libmemcached libwebp libxml2-dev libxpm libzip'

RUN echo "$TMP_PACKAGES"
RUN echo "$RUN_PACKAGES"

RUN apk add --update --no-cache $TMP_PACKAGES $RUN_PACKAGES;

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp --with-xpm;

RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS";

RUN docker-php-source extract;

RUN docker-php-ext-install exif gd gmp mysqli opcache pcntl soap sockets zip;
# RUN pecl install apcu igbinary imagick memcached redis xdebug;
# RUN docker-php-ext-enable apcu igbinary imagick memcached redis xdebug;

RUN docker-php-source delete;

RUN apk del $TMP_PACKAGES;
RUN rm -rf /tmp/* /var/cache/apk/*;
