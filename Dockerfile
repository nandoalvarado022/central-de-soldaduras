FROM ubuntu:22.04

# ARG
ARG PHP_VERSION
ARG DRUSH_VERSION

#USER PARAMS
USER root

# SET TIMEZONE TO AMERICA/NEW_YORK
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata


# INSTALL NGINX
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    iputils-ping \
    lsb-release \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    patch \
    git \
    gcc \
    g++ \
    zlib1g-dev \
    libxml2-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    libssl-dev

RUN add-apt-repository ppa:ondrej/php -y && apt-get update
RUN apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-gd \
    php-pear \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-curl

# INSTALL AND CONFIGURE COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s /usr/local/bin/composer /usr/local/bin/composer.phar \
    && composer self-update \
    && composer --version

# CHANGE HOSTS FILE
COPY ./conf/hosts/hosts /etc/hosts

# LOAD CONFIG FOR NGINX
COPY ./conf/nginx/default.conf /etc/nginx/sites-available/default

# LOAD PHP.INI CUSTOM
COPY ./conf/php/php.ini /etc/php/${PHP_VERSION}/cli/php.ini

# RESTART NGINX AND PHP-FPM
RUN systemctl enable nginx && systemctl enable php${PHP_VERSION}-fpm

# Start services
CMD ["bash", "-c", "service nginx start && service php${PHP_VERSION}-fpm start && tail -f /dev/null"]