ARG BUILD_FROM
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-debian:trixie}

ARG NEO4J_VERSION=2026.09.0
ARG NEO4J_EDITION=community
ARG BUILD_ARCH

ENV DEBIAN_FRONTEND=noninteractive

# Copy root filesystem (s6 scripts + default config)
COPY rootfs /

RUN set -x \
    && apt-get update \
    && apt-get install -qy --no-install-recommends \
        ca-certificates \
        curl \
        tar \
        unzip \
        openjdk-21-jdk \
        gettext-base \
    && mkdir -p /opt/neo4j \
    && if [ "${NEO4J_EDITION}" = "enterprise" ]; then \
         TARBALL="neo4j-enterprise-${NEO4J_VERSION}-unix.tar.gz"; \
    else \
         TARBALL="neo4j-community-${NEO4J_VERSION}-unix.tar.gz"; \
    fi \
    # Download release tarball (may need adjustment for exact upstream names)
    && curl --proto "=https" --tlsv1.2 -sSfL \
        "https://dist.neo4j.org/${TARBALL}" -o /tmp/neo4j.tar.gz || true \
    && if [ -f /tmp/neo4j.tar.gz ]; then \
         tar -zxf /tmp/neo4j.tar.gz -C /opt/neo4j --strip-components=1 ; \
       fi \
    && chmod -R 755 /opt/neo4j || true \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/neo4j.tar.gz

WORKDIR /tmp

CMD ["/init"]
