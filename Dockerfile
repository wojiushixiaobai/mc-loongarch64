FROM jumpserver/golang:1.22-buster AS builder-mc
ARG TARGETARCH
ARG MC_VERSION=RELEASE.2024-07-15T17-46-06Z

WORKDIR /opt
RUN set -ex \
    && git clone -b ${MC_VERSION} --depth=1 https://github.com/minio/mc.git

ARG GOPROXY=https://goproxy.cn,direct
WORKDIR /opt/mc
RUN set -ex \
    && MC_RELEASE="RELEASE" make build \
    && echo $(sha256sum mc) > mc.sha256sum \
    && ./mc --version

FROM debian:buster-slim
ARG TARGETARCH

WORKDIR /opt/mc

COPY --from=builder-mc /opt/mc/mc /opt/mc/dist/mc
COPY --from=builder-mc /opt/mc/mc.sha256sum /opt/mc/dist/mc.sha256sum

VOLUME /dist

CMD cp -rf dist/* /dist/