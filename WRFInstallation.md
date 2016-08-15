## WRF Installation



### Before Installing

To install WRF in the nobackup area of the ARC2 system it is important that all of the necessary files are unpacked and that the folder structure remains as it is when unpacked. Although this script is automated these notes will explain what it is the installer is doing in case there are any problems with your installation.

It is also important that you have the data that you would like to use for your simulation. The installer is packaged with example data sufficient to run the practice forecast and hurricane Katrina simulation. To run the hurricane Katrina simulation you will need to copy the relevant data from wrf/build/data/katrina to the WPS and WRFV3 folder after compilation is complete.You will also need to run metgrid, ungrib and geogrid again before executing the real and wrf executables.

If further experimentation is required there are instructions to retrieve up to date real time data and further static data.If you plan to use this data with this installation script a number of changes will need to be made to allow this.

###  Running the automated installation

Using this automated installer requires that you run intelFull.sh from the top level of the wrf-build directory.

to do this change directory to the wrf-build directory and run the command `source intelFull.sh /nobackup/youruserdirectory` where youruserdirectory is the name of the directory on nobackup that you wish to install to.

This will begin installation of  WRF, WPS and the various dependencies required to run a real data simulation. The installation will be created in a folder labelled wrf in the directory you specified.It is important that you run this installer from the nobackup area of the arc system as there is not sufficient space in your user directory for the installation to complete succesfully. If you do not provide a command line argument an error message will appear and the installer will log you out of the arc system to prevent the rest of the script from running.

Once the script begins running it will appear to pause/hang for times of upto 15-20 mins. This is a normal operation and should be left ot complete.

## Initial Testing

There are a number of tests bundled with this installer. These tests are performed at various stages in the installation. Any results of these tests will be found in the test.log and make.log files that are produced upon completion of the install.These files are located in the  wrf directory. ==It is important that these files are checked as failure at any stage of this process may lead to an incomplete model that does not execute and these files will point you in the correct direction to fix the error.== Furthermore, the model may execute returning erroneous data that is not at first obvious to the user.


The first set of tests contain the following code:

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
    

####C, C++, Fortran

The first set of tests checks for the systems ability to compile C, C++ and Fortran codes with the compiler that has been chosen for the installation. The tests include:

1. Fixed Format Fortran Compilation and Execution Test
2. Free Format Fortran Compilation and Execution Test
3. C Compilation and Execution Test
4. Fortran calling a C function


####Scripting

The second set of tests checks for the existence of 3 scripting languages.
  
5. CSH Test
6. Perl Test
7. Sh Test

##Included Libraries

To run a WRF simulation there are number of libraries that need to be installed:

1. NetCDF:
This library is essential for WRF and is installed by a script located at build/netCDFInstall.sh 
2. MPICH:
This library is essential if you wish to build WRF in parallel.
3. zlib:
A compression library necessary for compiling WPS and used with GRIB2
4. libpng:
A compression library necessary for compiling WPS and used with GRIB2
5. JasPer:
A compression library neccessary for compiling WPS and used with GRIB2

The code to install these dependencies is presented below:

    #These lines add these environment variables to your .bashrc and 
    #.bash_profile files.If you would like to use a different 
    #compiler ammend these environment varaiables.

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
    
    # Reload the .bashrc and .bash_profile to reflect recent changes
    
    source ~/.bashrc
    source ~/.bash_profile
    
    cd LIBRARIES
    
    tar xzf netcdf-4.1.3.tar.gz
    cd netcdf-4.1.3
    
    ./configure --prefix=$DIR/netcdf --disable-dap --disable-netcdf-4 --disable-shared
    
    
    make >& ../../../make.log
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
    
    ./configure --prefix=$DIR/mpich
    
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
    ./configure --prefix=$DIR/grib2
    
    
    make >> ../../../make.log
    make install >> ../../../make.log
    
    cd ..
    
    
    tar xzvf libpng-1.2.50.tar.gz
    cd libpng-1.2.50
    ./configure --prefix=$DIR/grib2
    
    
    make >> ../../../make.log
    make install >> ../../../make.log
    
    cd ..
    
    tar xzvf jasper-1.900.1.tar.gz
    cd jasper-1.900.1
    
    ./configure --prefix=$DIR/grib2
    
    make >> ../../../make.log
    make install >> ../../../make.log
    
    echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bashrc
    echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bashrc
    echo 'export JASPERLIB=$DIR/grib2/lib' >> ~/.bash_profile
    echo 'export JASPERINC=$DIR/grib2/include' >> ~/.bash_profile
    
    source ~/.bashrc
    source ~/.bash_profile

