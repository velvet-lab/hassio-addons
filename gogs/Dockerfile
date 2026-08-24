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

# Version of the Gogs release artifacts to download. This is used for the
# release URLs and defaults to the bundled Gogs version, so the build works
# even when BUILD_VERSION (the add-on version) is not passed explicitly.
ARG GOGS_VERSION=0.14.3

# Gogs resolves its actual configuration from the "custom" directory. By
# default that directory sits next to the gogs binary; the GOGS_CUSTOM
# environment variable redirects it. We point it at the volatile config folder
# (/etc/gogs) so Gogs loads "<custom>/conf/app.ini" which the add-on renders on
# every start. Keeping it under /etc (instead of the persistent /data/gogs data
# dir) matches the add-on convention of a regenerated config on each start.
ENV GOGS_CUSTOM=/etc/gogs

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

# Install the Gogs pre-built binary. Gogs releases provide separate tarballs
# per architecture (linux_amd64 / linux_arm64). The archive may contain a
# top-level folder, so locate the "gogs" executable and flatten its parent
# into /app/gogs. Git is required on the server side for repository
# operations, and gettext-base provides envsubst for rendering app.ini.
RUN set -x \
    && apt-get update \
    && apt-get upgrade -qy \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        dnsutils \
        gettext-base \
        git \
        git-lfs \
        jq \
        mariadb-client \
    && mkdir -p /app/gogs /tmp/gogs-pkg && \
    if [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/gogs/gogs/releases/download/v${GOGS_VERSION}/gogs_v${GOGS_VERSION}_linux_arm64.tar.gz" \
            -o /tmp/gogs.tar.gz; \
    else \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://github.com/gogs/gogs/releases/download/v${GOGS_VERSION}/gogs_v${GOGS_VERSION}_linux_amd64.tar.gz" \
            -o /tmp/gogs.tar.gz; \
    fi \
    && tar -zxf /tmp/gogs.tar.gz -C /tmp/gogs-pkg \
    && gogs_dir="$(dirname "$(find /tmp/gogs-pkg -type f -name gogs -maxdepth 2 | head -1)")" && \
    cp -r "${gogs_dir}/." /app/gogs/ && \
    rm -rf /tmp/gogs.tar.gz /tmp/gogs-pkg && \
    chmod 755 /app/gogs/gogs && \
    ln -s /app/gogs/gogs /usr/bin/gogs && \
    apt-get clean && \
    rm -rf \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/gogs" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/gogs/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}