export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include
tar -xf WRFV3.7.TAR
cd WRFV3
./configure
./compile em_real >& log.compile
ls -ls main/*.exe
