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

# Version of the Gitea release artifacts to download. This is used for the
# release URLs and defaults to the bundled Gitea version, so the build works
# even when BUILD_VERSION (the add-on version) is not passed explicitly.
ARG GITEA_VERSION=1.27.2

# Gitea resolves its actual configuration from the "custom" directory. By
# default that directory sits next to the gitea binary; the GITEA_CUSTOM
# environment variable redirects it. We point it at the volatile config folder
# (/etc/gitea) so Gitea loads "<custom>/conf/app.ini" which the add-on renders
# on every start. The GITEA_WORK_DIR tells Gitea where to base its working
# directory; the persistent data lives under /data/gitea (see app.ini).
ENV GITEA_CUSTOM=/etc/gitea
ENV GITEA_WORK_DIR=/data/gitea

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

# Install the Gitea pre-built binary. Gitea provides a plain (non-tarball)
# self-extracting binary per architecture (linux-amd64 / linux-arm64) at
# dl.gitea.com. Git is required on the server side for repository operations,
# and gettext-base provides envsubst for rendering app.ini.
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
        openssh-client \
    && mkdir -p /app/gitea && \
    if [ "${BUILD_ARCH}" = "aarch64" ]; then \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://dl.gitea.com/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-arm64" \
            -o /app/gitea/gitea; \
    else \
        curl --proto "=https" --tlsv1.2 -sSfL \
            "https://dl.gitea.com/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64" \
            -o /app/gitea/gitea; \
    fi \
    && chmod 755 /app/gitea/gitea \
    && ln -s /app/gitea/gitea /usr/bin/gitea \
    && apt-get clean && \
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
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/gitea" \
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/gitea/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
