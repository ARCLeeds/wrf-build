

if [[ $# -eq 0 ]] ; then
    echo 'The full path to the directory that you would like to install WRF into is required for this installer to function correctly this folder must exist on the system ie: if you want the installer to install into a folder called programs in you user folder on nobackup supply the path /nobackup/youruserfolder/programs'
    exit 1
fi

path=$1

cd ..

cp -rf wrf-build $path/wrf

cd $path/wrf/test

tar -xf Fortran_C_tests.tar
ifort TEST_1_fortran_only_fixed.f
./a.out >& ../test.log


ifort TEST_2_fortran_only_free.f90
./a.out >> ../test.log


icpc TEST_3_c_only.c
./a.out >> ../test.log


icc -c -m64 TEST_4_fortran+c_c.c
ifort -c -m64 TEST_4_fortran+c_f.f90
ifort -m64  TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
./a.out >> ../test.log


./TEST_csh.csh >> ../test.log
./TEST_perl.pl >> ../test.log
./TEST_sh.sh >> ../test.log

cd ../build

echo 'export DIR=$path/wrf/build/LIBRARIES' >> ~/.bashrc
echo 'export CC=icc' >> ~/.bashrc
echo 'export CXX=icpc' >> ~/.bashrc
echo 'export FC=ifort' >> ~/.bashrc
echo 'export F77=ifort' >> ~/.bashrc
echo 'export FCFLAGS=-m64' >> ~/.bashrc
echo 'export FFLAGS=-m64' >> ~/.bashrc

echo 'export DIR=$path/wrf/build/LIBRARIES' >> ~/.bash_profile
echo 'export CC=icc' >> ~/.bash_profile
echo 'export CXX=icpc' >> ~/.bash_profile
echo 'export FC=ifort' >> ~/.bash_profile
echo 'export F77=ifort' >> ~/.bash_profile
echo 'export FCFLAGS=-m64' >> ~/.bash_profile
echo 'export FFLAGS=-m64' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd LIBRARIES

tar xzf netcdf-4.1.3.tar.gz
cd netcdf-4.1.3

./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared >& ../../../make.log


make >> ../../../make.log
make install >> ../../../make.log
make check >> ../../../make.log


echo 'export PATH=$DIR/netcdf/bin:$PATH' >> ~/.bashrc
echo 'export NETCDF=$DIR/netcdf' >> ~/.bashrc
echo 'export PATH=$DIR/netcdf/bin:$PATH' >> ~/.bash_profile
echo 'export NETCDF=$DIR/netcdf' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd ..

tar xzf mpich-3.0.4.tar.gz

cd mpich-3.0.4

./configure --prefix=$DIR/mpich >> ../../../make.log

make >> ../../../make.log
make install >> ../../../make.log

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
./configure --prefix=$DIR/grib2 >> ../../../make.log


make >> ../../../make.log
make install >> ../../../make.log

cd ..


tar xzvf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=$DIR/grib2 >> ../../../make.log


make >> ../../../make.log
make install >> ../../../make.log

cd ..

tar xzvf jasper-1.900.1.tar.gz
cd jasper-1.900.1

./configure --prefix=$DIR/grib2 >> ../../../make.log

make >> ../../../make.log
make install >> ../../../make.log

echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bashrc
echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bashrc
echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bash_profile
echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bash_profile

source ~/.bashrc
source ~/.bash_profile

cd ../../../test

tar -xf Fortran_C_NETCDF_MPI_tests.tar

cp ${NETCDF}/include/netcdf.inc .

ifort -c 01_fortran+c+netcdf_f.f
icc -c 01_fortran+c+netcdf_c.c
ifort  01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf


./a.out >> ../test.log

cp ${NETCDF}/include/netcdf.inc .


mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf

mpirun ./a.out >> ../test.log

cd ../build


tar -xf WRFV3.7.TAR

cd WRFV3

./configure
./compile em_real >& ../../log.wrf

ls -ls main/*.exe >> ../../log.wrf

cd ..

tar -xf WPSV3.7.TAR

cd WPS

export DIR=$path/wrf/build/LIBRARIES
export CC=icc
export CXX=icpc
export FC=ifort
export FCFLAGS=-m64
export F77=ifort
export FFLAGS=-m64
export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./configure

export DIR=$path/wrf/build/LIBRARIES
export CC=icc
export CXX=icpc
export FC=ifort
export FCFLAGS=-m64
export F77=ifort
export FFLAGS=-m64
export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./compile wps >& ../../log.wps

ls -ls *.exe >> ../../log.wps

cd ../data

cp namelist.input ../WRFV3/test/em_real/namelist.input
cp namelist.output ../WRFV3/test/em_real/namelist.output
cp run_wrf.sh ../WRFV3/test/em_real/run_wrf.sh
cp namelist.wps ../WPS/namelist.wps

cd ../WPS

./geogrid.exe >& ../../log.geogrid

./link_grib.csh ../data/GRB/

ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable

./ungrib.exe >& ../../log.ungrib


./metgrid.exe >& ../../log.metgrid

cd ../WRFV3/test/em_real

ln -sf ../../../WPS/met_em* .
