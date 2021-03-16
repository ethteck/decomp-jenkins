FROM jenkins/inbound-agent:latest-jdk11

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y \
    binutils-mips-linux-gnu \
    build-essential \
    libyaml-dev \
    ninja-build \
    python3 \
    python3-pip \
    python3-setuptools \
    zlib1g-dev

RUN pip3 install ansiwrap capstone colour cxxfilt colorama gitpython lark-parser msgpack ninja_syntax pypng \
    python-Levenshtein PyYAML stringcase watchdog

USER jenkins
