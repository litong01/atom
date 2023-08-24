FROM email4tong/hammer3:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra3 /home/bin
COPY ./scripts/k8stool /home/bin
COPY ./addon /home/addon
COPY ./examples /home/examples
COPY ./hostpath /home/hostpath
RUN apk add curl sudo
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
RUN adduser -D neptune && mkdir -p /etc/sudoers.d && \
    echo "neptune ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/neptune && \
    chmod 0440 /etc/sudoers.d/neptune

USER neptune
WORKDIR /home/neptune
CMD /home/bin/astra3