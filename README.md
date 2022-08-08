# Symfony-docker

Symfony-docker allow to set up an apache server (Http2 + SSL) with all dependencies (PHP 8.1) in a container (Ubuntu 22.04).

## Prerequisites 

Docker need to be setup in your host system and openssl too (in order to generate certificate).

## Installation

### 1/ Clone the repository

The first thing to do is clone the repository with the git clone command.

### 2/ Generate the certificate

After cloning the project, you need to go in the directory and then generate the certificates for Apache SSL. The generated files need to be named : __apache-server.crt__ and __apache-server.key__.


*Exemple of a command to generate theses files in the project :*

    openssl req -x509 -new -out apache-server.crt -keyout apache-server.key -days 3650 -newkey rsa:4096 -sha256 -nodes

### 3/ Customize the parameters

Copy the file .env.dist to .env and customize the parameters inside :

| Parameter | Type | Description | 
|-----------|------|-------------|
| SERVER_HOSTNAME | String | The hostname of your new apache server |
| SERVER_HOST_HTTP_PORT | String | The port of the host where your project will be setup |
| SERVER_HOST_HTTPS_PORT | String | The port of the host where your project will be setup in https |
| VOLUME_SYMFONY_FILES | String | The fodler where your Symfony project server is on the host server|
| UID | Numeric | The user id of the volume's owner |

### 4/ Set the hostname in your DNS or your host file

In order to access to your new server, you need to add the hostname in your DNS or hostfile of your system.

### 5/ Launch the docker

You can now launch the docker (in daemon) with the command

    docker-compose up -d

### 6/ Access to your server

With the url **https://SERVER_HOSTNAME/** you can access to your new server.

### 7/ Enjoy with Symfony

On your host system, you can finally put your Symfony files in the shared folder (default : /var/www/html) with your container.