These libraries are included with the installation files and are all installed for you by this installer.

###Library Testing


These tests are used to check the installation of the libraries that are required by WRFV3 and WPS:

1. Fortran + C + NetCDF
2. Fortran + c + NetCDF + MPI

These tests ensure that NetCDF and MPI are functioning correctly with both C and Fortran as required by the remainder of the install. 


##Building WRFV3

The actual WRFV3 build requires that a compiler is selected from the list of available compilers. It is essential that this compiler is the same compiler that was used to compile and build the Libraries.

The options that are set here include:

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

####Compiler

On the arc systems, we have a number of compilers that will compile WRF, WPS and its libraries. 

#####Intel 

versions:

1. 13.1.3.192
2. 15.0.0 
3. 16.0.2

#####GNU 

versions:

1. native 
2. 4.8.1 
3. 4.9.1 
4. 5.3.0

#####Portland Group

versions:

1. 13.6

Each of these compilers is available in the version numbers displayed above. This may be selected at the start of installation and must be consistent throughout the installation. Although users are offered a choice ==it is highly recommended that you choose the intel compiler with {dmpar},== for compilation on arc2. ==This script, in particular, is only suitable for the intel compilers.== If you would like to try another compiler one should either do a manual install or ammend this script to use a different compiler by changing the environment variables exported by the script and loading the corresponding modules using the `module swap` command.

####Compilation Type

It is possible to compile WRF and WPS in a number of different ways specific to the way in which you intend to use it. These compilation methods are able to increase the efficiency of the code if it is to be run on a multicore system.

1. #####Serial compilation. 
{serial} Optimised for use on a single core machine. This is sufficient if the user only needs to run the  code on a single core.

2. #####Shared Memory compilation. 
{SMP} Optimised for use in a shared memory environment. This is the model used by OpenMP.

3. #####Distributed memory compilation. 
{DMP} This is the memory model that is used by programs written in MPICH.

4. #####Shared and distributed memory compilation. 
{SDMP} This option supports use in shared and distributed memory settings.(MPICH between nodes and OpenMP where memory can be shared)

Once again, it is important that the compiler used to compile WRF and WPS is the same compiler that was used to compile the library components of this installation.


####Simulation Type

WRF offers a number of simulation types to choose from:

em_real (3d real case)

em_quarter\_ss (3d ideal case)

em_b\_wave (3d ideal case)

em_les (3d ideal case)

em_heldsuarez (3d ideal case)

em_tropical\_cyclone (3d ideal case)

em_hill2d\_x (2d ideal case)

em_squall2d\_x (2d ideal case)

em_squall2d\_y (2d ideal case)

em_grav2d\_x (2d ideal case)

em_seabreeze2d\_x (2d ideal case)

em_scm\_xy (1d ideal case)

em_real (3d real case)

em_quarter\_ss (3d ideal case)

em_b\_wave (3d ideal case)

em_les (3d ideal case)

em_heldsuarez (3d ideal case)

em_tropical\_cyclone (3d ideal case)

em_hill2d\_x (2d ideal case)

em_squall2d\_x (2d ideal case)

em_squall2d\_y (2d ideal case)

em_grav2d\_x (2d ideal case)

em_seabreeze2d\_x (2d ideal case)

em_scm\_xy (1d ideal case)


These cases all require the static data files that are include in the installation directory. The em_real case is the only model that require WPS and the real-time dataset.


Most researchers that are using HPC are interested in the em_real case therefore the automated script provided is hard coded to build an em\_real case.

