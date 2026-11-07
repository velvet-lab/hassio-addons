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

# Version of the Obot image to bundle. This is the image tag referenced by the
# generated Docker tunnel command in the Obot UI and must match the running
# Obot server version.
ARG OBOT_VERSION=v0.27.0

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

# The tunnel client runs the 'obot' binary from the official GitHub releases.
# It is a self-contained, statically linked Go application with no runtime
# dependencies, so no further installation steps are required.
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
    && OBOT_ARCH="${BUILD_ARCH:-amd64}" \
    && case "${OBOT_ARCH}" in \
        aarch64|arm64) OBOT_ARCH="arm64" ;; \
        *) OBOT_ARCH="amd64" ;; \
    esac \
    && curl --proto "=https" --tlsv1.2 -sSfL \
        "https://github.com/obot-platform/obot/releases/download/${OBOT_VERSION}/obot_${OBOT_VERSION#v}_linux_${OBOT_ARCH}.tar.gz" \
        -o /tmp/obot.tar.gz \
    && tar -zxf /tmp/obot.tar.gz -C /tmp \
    && cp /tmp/obot /usr/local/bin/obot \
    && chmod 755 /usr/local/bin/obot \
    && /usr/local/bin/obot --version \
    && rm -rf /tmp/obot.tar.gz /tmp/obot
    && apt-get clean \
    && rm -rf \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/obot-tunnel" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/obot-tunnel/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}