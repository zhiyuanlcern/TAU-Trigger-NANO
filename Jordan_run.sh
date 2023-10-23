#!/bin/bash

# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test --maxEntries 20000 > nohup.log 2>&1 &
# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test  > nohup.log 2>&1 &
#  nohup python postproc.py --inputFileList 2018DYJetsToTauTau.txt --isMC 1 --era 2018 --output DYJetsToTauTauToMuTauh_M-50_output  > nohup.log 2>&1 &


## This part for running postproc

i=0
max_jobs=30

## 2017 data
# for input in   SingleMuon_Run2017C SingleMuon_Run2017D SingleMuon_Run2017E SingleMuon_Run2017F ;
# do 
# for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2017/$input/ -type f); do    

## 2016 HIPM data
mkdir postproc_output/Run2_2016_HIPM
for input in  SingleMuon_Run2016B SingleMuon_Run2016C SingleMuon_Run2016D SingleMuon_Run2016E SingleMuon_Run2016F;
do 
mkdir postproc_output/Run2_2016_HIPM/$input
for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2016_HIPM/$input/ -type f); do    
    output_file="postproc_output/Run2_2016_HIPM/$input/$(basename "$file")/$(basename "$file" .root)_Skim.root"
    if [ -f $output_file ]; then
        echo "Output file $output_file already exists, skipping..."
        continue
    fi
    # nohup python2 postproc.py --isMC 0 --era 2017 --nanoVer 10 --output postproc_output/$input/$(basename "$file") --input "$file" > log/postproc_log$input$(basename "$file").txt 2>&1 &  
    nohup python2 postproc.py --isMC 0 --era 2016 --nanoVer 10 --output postproc_output/Run2_2016_HIPM/$input/$(basename "$file") --input "$file" > log/postproc_log$input$(basename "$file").txt 2>&1 &  

# If we've started the maximum number of jobs, wait for them to finish.
    if (( $i % $max_jobs == 0 )); then
        wait
    fi
    i=$((i+1))
done
done

## 2016 HIPM MC
for input in  DYJetsToLL_M-10to50-madgraphMLM DYJetsToLL_M-50-madgraphMLM  
mkdir postproc_output/Run2_2016_HIPM/$input
for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2016_HIPM/$input/ -type f); do    
    output_file="postproc_output/Run2_2016_HIPM/$input/$(basename "$file")/$(basename "$file" .root)_Skim.root"
    if [ -f $output_file ]; then
        echo "Output file $output_file already exists, skipping..."
        continue
    fi
    # nohup python2 postproc.py --isMC 0 --era 2017 --nanoVer 10 --output postproc_output/$input/$(basename "$file") --input "$file" > log/postproc_log$input$(basename "$file").txt 2>&1 &  
    nohup python2 postproc.py --isMC 1 --era 2016 --nanoVer 10 --output postproc_output/Run2_2016_HIPM/$input/$(basename "$file") --input "$file" > log/postproc_log$input$(basename "$file").txt 2>&1 &  

# If we've started the maximum number of jobs, wait for them to finish.
    if (( $i % $max_jobs == 0 )); then
        wait
    fi
    i=$((i+1))
done
done


# for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2017/DYJetsToLL_M-50-madgraphMLM/ -type f); do    
# for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2017/DYJetsToLL_M-10to50-madgraphMLM/ -type f); do    
    # echo $output_file
    
    # Run the python script in the background
    # nohup python2 postproc.py --isMC 0 --era 2018 --output postproc_output/SingleMuon_Run2018$run/$(basename "$file") --input "$file" > log/postproc_log$run_$(basename "$file") 2>&1 &  
    # nohup python2 postproc.py --isMC 1 --era 2017 --nanoVer 10 --output postproc_output/DYJetsToLL_M-10to50-madgraphMLM/$(basename "$file") --input "$file" > log/postproc_log$(basename "$file").txt 2>&1 &  
    
    


##  this part for running skimtuple 
# source setup-python3.sh
# max_jobs=80
# i=0

# for data in SingleMuon_Run2018A SingleMuon_Run2018B  SingleMuon_Run2018C SingleMuon_Run2018D; do
#     for file in $(find postproc_output/$data -type f); do
#     # for file in $(find postproc_output/DYJetsToTauTauToMuTauh_M-50 -type f); do
#     ## Run the python script in the background
#     ### MC
#     # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > nohup-simoutput.log 2>&1 &
    
#     ### data
#     python3 skimTuple.py --type data --config ./2018trigger.json --selection DeepTau --output skim_output/$data/$(basename "$file") --input $file > skim_output/logs/$data-nohup-simoutput$(basename "$file").log 2>&1 &
#     # If we've started the maximum number of jobs, wait for them to finish.
#     if (( $(($i % $max_jobs)) == 0 )); then
#         wait
#     fi
#     i=$((i+1))
# done
# done

# wait


# for file in $(find postproc_output/DYJetsToTauTauToMuTauh_M-50 -type f); do
#     ## Run the python script in the background
#     ### MC
#     python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
#     # If we've started the maximum number of jobs, wait for them to finish.
#     if (( $(($i % $max_jobs)) == 0 )); then
#         wait
#     fi
#     i=$((i+1))

# done
# # Wait for any remaining jobs to finish.
# wait 

# hadd -f MC_merged.root skim_output/DYJetsToTauTauToMuTauh_M-50/*root 
# hadd -f Data_merged.root skim_output/SingleMuon_Run2018*/*root