The WRF install is done by the following code:

    ./configure
    
    # if you would like to compile a case other than em_real edit the line below. ie ./compile em_seabreeze2d_x >& log.wrf and delete the section relating to WPS installation
    
    ./compile em_real >& log.wrf
    
    ls -ls main/*.exe >> log.wrf
    
    cd ..

Again log files are created in the top level of the wrf directory created by the installer.


### WRF Test

if an em_real case was compiled there should be four executables (files with extension .exe) created.

1. wrf.exe
2. real.exe
3. ndown.exe
4. tc.exe

If an idealised case is created there should be only two executables created.

1. wrf.exe
2. ideal.exe

A command is used to check for the existence of these files and the results of this command are stored in the wrf.log file.There should also be two symbolic links created for these executables allowing the user to run from either

WRFV3/run

or

WRFV3/test/em_real

If you compile WRF and you get all of the executables that are expected but WRF does not run the simulation it is helpful to check that the .exe files are of a non-zero size and that the actual .exe files have been created not just the symbolic links.


##Building WPS

WPS is required to run the em_real case of the WRF model. In order for this to be successful the WRF model must be properly built before attempting to build WPS.The following code configures and compiles WPS.
    
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
    
#####Compilation Options

As with WRF, there are a number of compilation options for WPS. The compiler  type, version number and a choice of compilation paradigms are provided as before.==Again it is essential that the compiler type and version is the same as the compiler that was used to build WRF and the supporting libraries.== 

A further option is given at this stage which is NO_Grib2 or  Grib2. It is advised that all users choose the grib2 option unless it is already known that the data being used is not to be used as Grib2 format.==For compiilation using this script on the arc systems it is reccomended you choose the intel compiler {DMPAR} with Grib2 support, this is option number 19.==

Once these options are selected it is time to compile WPS. Upon completion, there should be 3 executable files in the WPS directory.

geogrid.exe

ungrib.exe

metgrid.exe

Again a test is performed to confirm the existence of these files and the results are appended to the test.log file. ==When checking these results it is important to check that the files generated are of non-zero size.==

##Static Data


The WRF weather modelling system requires a number of data files.

For the purpose of the practice forecast that is to be performed for all of the static is included with this installer. However the real time data is obviously not current.

The full static data set is available at the WRF website, and can also be used directly from the nobackup area of arc2 by specifying the path /nobackup/wrf_static_data in your namelist files.


##Real-time Data

If one would like a more up to date real time data set to run the WRF model against then they can be retrieved from the sources given below. 

For em_real cases to run real-time data is required. This data provides initial conditions and lateral boundary conditions and usually is provided in the form of a grib2 file and provided by a previously run external model or analysis. For a semi-operational set up the meteorological data is usually sourced from a global model, which requires locating the WRF model's domains anywhere on the globe.


The national centre for environmental prediction  (NCEP) run the Global Forecast System (GFS) model four times daily (hence data is available for 00:00,06:00,12:00,18:00)This is a global, isobaric, 0.5 degree latitude/longitude, forecast data set that is freely available and is usually accessible  + 4h after the initialization time period.

A single data file needs to be acquired for each requested time period. For example, if we would like hours 0, 6, and 12 of a forecast that is initialized 2014 Jan 31 at 0000 UTC, we need the following times:

    2014013100 – 0 h
    2014013106 – 6 h
    2014013112 – 12 h

These translate to the following file names to access:

    gfs.2014013100/gfs.t00z.pgrb2.0p50.f000

    gfs.2014013100/gfs.t00z.pgrb2.0p50.f006

    gfs.2014013100/gfs.t00z.pgrb2.0p50.f012

Note that the initialization data and time (gfs.2014013100) remains the same and that the forecast cycle remains the same (t00z). What is incremented is the forecast hour (f00, f06, f12).


A simple set of interactive commands to grab these files from the NCEP servers in real-time would look like (**Note that this is just an example time/date. Typically on the NCEP data servers, only the most recent 2-3 days are available at any given time. 

To use up-to-date real-time data, you will need to adjust the commands to reflect current date and time information:


    curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER_ID@INSTITUTION -o GFS_00h     ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f000

    curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER_ID@INSTITUTION -o GFS_06h     ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f006

    curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER_ID@INSTITUTION -o GFS_12h     ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f012

Typically these commands return a complete file within a few seconds. The files returned from these commands (GFS\_00h, GFS\_06h, GFS_12h) are Grib Edition 2 files, able to be directly used by the ungrib program.

You need to fill in the anonymous login information (which is not private, so there are no security concerns about leaving these scripts around). You will probably end up writing a short script to automatically increment the initialization time.

To use this real time data instead of the data bundled in the installer you need to put them in the directory GRB and update the input scripts to reflect your new data set.


##Run WRF and WPS

The final part of the script takes care of some configuration in preparation for finally running WRF.If you would like to use data other than that provided for the practice forecast you will need to run this section again manually or create a script that runs just this section with the paths ammended to suit the location of you alternative data files.


    cd ../data

    cp namelist.input ../WRFV3/test/em_real/namelist.input
    cp namelist.output ../WRFV3/test/em_real/namelist.output
    cp namelist.wps ../WPS/namelist.wps
    
    cd ../wps
    
    ./geogrid.exe >& ../../log.geogrid
    
    ./link_grib.csh ../GFS/
    
    ln -sf ungrib/Variable_Tables/Vtable.GFS Vtable
    
    ./ungrib.exe >& ../../log.ungrib
    
    
    ./metgrid.exe >& ../../log.metgrid
    
    cd ../WRFV3/test/em_real
    
    ln -sf ../../../WPS/met_em* .
    
    

You are now ready to run:

    mpirun -np 1 ./real.exe
    
Check the end of your "rsl" files to make sure the run was successful:

    tail rsl.error.0000
    
If you see a "SUCCESS" in there, and you see a wrfbdy\_d01 file, and wrfinput_d0* files for each of your domains, then the run was successful.

To run WRFV3:

    nano run_wrf.sh
    

Now edit the line you@leeds.ac.uk so that it contains your email address.Once edited press ctrl + x to save and exit. Then do,

    qsub run_wrf.sh


This job submission script runs WRF on a single node using all of the available resources on that node. WRF only actually uses half of the ram provided by this configuration however this ram can not be used by other nodes since you have exclusive access to it so you may as well reserve it all.

    #!/bin/bash
    
    # Run the code from the current working directory and with the current module environment
    #$ -V -cwd
    
    # Specify a runtime- 12 hours in this case
    #$ -l h_rt=12:00:00
    
    # Request a full node (16 cores and 32GB on ARC2)
    #$ -l nodes=1 
    
    
    #$ -m be
    #$ -M you@leeds.ac.uk
    
    # Concatenate output and error files
    #$ -j y
    #$ -o wrftest.out
    
    # Set The MPICH Abort Environment Variable
    
    export MPICH_ABORT_ON_ERROR=1
    ulimit -c unlimited

    # Run WRF

    mpirun wrf.exe
    
This run should complete within one hour for the practice forecast if it does not there may be a problem with the installation. This does not mean that the run will not complete as it is possible that this simulation can take up to 10 hours if something has gone wrong during the installation process.

####Notes on using different compilers.

When installing this program for benchmarking on the arc systems we had a problem getting the DMPAR option to work with the GNU compilers. This appears to be due to FSEEKO AND FSEEKO 64 NOT BEING SUPPORTED. This is the only consistent error found during installation and may be a good starting point for anyone who is limited to using this on a home machine.  

##Further Reading
If you have any problems during installation or would like to run simulations other than those provided in this installer the following links will be helpful. 

#####Find the bugs

This web page deals with many of the common bugs found in WRF and WPS installations and was an excellent resource when creating this script.

http://www2.mmm.ucar.edu/wrf/OnLineTutorial/Class/cases/find_the_bugs.php

#####Official WRF build instructions
Most of the instructions in the script come from this page but hte have been altered to suit the intel compiler and to deal with the problems we had during installation on arc

http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php

#####Site for full static data set

http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html

http://www2.mmm.ucar.edu/wrf/users/download/free_data.html