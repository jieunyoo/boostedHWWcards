# boostedHWWcards

The twiki instructions were followed, except I used:

    export SCRAM_ARCH=slc7_amd64_gcc700
    
    cmsrel CMSSW_10_6_21

A directory was made in: /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg

powheg.input was placed in /afs/cern.ch/user/j/jiyoo/CMSSW_10_6_21/src/genproductions/bin/Powheg

Also, JHUGen.input was in my home directory.


These commands were used:


    python ./run_pwg_condor.py -p 0 -i powheg.input -g ~/JHUGen.input -m HZJ -f boosted | tee output.txt

    python ./run_pwg_condor.py -p 1 -x 1 -i powheg.input -g ~/JHUGen.input -m HZJ -f boosted -q longlunch  

Note: error in error log can be ignored
