FROM php:7.2-fpm-stretch

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list \
    && mkdir -p /usr/share/man/man1 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -y \
    && apt-get -t stretch-backports install -y openjdk-8-jre-headless ca-certificates-java

RUN apt-get update && apt-get install -y \
        ant \
        vim \
        git

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        default-libmysqlclient-dev \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo \ 
    && docker-php-ext-install -j$(nproc) pdo_mysql

RUN apt-get update && apt-get install -y libmemcached-dev \
        libgomp1 \
        libmagickwand-dev \
        libmagickcore-dev \
    && pecl install memcached-3.0.4 \
    && pecl install imagick \
    && pecl install xdebug \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable opcache

ADD php/symfony.ini /usr/local/etc/php/conf.d/symfony.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
