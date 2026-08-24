ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-debian:trixie}

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_FROM
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Version of the New API release to download. The GitHub releases provide one
# pre-built Linux binary per architecture. Defaults to the bundled version so
# the build works even when BUILD_VERSION (the add-on version) is not passed.
ARG NEWAPI_VERSION=1.0.0-rc.25

# New API reads its settings from a .env file in the current working directory
# (godotenv.Load(".env")) and stores the SQLite database relative to it.
WORKDIR /data/newapi

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

# Install the New API pre-built binary. New API is a Go web service; the
# release assets are statically linked binaries named new-api-vX / new-api-arm64-vX.
# ca-certificates is required for outbound HTTPS to model providers, tzdata
# provides timezone data, and gettext-base provides envsubst to render .env.
# dnsutils (dig) and mariadb-client are used when the add-on connects to the
# MariaDB add-on (resolve the service host and create the database).
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        dnsutils \
        gettext-base \
        mariadb-client \
        tzdata \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/QuantumNous/new-api/releases/download/v${NEWAPI_VERSION}/new-api-arm64-v${NEWAPI_VERSION}" \
            -o /usr/bin/new-api; \
    else \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/QuantumNous/new-api/releases/download/v${NEWAPI_VERSION}/new-api-v${NEWAPI_VERSION}" \
            -o /usr/bin/new-api; \
    fi \
    && chmod 755 /usr/bin/new-api \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="velvet-lab (https://github.com/velvet-lab)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="velvet-lab (https://github.com/velvet-lab)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/velvet-lab" \
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/newapi" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/newapi/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}