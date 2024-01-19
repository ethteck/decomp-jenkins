FROM jenkins/inbound-agent@sha256:6a158c98abec3dafc507c465851112b77319ca81636aee8ff854b67c2f4bbbff

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && apt-get install -y \
    binutils-mips-linux-gnu \
    build-essential \
    ccache \
    cmake \
    cpp-mips-linux-gnu \
    curl \
    gdebi \
    libcapstone-dev \
    libpng-dev \
    libyaml-dev \
    ninja-build \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    software-properties-common \
    wget \
    zlib1g-dev

# TODO: replace with WiBo and symlink wibo -> /usr/bin/wine
RUN dpkg --add-architecture i386 && apt-get update \
    && apt-get install -y \
        -o APT::Immediate-Configure=false wine32 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache --break-system-packages \
    ansiwrap \
    attrs \
    capstone \
    colorama \
    colour \
    cxxfilt \
    gitpython \
    intervaltree \
    lark-parser \
    libyaz0 \
    msgpack \
    ninja_syntax \
    pycparser \
    pyelftools \
    pylibyaml \
    pynacl \
    pypng \
    python-Levenshtein \
    python-ranges \
    pyyaml \
    rabbitizer>=1.0.0 \
    spimdisasm>=1.3.0 \
    stringcase \
    toml \
    tqdm \
    watchdog

# llvm 14
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 14 \
    && rm ./llvm.sh
RUN apt-get update && apt-get install -y \
    clang-format-14 \
    clang-tidy-14

# ccache
RUN cp /usr/bin/ccache /usr/local/bin/ \
    && ln -s ccache /usr/local/bin/gcc \
    && ln -s ccache /usr/local/bin/g++ \
    && ln -s ccache /usr/local/bin/cc \
    && ln -s ccache /usr/local/bin/c++

# qemu-irix
RUN wget -qO /usr/bin/qemu-irix https://github.com/zeldaret/oot/releases/download/0.1q/qemu-irix \
    && chmod +x /usr/bin/qemu-irix

# devkitARM
COPY --from=devkitpro/devkitarm:20220531 /opt/devkitpro /opt/devkitpro

USER jenkins

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV DEVKITPPC=${DEVKITPRO}/devkitPPC
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

# agbcc (relies on devkitARM)
RUN git clone https://github.com/pret/agbcc \
    && cd agbcc \
    && ./build.sh
ENV AGBCC=/home/jenkins/agbcc

# cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
ENV PATH=/home/jenkins/.cargo/bin:$PATH
