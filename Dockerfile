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


FROM base as dependancies
WORKDIR /var/www/html

COPY --chown=www-data:www-data . .

RUN npm install

RUN npm run build

############################################
# Development Image
############################################
FROM base AS development

ARG USER_ID
ARG GROUP_ID

USER root

RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID  && \
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx

USER www-data

###

FROM base AS ci

USER root
RUN echo "user = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf && \
    echo "group = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf



###

FROM base AS deploy
WORKDIR /var/www/html

COPY --from=dependancies --chown=www-data:www-data /var/www/html/public/build ./public/build

COPY --chown=www-data:www-data . .

RUN composer install --no-dev

STOPSIGNAL SIGQUIT

USER www-data

