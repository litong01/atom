FROM email4tong/hammer:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra /home/bin
COPY ./scripts/k8stool /home/bin
RUN mkdir -p /home/polaris
ENV PATH $PATH:/home/bin
ENV HOME=/home

WORKDIR /home/polaris
CMD /home/bin/astra