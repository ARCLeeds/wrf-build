export DIR=/nobackup/issev003/copy/build/LIBRARIES
export CC=icc
export CXX=icpc
export FC=ifort
export F77=ifort
export FCFLAGS=-m64
export FFLAGS=-m64

cd LIBRARIES

tar xzf netcdf-4.1.3.tar.gz
cd netcdf-4.1.3
./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make
make install
make check >& netCDFMakeCheck.txt
export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
