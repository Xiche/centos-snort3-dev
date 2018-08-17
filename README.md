Snort++ build quick start (inside the container) with unit test support:
```
cd $HOME
git clone https://github.com/cpputest/cpputest.git
cd cpputest
mkdir obj
cd obj
cmake -DC++11=ON ..
make -j$(nproc) install

cd $HOME
curl -LO https://snort.org/downloads/snortplus/daq-2.2.2.tar.gz
tar xf daq-2.2.2.tar.gz
cd daq-2.2.2
./configure
make install
ldconfig

cd $HOME
git clone https://github.com/snort3/snort3.git
cd snort3
./configure_cmake.sh --prefix=$HOME/install/snort3 --enable-unit-tests
cd build
make -j$(nproc) install
make -j$(nproc) check

$HOME/install/snort3/bin/snort -V
$HOME/install/snort3/bin/snort --catch-test all
```
