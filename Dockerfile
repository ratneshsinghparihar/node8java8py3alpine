FROM alpine:3.7 as Stage1

## JAVA installation
RUN \
  apk update && \
  apk fetch openjdk8 && \
  apk add openjdk8 && \
  rm -rf /var/cache/apk/*

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

## PYTHON installation and Panda package
FROM Stage1 as Stage2
RUN apk add --update \
    python3\
    python3-dev\
    py3-pip \
    build-base \
    g++ \
    openssl-dev \
    libffi-dev \
    perl \
  && rm -rf /var/cache/apk/* \
  && ln -s /usr/bin/python3.6 /usr/bin/python

FROM Stage2 as Stage3
RUN pip3 install numpy==1.16.4
RUN pip3 install Cython


FROM Stage3 as Stage4
RUN pip3 uninstall pandas
RUN pip3 install --no-cache pandas==0.24.2

# NODE installation
FROM Stage4 as Stage5
RUN apk add  --no-cache \
--repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1

RUN apk add --update \
    perl \
    git \
    bash

RUN node -v
RUN java -version
RUN python --version
RUN python3 --version