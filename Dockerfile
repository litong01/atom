FROM email4tong/hammer3:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra3 /home/bin
COPY ./scripts/k8stool /home/bin
COPY ./scripts/verify /home/bin
COPY ./jqlib /home/.jq
COPY ./trident /home/trident
COPY ./examples /home/examples
COPY ./hostpath /home/hostpath
COPY ./astra3 /home/startscript/astra3
COPY ./astra3.cmd /home/startscript/astra3.cmd

RUN apk add curl bash-completion

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
ENV WORKDIR=/home/.kube
# RUN adduser -D astra && mkdir /etc/sudoers.d && \
#     echo "astra ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/astra && \
#     chmod 0440 /etc/sudoers.d/astra

WORKDIR /home/neptune
CMD /home/bin/astra3