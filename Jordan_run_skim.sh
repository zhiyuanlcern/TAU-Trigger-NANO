# for d in   Muon0_Run2022D_v2-v1  Muon1_Run2022D_v1-v1  Muon1_Run2022D_v2-v1; #  Muon0_Run2023D_v1-v1
# do
# mkdir -p 2023BPix_skim_output/$d
# mkdir -p 2023BPix_skim_output/logs
# for file in $(find 2023BPix_postproc_output/$d/ -type f); do

#     ## Run the python script in the background
#     ### 2018 MC
#     # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
#     python3 skimTuple.py --era 2023 --type data --nanoVer 13 --selection DeepTau --output 2023BPix_skim_output/$d/$mc/$(basename "$file")  --input $file > skim_output/logs/$d$mc$(basename "$file").log 2>&1 &
#     echo "skimTuple.py --era 2023 --type data --nanoVer 13 --selection DeepTau --output 2023BPix_skim_output/$d/$(basename "$file")  --input $file > skim_output/logs/$d$(basename "$file").log 2>&1 &"
    
    
# done
# done



# for d in  DY; #  Muon0_Run2022D_v2-v1 Muon1_Run2022D_v1-v1 Muon1_Run2022D_v2-v1 Muon0_Run2023C_v2-v1 Muon0_Run2023C_v4-v1 Muon1_Run2023C_v2-v1 Muon1_Run2023C_v4-v1 Muon0_Run2023C_v1-v1 Muon0_Run2023C_v3-v1 Muon1_Run2023C_v1-v1 Muon1_Run2023C_v3-v1 ;
# do
# mkdir -p 2023BPix_skim_output/$d
# mkdir -p 2023BPix_skim_output/logs
# for file in $(find 2023BPix_postproc_output/$d/ -type f); do

#     ## Run the python script in the background
#     ### 2018 MC
#     # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
#     python3 skimTuple.py --era 2023 \
#     --pumc /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/postBPix/DY/pileup_$(basename "$file" | sed 's/_Skim//') \
#     --pudata /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/pileupHistogram-Cert_Collisions2023_369803_370790_eraD_GoldenJson-13p6TeV-69200ub-99bins.root \
#     --type mc --nanoVer 13 --selection DeepTau \
#     --output 2023BPix_skim_output/$d/$mc/$(basename "$file") \
#     --input $file > skim_output/logs/$d$mc$(basename "$file").log 2>&1 &
#     echo ""
    
    
# done
# done



max_jobs=80
i=0
for d in  Muon1_Run2023C_v2-v1 Muon0_Run2023C_v3-v1 Muon0_Run2023C_v1-v1 Muon0_Run2023C_v4-v1 Muon1_Run2023C_v4-v1 Muon1_Run2023C_v1-v1 Muon1_Run2023C_v3-v1 Muon0_Run2023C_v2-v1  ; #  Muon0_Run2023D_v1-v1
do
mkdir -p 2023preBPix_skim_output/$d
mkdir -p 2023preBPix_skim_output/logs
for file in $(find 2023preBPix_postproc_output/$d/ -type f); do

    ## Run the python script in the background
    ### 2018 MC
    # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
    python3 skimTuple.py --era 2023 --type data --nanoVer 13 --selection DeepTau --output 2023preBPix_skim_output/$d/$mc/$(basename "$file")  --input $file > skim_output/logs/$d$mc$(basename "$file").log 2>&1 &
    echo "skimTuple.py --era 2023 --type data --nanoVer 13 --selection DeepTau --output 2023preBPix_skim_output/$d/$(basename "$file")  --input $file > skim_output/logs/$d$(basename "$file").log 2>&1 &"
    # If we've started the maximum number of jobs, wait for them to finish.
    if (( $i % $max_jobs == $((max_jobs-1)) )); then
    # if (( $i % $max_jobs == $((max_jobs-1)) )); then
        echo "Reached max jobs ($max_jobs), waiting..."
        wait
    fi
    i=$((i+1))
    
done
done



for d in  DY; #  Muon0_Run2022D_v2-v1 Muon1_Run2022D_v1-v1 Muon1_Run2022D_v2-v1 Muon0_Run2023C_v2-v1 Muon0_Run2023C_v4-v1 Muon1_Run2023C_v2-v1 Muon1_Run2023C_v4-v1 Muon0_Run2023C_v1-v1 Muon0_Run2023C_v3-v1 Muon1_Run2023C_v1-v1 Muon1_Run2023C_v3-v1 ;
do
mkdir -p 2023preBPix_skim_output/$d
mkdir -p 2023preBPix_skim_output/logs
for file in $(find 2023preBPix_postproc_output/$d/ -type f); do

    ## Run the python script in the background
    ### 2018 MC
    # python3 skimTuple.py --type mc --pu ../python/postprocessing/data/pileup/PileupHistogram-goldenJSON-13tev-2018-99bins_withVar.root --config ./2018trigger.json --selection DeepTau --output skim_output/DYJetsToTauTauToMuTauh_M-50/$(basename "$file")  --input $file > skim_output/logs/DYJets-nohup-simoutput$(basename "$file").log2>&1 &
    
    python3 skimTuple.py --era 2023 \
    --pumc /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/preBPix/DY/pileup_$(basename "$file" | sed 's/_Skim//') \
    --pudata /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/pileupHistogram-Cert_Collisions2023_366403_369802_eraBC_GoldenJson-13p6TeV-69200ub-99bins.root \
    --type mc --nanoVer 13 --selection DeepTau \
    --output 2023preBPix_skim_output/$d/$mc/$(basename "$file") \
    --input $file > skim_output/logs/$d$mc$(basename "$file").log 2>&1 &
    echo ""
    
    
done
done