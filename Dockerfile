FROM php:8.3.0-cli

WORKDIR /code

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN apt-get update && apt-get upgrade -y && apt-get install -y locales curl zip unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-source delete && apt-get purge curl -y && \
    apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y

RUN groupadd -g 1000 rector && useradd -u 1000 -ms /bin/bash -g rector rector

USER rector

RUN composer global require rector/rector --dev

ENTRYPOINT ["/bin/bash", "-c", "~/.composer/vendor/bin/rector"]