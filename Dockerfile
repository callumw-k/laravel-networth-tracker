############################################
# Base Image
############################################

# Learn more about the Server Side Up PHP Docker Images at:
# https://serversideup.net/open-source/docker-php/
FROM serversideup/php:8.3-unit AS base

## Uncomment if you need to install additional PHP extensions
USER root
RUN install-php-extensions memcached
RUN #apk add --no-cache nodejs npm


FROM node:lts-alpine AS node

WORKDIR /app

COPY package*.json vite.config.js tailwind.config.js postcss.config.js ./
COPY resources resources
COPY public public

RUN npm install
RUN npm run build

FROM base AS composer
WORKDIR /app

COPY composer*.json artisan ./
COPY bootstrap bootstrap
COPY storage storage
COPY routes routes
COPY resources/views resources/views
COPY app app
RUN composer install --no-dev


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

COPY --from=node --chown=www-data:www-data /app/public/build ./public/build


COPY --from=composer --chown=www-data:www-data /app/vendor ./vendor

COPY --chown=www-data:www-data . .


STOPSIGNAL SIGQUIT

USER www-data

