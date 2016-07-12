
tar -xf WPSV3.7.TAR

cd WPS

./clean

export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

./configure

./compile >& log.compile

ls -ls *.exe
