ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-debian:trixie}

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# SearXNG is built from the current master branch. The add-on version in
# config.yaml tracks the upstream master version (see the docs footer).

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

# Installs SearXNG from source into a dedicated virtualenv, following the
# official installation script (https://docs.searxng.org/admin/installation-scripts.html,
# utils/searxng.sh install packages + install pyenv) adapted to the container:
#   - the OS packages from the script's Debian list,
#   - the exact Python environment it creates (pip upgrade list + editable
#     `pip install --use-pep517 --no-build-isolation -e .`).
# The simple theme web client ships pre-compiled, so no Node/build step is
# needed. Redis is OPTIONAL (only for the limiter / bot protection) and is
# provided by the user, e.g. via a Redis add-on.
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
        python3-babel \
        python3-dev \
        python3-venv \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libffi-dev \
        libssl-dev \
    && git clone --depth 1 https://github.com/searxng/searxng.git /opt/searxng/searxng-src \
    && python3 -m venv /opt/searxng/venv \
    && /opt/searxng/venv/bin/pip install -U pip \
    && /opt/searxng/venv/bin/pip install -U setuptools \
    && /opt/searxng/venv/bin/pip install -U wheel \
    && /opt/searxng/venv/bin/pip install -U pyyaml \
    && /opt/searxng/venv/bin/pip install -U msgspec \
    && /opt/searxng/venv/bin/pip install -U typing-extensions \
    && /opt/searxng/venv/bin/pip install -U pybind11 \
    && cd /opt/searxng/searxng-src \
    && /opt/searxng/venv/bin/pip install --use-pep517 --no-build-isolation -e . \
    && /opt/searxng/venv/bin/pip install -r requirements-server.txt \
    && cd / \
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