FROM email4tong/hammer:v0.1.0
LABEL maintainer="litong01"

COPY ./scripts/astra /home/bin
COPY ./scripts/k8stool /home/bin
COPY ./scripts/astraimage /home/bin
COPY ./scripts/pcloud-port-forward /home/bin
COPY ./scripts/postsetup.py /home/bin
COPY ./scripts/serviceaccount.py /home/bin
COPY ./scripts/tridentctl /home/bin
COPY ./addon /home/addon
COPY ./trident /home/trident
COPY ./acc /home/acc
COPY ./ldap /home/ldap
RUN mkdir -p /home/polaris
ENV PATH $PATH:/home/bin
ENV HOME=/home

WORKDIR /home/polaris
CMD /home/bin/astra