FROM email4tong/hammer3:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra3 /home/bin
COPY ./scripts/k8stool /home/bin
RUN mkdir -p /home/neptune
ENV PATH /home/bin:$PATH
ENV LOCALBIN=/home/bin
ENV HOME=/home
ENV GOCACHE=/home/work/astra3/gocache
ENV GOPATH=/home/work/astra3/go

WORKDIR /home/neptune
CMD /home/bin/astra3