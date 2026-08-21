ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-debian:trixie}

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# SearXNG git tag (or commit) to check out. Update this together with the
# add-on version in config.yaml. The tag is derived from the upstream commit
# date, e.g. "2026.8.20-487d7a96e".
ARG SEARXNG_VERSION=2026.8.20-487d7a96e

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

# Installs SearXNG from source into a dedicated virtualenv. The official
# distribution is a plain Python package: the web client (simple theme) is
# shipped pre-compiled in the repository, so no Node/build step is needed.
# Granian (from requirements-server.txt) is the WSGI server that serves the
# SearXNG application. Redis (provided by the user, e.g. a Redis add-on) is
# used for the limiter / bot protection. Search engines are queried directly
# from this container.
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        gettext-base \
        git \
        python3 \
        python3-dev \
        python3-venv \
    && git clone --depth 1 --branch "${SEARXNG_VERSION}" \
        https://github.com/searxng/searxng.git /tmp/searxng \
    && python3 -m venv /opt/searxng/venv \
    && /opt/searxng/venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel \
    && cd /tmp/searxng \
    && /opt/searxng/venv/bin/pip install --no-cache-dir . \
    && /opt/searxng/venv/bin/pip install --no-cache-dir -r requirements-server.txt \
    && cd / \
    && rm -rf /tmp/searxng \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/searxng" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/searxng/README.md" \
    org.opencontainers.image.version=${BUILD_VERSION}