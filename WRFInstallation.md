## WRF Installation

To install WRF in the nobackup area of the ARC2 system it is important that all of the necessary files are unpacked and that the folder structure remains as it is when unpacked. Although this script is automated these notes will explain what it is the installer is doing in case there are any problems with your installation.

This will help you to de-bug the installation and is reccomended reading for anyone who wishes to compile and run instances of WRF on the ARC2 system.


###  Running the automated  installation

Using this automated install  requires that you run buildAll.sh from the top level of the WRF_INSTALL directory.

This will begin installation of  WRF, WPS and the various dependencies required to run a real data simulation.

## TESTS

There are a number of tests bundled with this installer. These tests are performed at various stages in the installation. Any results of these tests will be found in the test.log and make.log files that are produced upon completion of the install. ==It is important that these files are checked as failiure at any stage of this process may lead to an incomplete model that does not execute.== Furthermore the model may execute returning erroneous data that is not at first obvious to the user.

###Inital Testing

This is done by a file located at test/initialTest.sh the file containns the following code:

	tar -xf Fortran_C_tests.tar
	
	ifort TEST_1_fortran_only_fixed.f 
	./a.out
	ifort TEST_2_fortran_only_free.f90 
	./a.out
	icc TEST_3_c_only.c 
	./a.out 
	icc -c -m64 TEST_4_fortran+c_c.c 
	ifort -c -m64 TEST_4_fortran+c_f.f90 
	ifort -m64  TEST_4_fortran+c_f.o TEST_4_fortran	+c_c.o
	./a.out
	
	
	./TEST_csh.csh
	./TEST_perl.pl
	./TEST_sh.sh
	

####C, C++, Fortran

The first set of tests check for the systems ability to compile C, C++ and Fortran codes with the compiler that has been chosen for the installation. The tests include:

1. Fixed Format Fortran Compilation and Execution Test
2. Free Format Fortran Compilation and Execution Test
3. C Compilation and Execution Test
4. Fortran calling a C function


####Scripting

The second set of tests check for the existence of 3 scripting languages.
  
5. CSH Test
6. Perl Test
7. Sh Test

##Included Libraries

To run a WRF simulation there are number of libraries that need to be installed:

1. NetCDF:
This library is essential for WRF.
2. MPICH:
This library is essential if you wish to build WRF in parallel.
3. zlib:
A compression library neccessary for compiling WPS and used with GRIB2
4. libpng:
A compression library neccessary for compiling WPS and used with GRIB2
5. JasPer:
A compression library neccessary for compiling WPS and used with GRIB2

These libraries are included with the installation files and are all installed for you by this installer.

 
###Library Testing


These tests are used to check the installation of the libraries that are required by WRFV3 and WPS.

1. Fortran + C + NetCDF
2. Fortran + c + NetCDF + MPI


##Building WRFV3

The actual WRFV3 build requires that a compiler is selected from the list of available compilers. It is essential that this compiler is the same compiler that was used to compile and build the Libraries.

The options that are set here include:

####Compiler

On the arc systems we have a number of compilers that will compile WRF, WPS and its libraries. These include:

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

Each of these compilers are available in the verion numbers displayed above. This may be selected at the start of installation and and must be consistent throughout installation.

####Compilation Type

It is possible to compile WRF and WPS in a number of different ways speific to the way in which you intend to use it. These compilation methods are able to increase the efficiency of the code if it is to be run on a multicore system.

1. #####Serial compilation. 
{serial} Optimized for use on a single core machine. This is sufficient if the user only needs to run the  code on a single core.

2. #####Shared Memory compilation. 
{SMP} Optimized for use in a shared memory environment. This is the model used by OpenMP.

3. #####Distributed memory compilation. 
{DMP} This is the memory model that is used by programs written in MPICH.

4. #####Shared and distibuted memory compilation. 
{SDMP} This option supports use in shared and distributed memory settings. 

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


These cases all require the static data files that are include in the installation directory. The em_real case is the only model that require WPS and the real time dataset.


Most researchers that are using HPC are interested in the em_real case. The option for which case you want to install must be given in the compilation options.

### WRF Test

if an em_real case was compiled there should be four executables (files with extension .exe) created.

