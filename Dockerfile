FROM ubuntu:20.04 as builder

ENV GO_VER=1.19.4

ENV REGISTRY_VER=3.63.0-gitlab+es


RUN set -eux; \
    apt-get update -q; \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      ca-certificates \
      git \
      make \
      wget; \
    mkdir /build; \
    cd /build; \
    true "Install Go"; \
    wget "https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz"; \
    tar -C /usr/local -xzf "go${GO_VER}.linux-amd64.tar.gz"; \
    export PATH=$PATH:/usr/local/go/bin; \
    true "Build container-registry"; \
    git clone --depth 1 --shallow-submodules --branch "v${REGISTRY_VER}" https://gitlab.conarx.tech/gitlab/container-registry; \
    cd container-registry; \
    make



FROM gitlab/gitlab-ce:15.8.0-ce.0

MAINTAINER Conarx, Ltd <support@conarx.tech>

LABEL org.opencontainers.image.authors   = "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   = "15.8.0-ce.0"
LABEL org.opencontainers.image.base.name = "docker.io/gitlab/gitlab-ce"

COPY --from=builder /build/container-registry/bin/digest /opt/gitlab/embedded/bin/digest
COPY --from=builder /build/container-registry/bin/registry /opt/gitlab/embedded/bin/registry
COPY --from=builder /build/container-registry/bin/registry-api-descriptor-template /opt/gitlab/embedded/bin/registry-api-descriptor-template
