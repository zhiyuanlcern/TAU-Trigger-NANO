#!/bin/bash

# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test --maxEntries 20000 > nohup.log 2>&1 &
# nohup python postproc.py --input nano_1.root --isMC 1 --era 2018 --output test  > nohup.log 2>&1 &
#  nohup python postproc.py --inputFileList 2018DYJetsToTauTau.txt --isMC 1 --era 2018 --output DYJetsToTauTauToMuTauh_M-50_output  > nohup.log 2>&1 &


# script="postproc.py"
# log="nohup-tupleproduction.log"
# # Find all files in the directory and pass them to xargs
# find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2018/SingleMuon* -type f | xargs -I % -P 40 sh -c "nohup python $script --isMC 1 --era 2018 --output postproc_output/% --input %  > $log 2>&1 &"



# i=0
# max_jobs=30

# for run in A B C D;
# do 
# for file in $(find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2018/SingleMuon_Run2018$run/ -type f); do
#     output_file="postproc_output/SingleMuon_Run2018$run/$(basename "$file")/$(basename "$file" .root)_Skim.root"
#     # echo $output_file
#     if [ -f $output_file ]; then
#         echo "Output file $output_file already exists, skipping..."
#         continue
#     fi
    
#     # Run the python script in the background
#     nohup python2 postproc.py --isMC 0 --era 2018 --output postproc_output/SingleMuon_Run2018$run/$(basename "$file") --input "$file" > log/postproc_log$run_$(basename "$file") 2>&1 &  
    
#     # If we've started the maximum number of jobs, wait for them to finish.
#     # if (( $i % $max_jobs == 0 )); then
#     #     wait
#     # fi
#     # i=$((i+1))
# done
# done

# find /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2018/SingleMuon* -type f | xargs -I % -P 40 sh -c "echo ' $script --isMC 1 --era 2018 --output $(basename $file)  postproc_output/% --input %  > $log 2>&1 &' "

# script="skimTuple.py"
# log="nohup-skim.log"
# ## skimTuple: source setup-python3.sh 
# # nohup python3 skimTuple.py --input test/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &
# # nohup python3 skimTuple.py --input  DYJetsToTauTauToMuTauh_M-50_output/nano_100_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_102_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_104_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_106_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_10_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_2_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_101_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_103_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_105_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_107_Skim.root DYJetsToTauTauToMuTauh_M-50_output/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &
# # nohup python3 skimTuple.py --input  DYJetsToTauTauToMuTauh_M-50_output/nano_1_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root > nohup-skim.log 2>&1 &



# # for data in SingleMuon_Run2018A SingleMuon_Run2018B  SingleMuon_Run2018C SingleMuon_Run2018D; do
# for data in SingleMuon_Run2017B  SingleMuon_Run2017C  SingleMuon_Run2017D  SingleMuon_Run2017E  SingleMuon_Run2017F; do
#     for file in $(find postproc_output/2017/$data -type f); do
# #     # for file in $(find postproc_output/DYJetsToTauTauToMuTauh_M-50 -type f); do
# #     ## Run the python script in the background
# #     ### MC
# #     # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > nohup-simoutput.log 2>&1 &
    
# #     ### 2018 data
# #     # python3 skimTuple.py --type data --config ./2018trigger.json --selection DeepTau --output skim_output/$data/$(basename "$file") --input $file > skim_output/logs/$data-nohup-simoutput$(basename "$file").log 2>&1 &
# #     ### 2017 data 
#     python3 skimTuple.py --era 2017 --type data --config ./2017trigger.json --selection DeepTau --output skim_output/2017/$data/$(basename "$file") --input $file > skim_output/logs/$data-nohup-simoutput$(basename "$file").log 2>&1 &
# #     # If we've started the maximum number of jobs, wait for them to finish.
#     if (( $(($i % $max_jobs)) == 0 )); then
#         wait
#     fi
#     i=$((i+1))
# done
# done

# wait

## 2018 mc
# for file in $(find postproc_output/DYJetsToTauTauToMuTauh_M-50 -type f); do
## 2017 mc
# for mc in DYJetsToLL_M-50-madgraphMLM DYJetsToLL_M-10to50-madgraphMLM; do


## 2018
# hadd -f MC_merged.root skim_output/DYJetsToTauTauToMuTauh_M-50/*root 
# hadd -f Data_merged.root skim_output/SingleMuon_Run2018*/*root

## 2017 
# hadd -f 2017MC_merged.root skim_output/2017/DYJetsToLL_M-50-madgraphMLM_mutauh/DY* 
# hadd -f 2017Data_merged.root skim_output/2017/SingleMuon_Run2017*/*root

## 2022 
# cd post_proc/2022 
# hadd DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8-postEE.root DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8-postEE/*root &
# hadd DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8-preEE.root DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8-preEE/*root &
# hadd Data_2022-preEE.root Muon2022C/*root Muon2022D/* Muon2022E/* &
# hadd Data_2022-postEE.root Muon2022F/*root Muon2022G/* &
# cd - 




# source setup-python3.sh
# max_jobs=80
# i=0


# for mc in DYJetsToLL_M-50-madgraphMLM_mutauh; do 
#     for file in $(find postproc_output/2017/$mc -type f); do

#     ## Run the python script in the background
#     ### 2018 MC
#     # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
#     ### 2017 MC
#     python3 skimTuple.py --era 2017 --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2017-99bins_withVar.root --config ./2017trigger.json --selection DeepTau --output skim_output/2017/$mc/$(basename "$file")  --input $file > skim_output/logs/2017$mc$(basename "$file").log2>&1 &
    
#     # If we've started the maximum number of jobs, wait for them to finish.
#     if (( $(($i % $max_jobs)) == 0 )); then
#         wait
#     fi
#     i=$((i+1))
# done
# done
# # Wait for any remaining jobs to finish.


# wait 


max_jobs=80
i=0
for run in  Muon0_Run2022D_v1-v1  Muon0_Run2022D_v2-v1  Muon1_Run2022D_v1-v1  Muon1_Run2022D_v2-v1;
do 
for file in $(find  /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/postBPix/${run}/ -type f); do
    output_file="postproc_output/${run}/"
    # echo $output_file
    if [ -f $output_file ]; then
        echo "Output file $output_file already exists, skipping..."
        continue
    fi
    
    # Run the python script in the background
    echo $file $output_file
    python2 postproc.py --isMC 0 --era 2023 --nanoVer 13 --output ${output_file} --input "$file" > log/postproc_log$run_$(basename "$file") 2>&1 &  
    
    # If we've started the maximum number of jobs, wait for them to finish.
    if (( $i % $max_jobs == 0 )); then
        wait
    fi
    i=$((i+1))
done
done
