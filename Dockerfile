FROM centos:centos7
MAINTAINER Michael Altizer <mialtize@cisco.com>

# Add /usr/local/lib and /usr/local/lib64 to the ldconfig caching paths
ADD ldconfig-local.conf /etc/ld.so.conf.d/local.conf

# Enable EPEL for access to updated packages
RUN yum -y install epel-release
# Update the image's pre-installed packages
RUN yum -y upgrade
# Install the Snort build dependencies
RUN yum -y install bison cmake3 file flex gcc-c++ hwloc-devel libdnet-devel libpcap-devel libuuid-devel luajit-devel make openssl-devel pcre-devel ragel xz-devel
# Install the Snort developer requirements
RUN yum -y install git lcov vim
# Clean out the Yum cache
RUN yum -y clean all

# Add CMake3 to alternatives for cmake
RUN alternatives --install /usr/bin/cmake cmake /usr/bin/cmake3 10
