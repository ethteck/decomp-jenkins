FROM jenkins/inbound-agent

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Combine apt-get update and install commands, and clean up after installation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ccache \
    cmake \
    cpp-mips-linux-gnu \
    curl \
    gdebi \
    libcapstone-dev \
    libpng-dev \
    libxml2-dev \
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
    zlib1g-dev \
    clang-format-14 \
    clang-tidy-14 \
    && rm -rf /var/lib/apt/lists/*

# Install binutils for mips-linux-gnu and build it
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz \
    && tar -xvf binutils-2.42.tar.gz \
    && cd binutils-2.42 \
    && ./configure --target=mips-linux-gnu --disable-multilib \
    && make \
    && make install \
    && cd .. \
    && rm -rf binutils-2.42 binutils-2.42.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add i386 architecture and install wine32, then clean up
RUN dpkg --add-architecture i386 && apt-get update \
    && apt-get install -y --no-install-recommends \
        -o APT::Immediate-Configure=false wine32 \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --break-system-packages --no-cache-dir \
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

# ccache setup
RUN cp /usr/bin/ccache /usr/local/bin/ \
    && ln -s /usr/local/bin/ccache /usr/local/bin/gcc \
    && ln -s /usr/local/bin/ccache /usr/local/bin/g++ \
    && ln -s /usr/local/bin/ccache /usr/local/bin/cc \
    && ln -s /usr/local/bin/ccache /usr/local/bin/c++

# Copy devkitARM from another image
COPY --from=devkitpro/devkitarm:20220531 /opt/devkitpro /opt/devkitpro


# Set up Jenkins user 
USER jenkins

# Environment variables for devkitARM
ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV DEVKITPPC=${DEVKITPRO}/devkitPPC
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

# Clone and build agbcc
RUN git clone https://github.com/pret/agbcc /home/jenkins/agbcc \
    && cd /home/jenkins/agbcc \
    && ./build.sh
ENV AGBCC=/home/jenkins/agbcc

# Install and configure Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
ENV PATH=/home/jenkins/.cargo/bin:$PATH
