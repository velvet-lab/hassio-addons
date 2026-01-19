ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-debian:bookworm}

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_FROM
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Set some Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/s6-overlay/s6-rc.d ]; then chmod -R 755 /etc/s6-overlay/s6-rc.d; fi && \
    if [ -f /entrypoint.sh ]; then chmod 755 /entrypoint.sh; fi

# Set Workdir
WORKDIR /tmp

RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        dnsutils \
        gettext-base \
        git \
        icu-devtools \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        mariadb-client \
        nginx \
        php \
        php-bcmath \
        php-curl \
        php-fpm \
        php-gd \
        php-imagick \
        php-intl \
        php-json \
        php-ldap \
        php-mbstring \
        php-mysql \
        php-opcache \
        php-sqlite3 \
        php-xml \
        php-zip \
        unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s /etc/nginx/sites-available/davis /etc/nginx/sites-enabled/davis \
    && rm -f /etc/nginx/sites-enabled/default \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

WORKDIR /opt

RUN git clone -b v5.3.0 --single-branch --depth 1 https://github.com/tchapi/davis.git \
    && cd /opt/davis || exit 1 \
    && rm -rf .git .github .dockerignore .env.test ./docker ./tests \
    && APP_ENV=prod COMPOSER_ALLOW_SUPERUSER=1 composer install --no-ansi --no-dev --no-interaction --no-progress --optimize-autoloader \
    && php ./vendor/symfony/intl/Resources/bin/compress

WORKDIR /opt/davis

EXPOSE 43209/tcp

# Labels
LABEL \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.name="${BUILD_NAME}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="velvet-lab (https://github.com/velvet-lab)" \
    org.opencontainers.image.authors="velvet-lab (https://github.com/velvet-lab)" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/davis/README.md" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/davis" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.url="https://github.com/velvet-lab" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.version=${BUILD_VERSION}
