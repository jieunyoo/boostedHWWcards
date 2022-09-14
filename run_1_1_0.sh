#!/bin/bash 
fail_exit() { echo "$@" 1>&2; exit 1; } 

echo "Start of job on " `date`

cd /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg

source /cvmfs/cms.cern.ch/cmsset_default.sh

eval `scramv1 runtime -sh`

### Prepare environments for FastJet ### 

export FASTJET_BASE=`scram tool info fastjet | grep FASTJET_BASE | sed -e s%FASTJET_BASE=%%`
export PATH=$FASTJET_BASE/bin/:$PATH 

### Prepare environments for LHAPDF ### 

LHAPDF6TOOLFILE=$CMSSW_BASE/config/toolbox/$SCRAM_ARCH/tools/available/lhapdf6.xml    
if [ -e $LHAPDF6TOOLFILE ]; then    
   export LHAPDF_BASE=`cat $LHAPDF6TOOLFILE | grep "<environment name=\"LHAPDF6_BASE\"" | cut -d \" -f 4`    
else    
   export LHAPDF_BASE=`scram tool info lhapdf | grep LHAPDF_BASE | sed -e s%LHAPDF_BASE=%%`    
fi    

echo "LHAPDF_BASE is set to:" $LHAPDF_BASE 
export PATH=$LHAPDF_BASE/bin/:$PATH 
export LHAPDF_DATA_PATH=`$LHAPDF_BASE/bin/lhapdf-config --datadir` 
export PYTHONPATH=.:$PYTHONPATH

cd -
echo "I am here:"
pwd

cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/powheg.input ./
cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/JHUGen.input ./
cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/*.dat  ./
cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/pwhg_main  ./ 
if [ -e /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/obj-gfortran/proclib ]; then
  mkdir ./obj-gfortran/
  cp -pr /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/obj-gfortran/proclib  ./obj-gfortran/
  cp -pr /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/obj-gfortran/*.so  ./obj-gfortran/ 
  export LD_LIBRARY_PATH=`pwd`/lib/:`pwd`/lib64/:`pwd`/obj-gfortran/proclib/:${LD_LIBRARY_PATH}
fi
if [ -e /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/Virt_full_cHHH_0.0.grid ]; then 
  cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/*.grid .
  cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/*.cdf .
  cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/*.py* .
fi 

cp -p /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/powheg.input.1_1 ./powheg.input
echo 1 | ./pwhg_main 
echo "Workdir after run:" 
ls -ltr 
cp -p -v -u *.top /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/. 
cp -p -v -u *.dat /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/. 
cp -p -v -u *.log /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg/boosted/. 
exit 0 
