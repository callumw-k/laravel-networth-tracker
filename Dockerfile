############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.3-fpm-nginx-alpine AS base

## Uncomment if you need to install additional PHP extensions
USER root
RUN install-php-extensions memcached
RUN apk add --no-cache nodejs npm

############################################
# Development Image
############################################
FROM base AS development

# We can pass USER_ID and GROUP_ID as build arguments
# to ensure the www-data user has the same UID and GID
# as the user running Docker.
ARG USER_ID
ARG GROUP_ID

# Switch to root so we can set the user ID and group ID
USER root

# Set the user ID and group ID for www-data
RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID  && \
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx

# Drop privileges back to www-data
USER www-data

############################################
# CI image
############################################
FROM base AS ci

# Sometimes CI images need to run as root
# so we set the ROOT user and configure
# the PHP-FPM pool to run as www-data
USER root
RUN echo "user = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf && \
    echo "group = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf

############################################
# Production Image
############################################
FROM base AS deploy

# Set the working directory
WORKDIR /var/www/html

# Copy only the package.json and composer.json to leverage caching
COPY --chown=www-data:www-data package*.json ./

# Install npm and PHP dependencies
RUN npm install --production

COPY --chown=www-data:www-data . .

RUN composer install --no-dev

# Copy the rest of the application code

# Build static assets if necessary
RUN npm run build

# Ensure PHP-FPM gracefully stops
STOPSIGNAL SIGQUIT

USER www-data

