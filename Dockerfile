FROM jenkins/inbound-agent:latest-jdk11

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y \
    binutils-mips-linux-gnu \
    build-essential \
    ccache \
    libyaml-dev \
    ninja-build \
    python3 \
    python3-pip \
    python3-setuptools \
    zlib1g-dev

RUN pip3 install ansiwrap capstone colour cxxfilt colorama gitpython lark-parser msgpack ninja_syntax pypng \
    python-Levenshtein PyYAML stringcase watchdog

RUN cp /usr/bin/ccache /usr/local/bin/
RUN ln -s ccache /usr/local/bin/gcc
RUN ln -s ccache /usr/local/bin/g++
RUN ln -s ccache /usr/local/bin/cc
RUN ln -s ccache /usr/local/bin/c++

RUN cd /usr/bin && wget https://github.com/zeldaret/oot/releases/download/0.1q/qemu-irix
RUN chmod +x /usr/bin/qemu-irix

USER jenkins
