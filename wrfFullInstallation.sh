module swap intel/13.1.3.192 gnu/5.3.0

 
cd test

tar -xf Fortran_C_tests.tar
gfortran TEST_1_fortran_only_fixed.f
./a.out
gfortran TEST_2_fortran_only_free.f90
./a.out
gcc TEST_3_c_only.c
./a.out
gcc -c -m64 TEST_4_fortran+c_c.c
gfortran -c -m64 TEST_4_fortran+c_f.f90
gfortran -m64  TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out
./TEST_csh.csh
./TEST_perl.pl
./TEST_sh.sh

cd ../build

echo 'export DIR=/nobackup/wrfTest/build/LIBRARIES' >> ~/.bashrc
echo 'export CC=gcc' >> ~/.bashrc
echo 'export CXX=g++' >> ~/.bashrc
echo 'export FC=gfortran' >> ~/.bashrc
echo 'export F77=gfortran' >> ~/.bashrc
echo 'export FCFLAGS=-m64' >> ~/.bashrc
echo 'export FFLAGS=-m64' >> ~/.bashrc

echo 'export DIR=/nobackup/wrfTest/build/LIBRARIES' >> ~/.bash_profile
echo 'export CC=gcc' >> ~/.bash_profile
echo 'export CXX=g++' >> ~/.bash_profile
echo 'export FC=gfortran' >> ~/.bash_profile
echo 'export F77=gfortran' >> ~/.bash_profile
echo 'export FCFLAGS=-m64' >> ~/.bash_profile
echo 'export FFLAGS=-m64' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd LIBRARIES

tar xzf netcdf-4.1.3.tar.gz
cd netcdf-4.1.3

./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared


make
make install
make check
echo 'export PATH=$DIR/netcdf/bin:$PATH' >> ~/.bashrc
echo 'export NETCDF=$DIR/netcdf' >> ~/.bashrc

echo 'export PATH=$DIR/netcdf/bin:$PATH' >> ~/.bash_profile
echo 'export NETCDF=$DIR/netcdf' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd ..

tar xzf mpich-3.0.4.tar.gz

cd mpich-3.0.4

./configure --prefix=$DIR/mpich

make
make install

echo 'export PATH=$DIR/mpich/bin:$PATH' >> ~/.bashrc
echo 'export PATH=$DIR/mpich/bin:$PATH' >> ~/.bash_profile
cd ..

echo 'export LDFLAGS=-L$DIR/grib2/lib' >> ~/.bashrc
echo 'export CPPFLAGS=-I$DIR/mpich/bin:$PATH' >> ~/.bashrc

echo 'export LDFLAGS=-L$DIR/grib2/lib' >> ~/.bash_profile
echo 'export CPPFLAGS=-I$DIR/mpich/bin:$PATH' >> ~/.bash_profile


source ~/.bashrc
source ~/.bash_profile

tar xzvf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --prefix=$DIR/grib2


make
make install

cd ..


tar xzvf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=$DIR/grib2


make
make install

cd ..

tar xzvf jasper-1.900.1.tar.gz
cd jasper-1.900.1

./configure --prefix=$DIR/grib2

make
make install

echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bashrc
echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bashrc
echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bash_profile
echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd ../../../test

tar -xf Fortran_C_NETCDF_MPI_tests.tar

cp ${NETCDF}/include/netcdf.inc .

gfortran -c 01_fortran+c+netcdf_f.f
gcc -c 01_fortran+c+netcdf_c.c
gfortran  01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf


./a.out

cp ${NETCDF}/include/netcdf.inc .


mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf

mpirun ./a.out

cd ../build


tar -xf WRFV3.7.TAR

cd WRFV3

./configure
./compile em_real >& log.compile
ls -ls main/*.exe

cd ..

source wpsUnpack.sh

cd ..
source wpsConfig.sh


cd ..

source wpsInstall.sh
