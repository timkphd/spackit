# Build From Scratch

This document and repository discusses building up a environemnt on a new cluster.  This is of interst for three machines.  

1. Vermilion 
	1. 	vs-login-1.hpc.nrel.gov
	1. vs-login-2.hpc.nrel.gov
	1. POC - Bendl, Kurt <Kurt.Bendl@nrel.gov>
1. Swift 
	1.  eagletgw1.hpc.nrel.gov
	2. POC - 	Broadley, Bill <Bill.Broadley@nrel.gov>
1. Cloud
	1. ec2-user - user Name
	1. ec2-3-142-149-83.us-east-2.compute.amazonaws.com
	2. POC - Sayers, Kevin <Kevin.Sayers@nrel.gov>


Kurt and Bill will do the base OS on their machines. 	
## Cloud
For the cloud machine Kevin did the initial setup.

I noted that ec2 had gcc but the development environemnt was not complete for example is did not have g++ or gfortran.  I also needed git so I did a


```
sudo yum group install "Development Tools"
sudo yum install git
sudo yum install cmake
```

This gives us:

```
gcc version 7.3.1 20180712 (Red Hat 7.3.1-13) (GCC) 
[ec2-user@ip-172-31-17-54 ~]$ gcc -v 2>&1 | tail -1
gcc version 7.3.1 20180712 (Red Hat 7.3.1-13) (GCC) 
[ec2-user@ip-172-31-17-54 ~]$ g++ -v 2>&1 | tail -1
gcc version 7.3.1 20180712 (Red Hat 7.3.1-13) (GCC) 
[ec2-user@ip-172-31-17-54 ~]$ gfortran -v 2>&1 | tail -1
gcc version 7.3.1 20180712 (Red Hat 7.3.1-13) (GCC) 
[ec2-user@ip-172-31-17-54 ~]$ cmake --version 2>&1 | tail -1
cmake version 2.8.12.2

```

Next I installed spack

git clone https://github.com/spack/spack.git

Spack can be initialized with the command:

```
source /home/ec2-user/spack/share/spack/setup-env.sh
```
At this point we could build packages with spack, for example:

```
spack install wget
```
However we should run this first:

```
spack compiler find
```

The important, at this point, configure files are:


```
[ec2-user@ip-172-31-17-54 ~]$ ls spack/etc/spack/defaults/*yaml
spack/etc/spack/defaults/config.yaml   
spack/etc/spack/defaults/modules.yaml   
spack/etc/spack/defaults/repos.yaml
spack/etc/spack/defaults/mirrors.yaml  
spack/etc/spack/defaults/packages.yaml
[ec2-user@ip-172-31-17-54 ~]$ 
```

We will leave these untouched but copy them to ~/.spack for modification.  Files in this directory overload the defaults.  Running the command *spack compiler find* adds a compilers.yaml file to the ~/.spack directory.


