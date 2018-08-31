FROM php:5.6-fpm

RUN mkdir -p /usr/share/man/man1 \
    && apt-get update \
    && apt-get install -y \
        ant \
        vim \
        git

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmariadbclient18 \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) mysql \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo \ 
    && docker-php-ext-install -j$(nproc) pdo_mysql \ 
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-install -j$(nproc) bcmath

RUN apt-get update && apt-get install -y libmemcached-dev \
        libgomp1 \
        libmagickwand-dev \
        libmagickcore-dev \
        libmagickcore-6.q16-3 \
        libmagickwand-6.q16-3 \
    && pecl install memcached-2.2.0 \
    && pecl install imagick-3.4.3 \
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable opcache

ADD rootfs/ /

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer

