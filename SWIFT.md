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