1. wrf.exe
2. real.exe
3. ndown.exe
4. tc.exe

If an idealized case is created ther should be only two executables created.

1. wrf.exe
2. ideal.exe

A command is used to check for the existence of these files and the results of this command are stored in the test.log file.There should also be two symbolic links created for these executables allowing the user to run from either

WRFV3/run

or

WRFV3/test/em_real


##Building WPS

WPS is required to run the em_real case of the WRF model. In order for this to be successfull the WRF model must be properly built before attempting to build WPS.

#####Compilation Options

As with WRF there are a number of compilation for WPS. The compiler  type, version number and a choice of compilation paradigms are provided as before.==Again it is essential that the compiler type and version is the same as the compiler that was used to build WRF and the supporting libraries.== However the compilation paradigm (ser/spar/dpar/dmpar) should be set to serial regardless of the option that was chosen to build WRF, unless you plan to run simulations with exceptionally large domains.

A further option is given at this stage which is NO_Grib2 or  Grib2. It is advised that all users choose the grib2 option unless it is already known that the data being used is not to be used as Grib2 format.

Once these options are selected it is time to compile WPS. Upon completion there should be 3 executable files in the WPS directory.

geogrid.exe

ungrib.exe

metgrid.exe

Again a test is performed to confirm the existence of these files and the results are appended to the test.log file. When checking these results it is important to check that the files generated are of non zero size.

##Static Data


The WRF weather modelling system requires a number of data files. These data are all available via the WRF website however we have downloaded and bundled all of the data in with this installer so everything that is available is included in this package. (July 2016) If there are further data made available you should be able to obtain it from this link.

The data packaged with this installer expands to over 10GB of data therefore make sure there is enough room on your device before beginning an installation.==If you are installing on the ARC system please first move to /nobackup/username before atttempting to build and install the program as there will not be sufficient storage available in your HOME directory.==


##Real-time Data

For em_real cases to run  real-time data is required. This data provides initial conditions and lateral boundary conditions and usually is provided in the form of a grib2 file. provided by a previously run external model or or anlysis.For a semi operational set up the meterological data is usually sourced from a global model , which requires locating the WRF model's domains anywghere on th e globe


The national centre for environmental prediction  (NCEP) run the Global Forecast System (GFS) model four times daily (hence data is available for 00:00,06:00,12:00,18:00)This is a global, isobaric, 0.5 degree latitude/longitude, forecast data set that is freely available and is usually accessible  + 4h after the initiallization time period.

A single data file needs to be acquired for each requested time period. For example, if we would like hours 0, 6, and 12 of a forecast that is initialized 2014 Jan 31 at 0000 UTC, we need the following times:

2014013100 – 0 h
2014013106 – 6 h
2014013112 – 12 h

These translate to the following file names to access:

gfs.2014013100/gfs.t00z.pgrb2.0p50.f000

gfs.2014013100/gfs.t00z.pgrb2.0p50.f006

gfs.2014013100/gfs.t00z.pgrb2.0p50.f012

Note that the initialization data and time (gfs.2014013100) remains the same, and that the forecast cycle remains the same (t00z). What is incremented is the forecast hour (f00, f06, f12).


A simple set of interactive commands to grab these files from the NCEP servers in real-time would look like (**Note that this is just an example time/date. Typically on the NCEP data servers, only the most recent 2-3 days are available at any given time. 

To use up-to-date real-time data, you will need to adjust the commands to reflect current date and time information:


curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER\_ID@INSTITUTION -o GFS_00h ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f000

curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER\_ID@INSTITUTION -o GFS_06h ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f006

curl -s --disable-epsv --connect-timeout 30 -m 60 -u anonymous:USER\_ID@INSTITUTION -o GFS_12h ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.2014013100/gfs.t00z.pgrb2.0p50.f012

Typically these commands return a complete file within a few seconds. The files returned from these commands (GFS\_00h, GFS\_06h, GFS_12h) are Grib Edition 2 files, able to be directly used by the ungrib program.

You need to fill in the anonymous login information (which is not private, so there are no security concerns about leaving these scripts around). You will probably end up writing a short script to automatically increment the initialization time.  


##Run WRF an WPS



 













