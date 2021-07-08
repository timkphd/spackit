## OS version

[https://rockylinux.org](https://rockylinux.org)

Rocky Linux aims to function as a downstream build as CentOS had done previously, building releases after they have been added by the upstream vendor, not before.

## Install miniconda

```
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
chmod 755 Miniconda3-py39_4.9.2-Linux-x86_64.sh 
./Miniconda3-py39_4.9.2-Linux-x86_64.sh 



  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/home/tkaiser2/miniconda3] >>> /nopt/nrel/apps/anaconda/mini_py39_4.9.2


mini_py39_4.9.2
[tkaiser2@eaglet conda]$ cat /nopt/nrel/apps/modules/jul21/modulefiles/conda/mini_py39_4.9.2 
#%Module -*- tcl -*-

conflict python

proc ModulesHelp { } {
    global version
    puts stderr "Name: conda"
    puts stderr "Version: $version"
    puts stderr "Category: Programming language, Python"
    puts stderr "User's Guide: http://docs.python.org/3/reference/"
    puts stderr "Description: Anaconda is a Python distribution for large-scale"
    puts stderr "data processing, predictive analytics and scientific computing."
    puts stderr "Environment variables modified:"
    puts stderr "  PATH - prepended with anaconda binary location"
    puts stderr "  MANPATH - prepended with anaconda man location"
    puts stderr "To list installed python packages:"
    puts stderr "  conda list"
}

set version mini_py39_4.9.2
module-whatis "Anaconda $version with iopro, numbapro, and mkl extensions."

#
# Create env variables
#
set		conda_dir	   /nopt/nrel/apps/anaconda/$version
prepend-path	PATH	   	   $conda_dir/bin
prepend-path	MANPATH		   $conda_dir/share/man
setenv		CONDA_ENVS_PATH	   ~/.conda-envs
setenv          CONDA_PKGS_DIRS    ~/.conda-pkgs
setenv          REQUESTS_CA_BUNDLE /etc/ssl/certs/ca-bundle.crt

[tkaiser2@eaglet conda]$ 





Last login: Tue Jul  6 11:00:07 2021 from 10.10.137.141
[tkaiser2@eaglet ~]$ module use /nopt/nrel/apps/modules/jul21/modulefiles
[tkaiser2@eaglet ~]$ ml conda/mini_py39_4.9.2 
[tkaiser2@eaglet ~]$ which python
/nopt/nrel/apps/anaconda/mini_py39_4.9.2/bin/python
[tkaiser2@eaglet ~]$ 




  172  module use /nopt/nrel/apps/modules/jul21/modulefiles 
  173  ml conda/mini_py39_4.9.2 
  174  python
  175  export MYVERSION=dompt
  176  conda create --name $MYVERSION jupyter matplotlib scipy pandas xlwt dask -y
  177  source activate 
  178  source activate  dompt
  179  which python
  180  python
  181  history

>>> 
(/home/tkaiser2/.conda-envs/dompt) [tkaiser2@eaglet ~]$ which python
~/.conda-envs/dompt/bin/python
(/home/tkaiser2/.conda-envs/dompt) [tkaiser2@eaglet ~]$ python
Python 3.9.5 (default, Jun  4 2021, 12:28:51) 
[GCC 7.5.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import numpy
>>> 

```


After doing a spack install gcc@9.4.0 I created.

```
[tkaiser2@eaglet spackit]$ cat ~/.spack/compilers.yaml 
compilers:
- compiler:
    spec: gcc@9.4.0
    paths:
      cc: /nopt/nrel/apps/base/gcc-8.4.1/gcc-9.4.0/bin/gcc
      cxx: /nopt/nrel/apps/base/gcc-8.4.1/gcc-9.4.0/bin/g++
      f77: /nopt/nrel/apps/base/gcc-8.4.1/gcc-9.4.0/bin/gfortran
      fc: /nopt/nrel/apps/base/gcc-8.4.1/gcc-9.4.0/bin/gfortran
    flags: {}
    operating_system: rocky8
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []

[tkaiser2@eaglet spackit]$ 
```

Then updated  compilers.yaml

```
[tkaiser2@eaglet .spack]$ cat compilers.yaml 
compilers:
- compiler:
    spec: gcc@9.4.0
    paths:
      cc: /nopt/nrel/apps/base/gcc-9.4.0/gcc-9.4.0/bin/gcc
      cxx: /nopt/nrel/apps/base/gcc-9.4.0/gcc-9.4.0/bin/g++
      f77: /nopt/nrel/apps/base/gcc-9.4.0/gcc-9.4.0/bin/gfortran
      fc: /nopt/nrel/apps/base/gcc-9.4.0/gcc-9.4.0/bin/gfortran
    flags: {}
    operating_system: rocky8
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []

[tkaiser2@eaglet .spack]$ 
```

This is my base system.




[tkaiser2@eaglet spack]$ pwd
/home/tkaiser2/spack
[tkaiser2@eaglet spack]$ git status
On branch develop
Your branch is up to date with 'origin/develop'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   etc/spack/defaults/config.yaml
	modified:   etc/spack/defaults/modules.yaml

no changes added to commit (use "git add" and/or "git commit -a")
[tkaiser2@eaglet spack]$ 



## level01

```

[tkaiser2@eaglet defaults]$ pwd
/home/tkaiser2/level01/spack/etc/spack/defaults
[tkaiser2@eaglet defaults]$ diff -r . /home/tkaiser2/spack/etc/spack/defaults
diff -r ./config.yaml /home/tkaiser2/spack/etc/spack/defaults/config.yaml
26d25
<       all: "level01/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}"
diff -r ./modules.yaml /home/tkaiser2/spack/etc/spack/defaults/modules.yaml
33,34c33,34
<       tcl: /nopt/nrel/apps/modules/level01/tcl
<       lmod: /nopt/nrel/apps/modules/level01/lmod
---
>       tcl: /nopt/nrel/apps/modules/tcl
>       lmod: /nopt/nrel/apps/modules/lmod
44c44
<       - gcc@9.4.0
---
>       - gcc@7.3.1
Only in .: .modules.yaml.swp
Only in .: upstreams.yaml
[tkaiser2@eaglet defaults]$ vi modules.yaml 
[tkaiser2@eaglet defaults]$ diff -r . /home/tkaiser2/spack/etc/spack/defaults
diff -r ./config.yaml /home/tkaiser2/spack/etc/spack/defaults/config.yaml
26d25
<       all: "level01/${COMPILERNAME}-${COMPILERVER}/${PACKAGE}-${VERSION}"
diff -r ./modules.yaml /home/tkaiser2/spack/etc/spack/defaults/modules.yaml
33,34c33,34
<       tcl: /nopt/nrel/apps/modules/level01/tcl
<       lmod: /nopt/nrel/apps/modules/level01/lmod
---
>       tcl: /nopt/nrel/apps/modules/tcl
>       lmod: /nopt/nrel/apps/modules/lmod
44c44
<       - gcc@9.4.0
---
>       - gcc@7.3.1
Only in .: upstreams.yaml
[tkaiser2@eaglet defaults]$ cat upstreams.yaml 
upstreams:
  spack-base:
    install_tree: /nopt/nrel/apps
    modules:
            lmod: /nopt/nrel/apps/modules/lmod/linux-amzn2-x86_64/gcc/9.4.0

[tkaiser2@eaglet defaults]$ 
```