You can get copies of the *.yaml files from the repository [https://github.com/timkphd/spackit.git](https://github.com/timkphd/spackit.git)

Note there are two versions of the compilers.yaml file.  *compilers.backup* was the one created  initialy with the *spack compiler find* command.  If you are rebuilding the environment from scratch this should is the one you should start with.


The config.yaml file determines the placement of the compiled applications. We have changed it to read:

```
# -------------------------------------------------------------------------
config:
  # This is the path to the root of the Spack install tree.
  # You can use $spack here to refer to the root of the spack instance.
  install_tree:
          #    root: $spack/opt/spack
    root: /nopt/nrel
    projections:
            #all: "${ARCHITECTURE}/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}-${HASH}"
      all: "base/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}"
    # install_tree can include an optional padded length (int or boolean)
```

where the initial *root* and *all* lines are commented out and replaced with the new lines.  Everythin gets installed under /nopt/root.  Our default compiler/vompile version is gcc 7.3.1.  Then each package gets its own directory.  Normally has a random character string appended but that is surpressed here.

Before we get to our first build and what that produced it is useful to discuss the modules.yaml file.  This file determines where our mouldes are created and the the "type".  We have
```
...
...
    roots:
            #tcl: /nopt/nrel/spack/modules/tcl
            #lmod: /nopt/nrel/spack/modules/lmod
      tcl: /nopt/nrel/modules/tcl
      lmod: /nopt/nrel/modules/lmod
    enable:
    - tcl
    - lmod
...
...
```
The modules will be created in /nopt/rnrel/modules/[tcl,lmod].  We are creating the old and new style modules and they will each have their own directory.


## Our first install

Our first install with spack is:

```
spack install gcc@9.4.0
```

There are a number of dependecies for this so we ended up with:

```
[ec2-user@ip-172-31-17-54 gcc-7.3.1]$ pwd
/nopt/nrel/base/gcc-7.3.1
[ec2-user@ip-172-31-17-54 gcc-7.3.1]$ ls
autoconf-2.69    berkeley-db-18.1.40  gcc-9.4.0  gmp-6.2.1      libsigsegv-2.13  m4-1.4.19  mpfr-3.1.6   perl-5.34.0    readline-8.1
automake-1.16.3  diffutils-3.7        gdbm-1.19  libiconv-1.16  libtool-2.4.6    mpc-1.1.0  ncurses-6.2  pkgconf-1.7.4  zlib-1.2.11
[ec2-user@ip-172-31-17-54 gcc-7.3.1]$ 
```

Our actuall gcc bin install directory is:

```

/nopt/nrel/base/gcc-7.3.1/gcc-9.4.0/bin
[ec2-user@ip-172-31-17-54 bin]$ ls
c++  gcc     gcc-ranlib  gcov-tool                x86_64-pc-linux-gnu-g++        x86_64-pc-linux-gnu-gcc-ar      x86_64-pc-linux-gnu-gfortran
cpp  gcc-ar  gcov        gfortran                 x86_64-pc-linux-gnu-gcc        x86_64-pc-linux-gnu-gcc-nm
g++  gcc-nm  gcov-dump   x86_64-pc-linux-gnu-c++  x86_64-pc-linux-gnu-gcc-9.4.0  x86_64-pc-linux-gnu-gcc-ranlib
[ec2-user@ip-172-31-17-54 bin]$ 
```

At this point we did something a little different.  We went back to our ~/.spack/compilers.yaml file and changed the know path to for our compilers to point to this version of gcc.

Then we did another 

```
spack install gcc@9.4.0
```

This gave us a version of gcc 9.4.0 built with gcc 9.4.0 and more importantly a new directory */nopt/nrel/base/gcc-9.4.0* which is independent of the system installed version of the compilers.  We again changed our paths in the compiler.yaml file to point to this version.  All furture spack builds will use this compiler set unless otherwise specified in a recipe.  

Our next installs were

```
spack install cmake
spack install lmod
```

The version of cmake initially on the machine was ancient and we want lmod to point to packages with modules.

After lmod is installed we can enable it by sourcing the lines:

```
source /nopt/nrel/base/gcc-9.4.0/lmod-8.5.6/lmod/8.5.6/init/bash
module use  /nopt/nrel/modules/lmod/linux-amzn2-x86_64/gcc/9.4.0
```


Note:  These are in the file myenv, along with a number of utility functions including the line:

```
alias spackit="source /home/ec2-user/spack/share/spack/setup-env.sh"
```

which can be used to prepare spack for additional installs.  For example:

```
[ec2-user@ip-172-31-17-54 ~]$ spack install python@3.9.6
-bash: spack: command not found
[ec2-user@ip-172-31-17-54 ~]$ spackit
[ec2-user@ip-172-31-17-54 ~]$ spack install python@3.9.6
```

We also install MPICH and the Intel compilers with the lines:

```
spack install intel-oneapi-ccl intel-oneapi-compilers intel-oneapi-dal intel-oneapi-dnn intel-oneapi-ipp intel-oneapi-ippcp intel-oneapi-mkl intel-oneapi-mpi intel-oneapi-tbb intel-oneapi-vpl
spack install mpich
```

After that we can build and run a trivial MPI/OpenMP example with both MPICH and Intel compliers.

```

[ec2-user@ip-172-31-17-54 spackit]$ module purge
[ec2-user@ip-172-31-17-54 spackit]$ module load intel-oneapi-mpi/2021.2.0-kjdvowf
[ec2-user@ip-172-31-17-54 spackit]$ module load intel-oneapi-compilers
[ec2-user@ip-172-31-17-54 spackit]$ mpiicc -fopenmp phostone.c -o phostone
[ec2-user@ip-172-31-17-54 spackit]$ mpiifort -fopenmp fhostone.f90 -o fhostone
[ec2-user@ip-172-31-17-54 spackit]$ export OMP_NUM_THREADS=3
[ec2-user@ip-172-31-17-54 spackit]$ mpiexec -n 2 ./phostone -F
MPI VERSION Intel(R) MPI Library 2021.2 for Linux* OS

task    thread             node name  first task    # on node  core
0000      0000    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0026
0000      0001    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0000
0000      0002    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0001
0001      0000    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0035
0001      0001    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0009
0001      0002    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0012
[ec2-user@ip-172-31-17-54 spackit]$ mpiexec -n 2 ./fhostone -F
MPI Version:Intel(R) MPI Library 2021.2 for Linux* OS

task    thread             node name  first task    # on node  core
0000      0000    ip-172-31-17-54.us        0000         0000   026
0000      0001    ip-172-31-17-54.us        0000         0000   000
0000      0002    ip-172-31-17-54.us        0000         0000   001
0001      0000    ip-172-31-17-54.us        0000         0001   035
0001      0001    ip-172-31-17-54.us        0000         0001   010
0001      0002    ip-172-31-17-54.us        0000         0001   011
[ec2-user@ip-172-31-17-54 spackit]$ 
[ec2-user@ip-172-31-17-54 spackit]$ 
[ec2-user@ip-172-31-17-54 spackit]$ module purge
[ec2-user@ip-172-31-17-54 spackit]$ module load gcc/9.4.0-obnswta 
[ec2-user@ip-172-31-17-54 spackit]$ module load mpich
[ec2-user@ip-172-31-17-54 spackit]$ mpicc -fopenmp phostone.c -o phostone
[ec2-user@ip-172-31-17-54 spackit]$ mpif90 -fopenmp fhostone.f90 -o fhostone
[ec2-user@ip-172-31-17-54 spackit]$ mpiexec -n 2 ./phostone -F
MPI VERSION MPICH Version:	3.4.2
MPICH Release date:	Wed May 26 15:51:40 CDT 2021
MPICH ABI:	13:11:1
MPICH Device:	ch4:ofi
MPICH configure:	--prefix=/nopt/nrel/base/gcc-9.4.0/mpich-3.4.2 --disable-silent-rules --enable-shared --with-hwloc-prefix=/nopt/nrel/base/gcc-9.4.0/hwloc-2.5.0 --with-pm=hydra --enable-romio --without-ibverbs --enable-wrapper-rpath=yes --with-slurm=no --with-pmi=simple --with-device=ch4:ofi --with-libfabric=/nopt/nrel/base/gcc-9.4.0/libfabric-1.12.1 --enable-libxml2
MPICH CC:	/home/ec2-user/spack/lib/spack/env/gcc/gcc    -O2
MPICH CXX:	/home/ec2-user/spack/lib/spack/env/gcc/g++   -O2
MPICH F77:	/home/ec2-user/spack/lib/spack/env/gcc/gfortran   -O2
MPICH FC:	/home/ec2-user/spack/lib/spack/env/gcc/gfortran   -O2

task    thread             node name  first task    # on node  core
0000      0000    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0035
0000      0002    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0008
0000      0001    ip-172-31-17-54.us-east-2.compute.internal        0000         0000  0020
0001      0000    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0005
0001      0001    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0009
0001      0002    ip-172-31-17-54.us-east-2.compute.internal        0000         0001  0010
[ec2-user@ip-172-31-17-54 spackit]$ mpiexec -n 2 ./fhostone -F
MPI Version:MPICH Version:	3.4.2
MPICH Release date:	Wed May 26 15:51:40 CDT 2021
MPICH ABI:	13:11:1
MPICH Device:	ch4:ofi
MPICH configure:	--prefix=/nopt/nrel/base/gcc-9.4.0/mpich-3.4.2 --disable-silent-rules --enable-shared --with-hwloc-prefix=/nopt/nrel/base/gcc-9.4.0/hwloc-2.5.0 --with-pm=hydra --enable-romio --without-ibverbs --enable-wrapper-rpath=yes --with-slurm=no --with-pmi=simple --with-device=ch4:ofi --with-libfabric=/nopt/nrel/base/gcc-9.4.0/libfabric-1.12.1 --enable-libxml2
MPICH CC:	/home/ec2-user/spack/lib/spack/env/gcc/gcc    -O2
MPICH CXX:	/home/ec2-user/spack/lib/spack/env/gcc/g++   -O2
MPICH F77:	/home/ec2-user/spack/lib/spack/env/gcc/gfortran   -O2
MPICH FC:	/home/ec2-user/spack/lib/spack/env/gcc/gfortran   -O2

task    thread             node name  first task    # on node  core
0000      0000    ip-172-31-17-54.us        0000         0000   035
0000      0002    ip-172-31-17-54.us        0000         0000   010
0000      0001    ip-172-31-17-54.us        0000         0000   002
0001      0000    ip-172-31-17-54.us        0000         0001   025
0001      0002    ip-172-31-17-54.us        0000         0001   015
0001      0001    ip-172-31-17-54.us        0000         0001   011
[ec2-user@ip-172-31-17-54 spackit]$ 
```



## Custom and customizing packages

There is repositoy of recipies for building packages at [https://spack.readthedocs.io/en/latest/package_list.html](https://spack.readthedocs.io/en/latest/package_list.html)

You can customize builds by specifing arguments on the command line.  See: [https://spack.readthedocs.io/en/latest/features.html#simple-package-installation]()

Also, you can download a recipe and modify it.  First create a location for storing package recipes.  Recipes are python classes.  

```
spack repo create myrepo
spack repo add /home/ec2-user/myrepo
```

Create a subdirectory for the recipe and download it.  Say we want to build *mpibash* from a modified recipe.  We would put the original recipe in a subdirectory *~/myrepo/packages/mpibash* and modify it.  Our directory structure would be:

```
[ec2-user@ip-172-31-17-54 ~]$ ls -R myrepo/
myrepo/:
packages  repo.yaml

myrepo/packages:
mpibash

myrepo/packages/mpibash:
package.py
[ec2-user@ip-172-31-17-54 ~]$ 
```
You can create a template for a package using the commands

```
spack create bonk
```

or 

```
spack create https://raw.githubusercontent.com/timkphd/examples/master/hybrid/fhostone.f90
```

The first instance creates a template assuming the source is local; the second form assumes the source will be downloaded.  Source can be a tar ball.


## Installing VASP

VASP can be installed via spack.  However, since the source is licensed it will not be downloaded.  You will need to have a copy in your directory before building it.  


## Pointing to preinstalled apps/libs instead of building them

When spack builds a package it will by default download dependancies and build them, often even if the dependancy is installed as part of the OS.  You can tell spack to usa a local copy of software instead of building it.  The file ~/.spack/packages.yaml has an example of how this is done.  (Actually the code is commented out.)  We have:

```
. . .
packages:
        #  berkeley-db:
        #    externals:
        #    - spec: "berkeley-db@18.1.40"
        #      prefix: /usr/bin
. . .
```

Remove the "#"s and spacke will use a version of *berkeley-db* installed int /usr/bin.


## Spack Hierarchies
























 


