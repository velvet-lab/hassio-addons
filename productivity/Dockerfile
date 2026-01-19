ARG BUILD_FROM
ARG BUILD_VERSION
ARG BUILD_ARCH

FROM ${BUILD_FROM}

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
        gettext-base \
        git \
        icu-devtools \
        nginx \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && git config --global url."https://github.com/".insteadOf ssh://git@github.com/ \
    && apt-get install -qy --no-install-recommends \
        nodejs \
    && ln -s /etc/nginx/sites-available/productivity /etc/nginx/sites-enabled/productivity \
    && rm -f /etc/nginx/sites-enabled/default \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

WORKDIR /opt
RUN git clone -b v16.9.4 --single-branch --depth 1 https://github.com/super-productivity/super-productivity.git \
    && cd super-productivity \
    && npm install --ignore-scripts

EXPOSE 10692/tcp

ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_FROM
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY

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
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/productivity/README.md" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/productivity" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.url="https://github.com/velvet-lab" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.version=${BUILD_VERSION}
