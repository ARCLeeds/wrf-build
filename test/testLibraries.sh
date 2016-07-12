tar -xf Fortran_C_NETCDF_MPI_tests.tar

cp ${NETCDF}/include/netcdf.inc .

ifort -c 01_fortran+c+netcdf_f.f
icc -c 01_fortran+c+netcdf_c.c
ifort  01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf


./a.out

cp ${NETCDF}/include/netcdf.inc .


mpif90 -c 02_fortran+c+netcdf+mpi_f.f
mpicc -c 02_fortran+c+netcdf+mpi_c.c
mpif90 02_fortran+c+netcdf+mpi_f.o 02_fortran+c+netcdf+mpi_c.o -L${NETCDF}/lib -lnetcdff -lnetcdf

mpirun ./a.out
