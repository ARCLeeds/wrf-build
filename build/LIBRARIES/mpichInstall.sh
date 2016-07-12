tar xzf mpich-3.0.4.tar.gz

cd mpich-3.0.4

./configure --prefix=$DIR/mpich

touch libraryBuild.txt

echo "##############    make details for MPICH    ##############" >> libraryBuild.txt
 
make >> libraryBuild.txt
make install >> libraryBuild.txt
make check >> libraryBuild.txt

export PATH $DIR/mpich/bin:$PATH
cd ..

export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/mpich/bin:$PATH

tar xzvf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --prefix=$DIR/grib2

echo "##############    make details for zlib    ##############" >> libraryBuild.txt

make >> libraryBuild.txt
make install >> libraryBuild.txt
make check >> libraryBUild.txt

cd ..


tar xzvf libpng-1.2.50.tar.gz     #or just .tar if no .gz present
cd libpng-1.2.50
./configure --prefix=$DIR/grib2

echo "##############    make details for libpng    ##############" >> libraryBuild.txt

make >> libraryBuild.txt
make install >> libraryBuild.txt

cd ..

tar xzvf jasper-1.900.1.tar.gz     #or just .tar if no .gz present
cd jasper-1.900.1

./configure --prefix=$DIR/grib2


echo "##############    make details for jasper    ##############" >> libraryBuild.txt
make >> libraryBuild.txt 
make install >> libraryBuild.txt

cd ..


