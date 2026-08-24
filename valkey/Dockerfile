ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-ubuntu:22.04}

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_FROM
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

# Version of the prebuilt Valkey binary artifact to download. This matches the
# bundled Valkey version and is used for the release URL, so the build works
# even when BUILD_VERSION (the add-on version) is not passed explicitly.
ARG VALKEY_VERSION=9.1.1

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

# Valkey publishes prebuilt binary artifacts per target distribution and
# architecture. This add-on uses the jammy (Ubuntu 22.04) base images, so the
# matching jammy artifacts are downloaded directly - no compilation needed.
# See https://valkey.io/download/
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        curl \
        gettext-base \
        procps \
        tar \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://download.valkey.io/releases/valkey-${VALKEY_VERSION}-jammy-arm64.tar.gz" \
            -o /tmp/valkey.tar.gz; \
    else \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://download.valkey.io/releases/valkey-${VALKEY_VERSION}-jammy-x86_64.tar.gz" \
            -o /tmp/valkey.tar.gz; \
    fi \
    && tar -zxf /tmp/valkey.tar.gz -C /tmp \
    && cp /tmp/valkey-${VALKEY_VERSION}-jammy-*/bin/valkey-server /usr/local/bin/ \
    && cp /tmp/valkey-${VALKEY_VERSION}-jammy-*/bin/valkey-cli /usr/local/bin/ \
    && cp /tmp/valkey-${VALKEY_VERSION}-jammy-*/bin/valkey-benchmark /usr/local/bin/ \
    && rm -rf /tmp/valkey.tar.gz /tmp/valkey-${VALKEY_VERSION}-jammy-* \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/valkey" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/valkey/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}