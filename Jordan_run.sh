#!/bin/bash

# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test --maxEntries 20000 > nohup.log 2>&1 &
# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test  > nohup.log 2>&1 &
#  nohup python postproc.py --inputFileList 2018DYJetsToTauTau.txt --isMC 1 --era 2018 --output DYJetsToTauTauToMuTauh_M-50_output  > nohup.log 2>&1 &


# script="postproc.py"
# log="nohup-tupleproduction.log"
# # Find all files in the directory and pass them to xargs
# find DYJetsToTauTauToMuTauh_M-50/ -type f | xargs -I % -P 40 sh -c "nohup python $script --isMC 1 --era 2018 --output postproc_output/% --input %  > $log 2>&1 &"


# script="skimTuple.py"
# log="nohup-skim.log"
# ## skimTuple: source setup-python3.sh 
# # nohup python3 skimTuple.py --input test/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &
# # nohup python3 skimTuple.py --input  DYJetsToTauTauToMuTauh_M-50_output/nano_100_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_102_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_104_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_106_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_10_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_2_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_101_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_103_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_105_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_107_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &
# # nohup python3 skimTuple.py --input  DYJetsToTauTauToMuTauh_M-50_output/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &

max_jobs=40
i=0

for file in $(find postproc_output/ -type f); do
    # Run the python script in the background
    python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/$(basename $file) --input $file > nohup-simoutput.log 2>&1 &
    
    # If we've started the maximum number of jobs, wait for them to finish.
    if (( $(($i % $max_jobs)) == 0 )); then
        wait
    fi
    i=$((i+1))
done

# Wait for any remaining jobs to finish.
wait