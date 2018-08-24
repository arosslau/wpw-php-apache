FROM php:5.6-apache

RUN apt-get update && apt-get install -y \
        ant \
        vim \
        git

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libmysqlclient18 \
        libicu-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) mysql \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo \ 
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) bcmath

RUN apt-get update && apt-get install -y libmemcached-dev \
        libgomp1 \
        libmagickwand-dev \
        libmagickcore-dev \
        libmagickcore-6.q16-2 \
        libmagickwand-6.q16-2 \
    && pecl install memcached-2.2.0 \
    && pecl install imagick \
    && pecl install xdebug \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable opcache

ADD php-apache/symfony.ini /usr/local/etc/php/conf.d/symfony.ini
ADD php-apache/www_werpflegtwie_de.crt /etc/apache2/ssl/www_werpflegtwie_de.crt
ADD php-apache/www_werpflegtwie_de.key /etc/apache2/ssl/www_werpflegtwie_de.key
ADD php-apache/vhost.conf /etc/apache2/sites-enabled/vhost.conf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer

RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod headers
