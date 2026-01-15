ARG BUILD_FROM
ARG BUILD_VERSION

FROM ${BUILD_FROM}

# Set some Environment Variables
ENV DEBIAN_FRONTEND noninteractive

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
        curl \
        icu-devtools \
        wget \
    && curl --proto "=https" --tlsv1.2 -sSf -L https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --install-dir /opt/dotnet --channel 9.0 --version latest --runtime aspnetcore \
    && curl --proto "=https" --tlsv1.2 -sSf -L https://download.technitium.com/dns/DnsServerPortable.tar.gz -o /tmp/DnsServerPortable.tar.gz \
    && mkdir -p /opt/dns \
    && tar -zxf DnsServerPortable.tar.gz -C /opt/dns/ \
    && apt-get purge -y --auto-remove \
        wget \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache \
        /opt/dns/start.* \
        /opt/dns/*.pdb \
        /opt/dns/systemd.service \
    && chown -R root:root /opt/dns

WORKDIR /opt/dns/

EXPOSE 443/tcp
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 5380/tcp
EXPOSE 67/udp
EXPOSE 80/tcp
EXPOSE 8053/tcp
EXPOSE 853/tcp

ARG BUILD_ARCH
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
    org.opencontainers.image.documentation="https://github.com/velvet-lab/hassio-addons/blob/main/dns/README.md" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.source="https://github.com/velvet-lab/hassio-addons/tree/main/dns" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.url="https://github.com/velvet-lab" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.version=${BUILD_VERSION}
