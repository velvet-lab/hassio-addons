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
        ca-certificates \
        curl \
        gettext-base \
        icu-devtools \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then \
            ARTIFACT_URL="https://github.com/portainer/portainer/releases/download/2.33.6/portainer-2.33.6-linux-amd64.tar.gz"; \
        elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
            ARTIFACT_URL="https://github.com/portainer/portainer/releases/download/2.33.6/portainer-2.33.6-linux-arm64.tar.gz"; \
        else \
            echo "Unsupported architecture: ${BUILD_ARCH}" && exit 1; \
        fi \
    && curl --proto "=https" --tlsv1.2 -sSf -L "$ARTIFACT_URL" -o  /tmp/portainer.tar.gz  \
    && tar -xzf /tmp/portainer.tar.gz -C /tmp/ \
    && chmod +x /tmp/portainer \
    && mv /tmp/portainer /opt/ \
    && rm -rf /tmp/portainer* \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

EXPOSE 9000/tcp
EXPOSE 8000/tcp

WORKDIR /opt/portainer

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
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/portainer/README.md" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/portainer" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.url="https://github.com/velvet-lab" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.version=${BUILD_VERSION}
