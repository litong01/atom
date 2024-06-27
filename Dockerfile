FROM email4tong/hammer3:v0.3.0
LABEL maintainer="litong01"

COPY ./scripts/atom /home/bin
COPY ./scripts/k8stool /home/bin
COPY ./scripts/verify /home/bin
COPY ./scripts/utils /home/bin
COPY ./addon /home/addon
COPY ./jqlib /home/.jq
COPY ./trident /home/trident
COPY ./examples /home/examples
COPY ./hostpath /home/hostpath
COPY ./atom /home/startscript/atom
COPY ./atom.cmd /home/startscript/atom.cmd

RUN apk add curl bash-completion

RUN mkdir -p /home/neptune
ENV PATH /home/bin:$PATH
ENV LOCALBIN=/home/bin
ENV HOME=/home
ENV GOCACHE=/home/work/atom/gocache
ENV GOPATH=/home/work/atom/go
ENV REGISTRY=kind-registry:5001
ENV REGISTRY_USERID=
ENV REGISTRY_TOKEN=
ENV TAG=latest
ENV WORKDIR=/home/.kube
# RUN adduser -D astra && mkdir /etc/sudoers.d && \
#     echo "astra ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/astra && \
#     chmod 0440 /etc/sudoers.d/astra

WORKDIR /home/atom
CMD /home/bin/atom