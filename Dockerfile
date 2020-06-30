FROM centos:8 AS base
LABEL maintainer="Michael Altizer <mialtize@cisco.com>"

# Add /usr/local/lib64 to the ldconfig caching paths
ADD ldconfig-local.conf /etc/ld.so.conf.d/local.conf

RUN \
# Install dnf-plugins-core for 'dnf config-manager'
dnf install -y dnf-plugins-core && \
# Enable PowerTools repo for development tools, libraries, and headers
dnf config-manager --set-enabled PowerTools && \
# Enable EPEL for access to updated packages (mainly luajit-devel)
dnf install -y epel-release && \
# Update the image's pre-installed packages
dnf upgrade --refresh -y && \
# Install the Snort build dependencies
dnf install -y \
    autoconf \
    automake \
    cmake \
    file \
    gcc-c++ \
    hwloc-devel \
    libdnet-devel \
    libmnl-devel \
    libpcap-devel \
    libtool \
    libunwind-devel \
    libuuid-devel \
    luajit-devel \
    make \
    openssl-devel \
    pcre-devel \
    xz-devel \
    zlib-devel \
# Install the Snort developer conveniences
    gdb \
    git \
    glibc-langpack-en \
    glibc-locale-source \
    libasan \
    libtsan \
    vim \
&& \
# Clean out the DNF cache
dnf clean all

# Work around the locale getting FUBAR
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

FROM base AS cpputest
WORKDIR /root
RUN curl -LO https://github.com/cpputest/cpputest/releases/download/v4.0/cpputest-4.0.tar.gz
RUN tar xf cpputest-4.0.tar.gz
RUN mkdir cpputest-build
WORKDIR cpputest-build
RUN cmake ../cpputest-4.0 -DC++11=ON
RUN make -j$(nproc) install

FROM base
COPY --from=cpputest /usr/local /usr/local

WORKDIR /root
