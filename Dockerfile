FROM mback2k/apache2-php

ARG PHP_VERSION=7.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php${PHP_VERSION}-curl php${PHP_VERSION}-gd \
        php${PHP_VERSION}-xml php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql curl unzip && \
    apt-get install -y --no-install-recommends \
        msmtp msmtp-mta && \
    apt-get clean

RUN a2enmod rewrite headers env setenvif

RUN mkdir -p /var/www
WORKDIR /var/www

ARG MATOMO_VERSION=3.13.4

ADD https://builds.matomo.org/matomo-${MATOMO_VERSION}.zip /var/www
RUN unzip matomo-${MATOMO_VERSION}.zip

RUN chown root:root -R /var/www/matomo
RUN chown www-data:www-data -R /var/www/matomo/tmp

RUN mv /var/www/matomo/matomo.js /var/www/matomo/config/matomo.js
RUN ln -s /var/www/matomo/config/matomo.js /var/www/matomo/matomo.js

RUN chown www-data:www-data -R /var/www/matomo/config
RUN cp -ar /var/www/matomo/config -T /var/cache/matomo-config-dist
VOLUME /var/www/matomo/config

ENV MATOMO_CONFIG_DIR /var/www/matomo/config
ENV MATOMO_CONFIG_DIST_DIR /var/cache/matomo-config-dist

ADD docker-entrypoint.d/ /run/docker-entrypoint.d/
ADD docker-websites.d/ /run/docker-websites.d/

HEALTHCHECK CMD killall -0 run-parts || curl -f http://localhost/matomo.php || exit 1
