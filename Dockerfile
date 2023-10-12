FROM email4tong/hammer3:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra3 /home/bin
COPY ./scripts/k8stool /home/bin
COPY ./scripts/verify /home/bin
COPY ./addon /home/addon
COPY ./examples /home/examples
COPY ./hostpath /home/hostpath
RUN apk add curl
RUN ARCH=$(uname -m) && if [[ "${ARCH}" == "aarch64" ]]; then ARCH=arm64; fi && \
    if [[ "${ARCH}" == "x86_64" ]]; then ARCH="amd64"; fi && \
    echo "Download kind..." && \
    curl -Lso kind "https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-${ARCH}" && \
    chmod +x kind && mv kind /home/bin/kind

RUN mkdir -p /home/neptune
ENV PATH /home/bin:$PATH
ENV LOCALBIN=/home/bin
ENV HOME=/home
ENV GOCACHE=/home/work/astra3/gocache
ENV GOPATH=/home/work/astra3/go
ENV REGISTRY=
ENV REGISTRY_USERID=
ENV REGISTRY_TOKEN=
ENV TAG=latest
# RUN adduser -D astra && mkdir /etc/sudoers.d && \
#     echo "astra ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/astra && \
#     chmod 0440 /etc/sudoers.d/astra

WORKDIR /home/neptune
CMD /home/bin/astra3