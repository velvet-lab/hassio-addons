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

# Version of LiteLLM to install. Defaults to the bundled version so the build
# works even when BUILD_VERSION (the add-on version) is not passed.
ARG LITELLM_VERSION=v1.98.0-stable

# LiteLLM runs from /app with config at /etc/litellm
WORKDIR /app

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

# Install LiteLLM via pip. LiteLLM is a Python package that provides the proxy
# server and SDK. We install the [proxy] extra which includes the web UI and
# all proxy dependencies. Dependencies: python3, pip, ca-certificates for HTTPS,
# gettext-base for envsubst to render config, curl for health checks, dnsutils
# (dig) for service host resolution, and mariadb-client for MySQL connectivity.
# PyMySQL is added for SQLAlchemy MySQL support.
# Note: LiteLLM requires Python 3.10+, which is available in Debian Trixie.
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        dnsutils \
        gettext-base \
        mariadb-client \
        python3 \
        python3-pip \
        python3-venv \
        tzdata \
    && python3 -m venv /opt/litellm \
    && /opt/litellm/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/litellm/bin/pip install --no-cache-dir "litellm[proxy]==$(echo ${LITELLM_VERSION} | sed 's/^v//')" \
    && /opt/litellm/bin/pip install --no-cache-dir pymysql \
    && ln -sf /opt/litellm/bin/litellm /usr/local/bin/litellm \
    && mkdir -p /app /etc/litellm /homeassistant/addons/litellm \
    && chmod 755 /app /etc/litellm \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache \
        /tmp/*

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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/litellm" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/litellm/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
