ARG BASE=ubuntu
ARG TAG=22.04
FROM ${BASE}:${TAG} AS installation

ARG CODE_VERSION="4.7.1"
ARG ARCH="amd64"
ARG RELEASE_URL="github.com/coder/code-server/releases/download"

ARG USERNAME="vscode"
ARG UID=1000
ARG GID=1000
ENV USERNAME="${USERNAME}"
ENV UID=${UID}
ENV GID=${GID}

ENV DEBIAN_FRONTEND=non-interactive

ADD https://${RELEASE_URL}/v${CODE_VERSION}/code-server_${CODE_VERSION}_${ARCH}.deb /tmp/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install --no-install-recommends -y \
        asciidoc \
        autoconf \
        automake \
        bison \
        build-essential \
        ca-certificates \
        checkinstall \
        cmake \
        curl \
        dblatex \
        flex \
        g++ \
        gawk \
        gdb \
        git \
        iptables \
        iproute2 \
        libcpputest-dev \
        libdumbnet-dev \
        libfl-dev \
        libflatbuffers-dev \
        libjemalloc-dev \
        libhwloc-dev \
        libhyperscan-dev \
        libluajit-5.1-dev \
        liblzma-dev \
        libmnl-dev \
        libnetfilter-queue-dev \
        libpcap-dev \
        libpcre3-dev \
        libsafec-dev \
        libssl-dev \
        libtirpc-dev \
        libtool \
        libunwind-dev \
        locales \
        locales-all \
        make \
        nano \
        openssl \
        pkg-config \
        sudo \
        sqlite3 \
        uuid-dev \
        vim \
        w3m \
        wget \
        xz-utils \
        zlib1g-dev \
    && dpkg -i /tmp/code-server_${CODE_VERSION}_${ARCH}.deb \
    && rm -rf /tmp/* \
    && curl -fsSL https://get.docker.com | bash - \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid $GID $USERNAME \
    && useradd --uid $UID --gid $GID -m $USERNAME \
    && usermod -aG docker,sudo $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

FROM ${BASE}:${TAG}
COPY --from=installation / /
COPY commands.sh /usr/local/bin/commands.sh
RUN ["chmod", "+x", "/usr/local/bin/commands.sh"]
CMD [ "/usr/local/bin/commands.sh" ]
EXPOSE 8080
USER $USERNAME
