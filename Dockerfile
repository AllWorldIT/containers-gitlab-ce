# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


FROM ubuntu:22.04 as builder

ENV GO_VER=1.21.4

ENV REGISTRY_VER=3.86.1-gitlab+es


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
    make; \
    ls -la bin/



FROM gitlab/gitlab-ce:16.6.2-ce.0

MAINTAINER Conarx, Ltd <support@conarx.tech>

LABEL org.opencontainers.image.authors   "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   "16.6.2-ce.0"
LABEL org.opencontainers.image.base.name "docker.io/gitlab/gitlab-ce:16.6.2-ce.0"

COPY --from=builder /build/container-registry/bin/digest /opt/gitlab/embedded/bin/digest
COPY --from=builder /build/container-registry/bin/registry /opt/gitlab/embedded/bin/registry
