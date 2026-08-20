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

# Qdrant is bundled differently per architecture:
#  - amd64: official .deb package from the GitHub release
#  - aarch64: musl binary tarball (the only Linux artifact Qdrant publishes
#    for arm64). See https://github.com/qdrant/qdrant/releases
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        tar \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/qdrant/qdrant/releases/download/v${BUILD_VERSION}/qdrant-aarch64-unknown-linux-musl.tar.gz" \
            -o /tmp/qdrant.tar.gz \
        && mkdir -p /opt/qdrant \
        && tar -zxf /tmp/qdrant.tar.gz -C /opt/qdrant --strip-components=1 \
        && rm /tmp/qdrant.tar.gz \
        && ln -s /opt/qdrant/qdrant /usr/bin/qdrant; \
    else \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/qdrant/qdrant/releases/download/v${BUILD_VERSION}/qdrant_${BUILD_VERSION}-1_amd64.deb" \
            -o /tmp/qdrant.deb \
        && apt-get install -qy --no-install-recommends /tmp/qdrant.deb \
        && rm /tmp/qdrant.deb; \
    fi \
    && apt-get purge -y --auto-remove \
        curl \
        tar \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/qdrant" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/qdrant/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
