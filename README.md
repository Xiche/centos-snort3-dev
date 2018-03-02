Snort++ build quick start (inside the container) with unit test support:
```
cd $HOME
git clone https://github.com/cpputest/cpputest.git
cd cpputest
mkdir obj
cd obj
cmake -DC++11=ON -DCMAKE_INSTALL_PREFIX=$HOME/install/cpputest ..
make -j$(nproc) install

cd $HOME
curl -LO https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz
tar xf boost_1_66_0.tar.gz
curl -LO https://github.com/intel/hyperscan/archive/v4.7.0.tar.gz#/hyperscan-4.7.0.tar.gz
tar xf hyperscan-4.7.0.tar.gz
cd hyperscan-4.7.0
sed -i -e 's|libdir=@CMAKE_INSTALL_PREFIX@/lib|libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@|' libhs.pc.in
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/install/hs -DBOOST_ROOT=$HOME/boost_1_66_0 ..
make -j$(nproc) install

cd $HOME
curl -LO https://snort.org/downloads/snortplus/daq-2.2.2.tar.gz
tar xf daq-2.2.2.tar.gz
cd daq-2.2.2
./configure
make install
ldconfig

cd $HOME
git clone https://github.com/snortadmin/snort3.git
cd snort3
export PKG_CONFIG_PATH=$HOME/install/cpputest/lib/pkgconfig:$HOME/install/hs/lib64/pkgconfig
./configure_cmake.sh --prefix=$HOME/install/snort3 --enable-unit-tests
cd build
make -j$(nproc) install
make check

$HOME/install/snort3/bin/snort -V
$HOME/install/snort3/bin/snort --catch-test all
```
