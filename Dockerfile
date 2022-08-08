FROM ubuntu:22.04

LABEL maintainer="vdillens dillenschneider.v@gmail.com"

ARG SERVER_HOSTNAME
ARG USER_ID
ARG DEBIAN_FRONTEND=noninteractive

# update apt cache and upgrade
RUN apt-get update && apt-get upgrade -y 

# Install utils
RUN apt-get install -y \
    git \
    software-properties-common \
    wget \
    nano \
    make \ 
    curl \
    openssl \
    unzip \ 
    acl \
    apt-utils

# Installation PHP and dependancies
RUN apt-get install -y \
    php8.1 \
    php8.1-intl \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-amqp \
    php8.1-xsl \
    php8.1-gd \
    php8.1-fpm \
    php8.1-snmp \
    php8.1-curl \
    php8.1-zip \
    composer

# Installation NodeJs and dependancies
RUN apt-get install -y \
    nodejs \
    npm

# Installation yarn module
RUN npm install -g yarn

# Installation of Apache
RUN apt-get install -y \
    apache2 \
    libapache2-mod-fcgid

# Desactivate module mpm_prefork (incompatible with http2)
RUN a2dismod mpm_prefork

# Activate module mpm_event (if not, error with others modules)
RUN a2enmod mpm_event \
    rewrite \
    ssl \
    http2 \
    proxy \
    proxy_fcgi \
    setenvif
# Activate php8-1-fpm configuration
RUN a2enconf php8.1-fpm

# Apache certificates
COPY website.conf "/etc/apache2/sites-available/${SERVER_HOSTNAME}.conf"
RUN sed -i "s/__SERVER_HOSTNAME__/${SERVER_HOSTNAME}/g" /etc/apache2/sites-available/"${SERVER_HOSTNAME}".conf
RUN a2ensite "${SERVER_HOSTNAME}"

# Change apache permissions for shared volume
RUN usermod -u ${USER_ID} www-data
RUN usermod -G staff www-data

EXPOSE 80 443

CMD service php8.1-fpm start ;  apachectl -D FOREGROUND
#CMD tail -f /dev/null
