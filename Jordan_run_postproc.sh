
# max_jobs=80
# i=0
# for run in    Muon0_Run2022D_v2-v1  Muon1_Run2022D_v1-v1  Muon1_Run2022D_v2-v1 ; #  Muon0_Run2022D_v1-v1
# do 
# for file in $(find  /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/postBPix/${run}/ -type f); do
#     output_file="2023BPix_postproc_output/${run}/"
#     # echo $output_file
#     if [ -f $output_file ]; then
#         echo "Output file $output_file already exists, skipping..."
#         continue
#     fi
    
#     # Run the python script in the background
#     echo $file $output_file
#     python2 postproc.py --isMC 0 --era 2023 --nanoVer 13 --output ${output_file} --input "$file" > log/postproc_log$run_$(basename "$file").log 2>&1 &  
    
#     # If we've started the maximum number of jobs, wait for them to finish.
#     if (( $i % $max_jobs == 0 )); then
#         wait
#     fi
#     i=$((i+1))
# done
# done




# _jobs=80
# i=0
# for run in  DY ; #  
# do 
# for file in $(find  /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/postBPix/${run}/ -type f); do
#     output_file="2023BPix_postproc_output/${run}/"
#     # echo $output_file
#     if [ -f $output_file ]; then
#         echo "Output file $output_file already exists, skipping..."
#         continue
#     fi
#     ##
#     if [[ "$file" == *"pileup"* ]]; then
#         echo "Skipping pileup file: $file"
#         continue
#     fi


#     # Run the python script in the background
#     echo $file $output_file
#     python2 postproc.py --isMC 1 --era 2023 --nanoVer 13 --output ${output_file} --input "$file" > log/postproc_log$run_$(basename "$file").log 2>&1 &  
    
#     # If we've started the maximum number of jobs, wait for them to finish.
#     # if (( $i % $max_jobs == 0 )); then
#     #     wait
#     # fi
#     # i=$((i+1))
# done
# done




max_jobs=80
i=0
for run in   Muon1_Run2023C_v2-v1 Muon0_Run2023C_v3-v1 Muon0_Run2023C_v1-v1 Muon0_Run2023C_v4-v1 Muon1_Run2023C_v4-v1 Muon1_Run2023C_v1-v1 Muon1_Run2023C_v3-v1 Muon0_Run2023C_v2-v1  ; 
do 
for file in $(find  /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/preBPix/${run}/ -type f); do
    output_file="2023preBPix_postproc_output/${run}/$(basename "$file" .root)_postproc.root"
    # echo $output_file
    if [ -f $output_file ]; then
        echo "Output file $output_file already exists, skipping..."
        continue
    fi
    mkdir -p "2023preBPix_postproc_output/${run}/"
    mkdir -p log/
    # Run the python script in the background
    echo $file $output_file
    # python2 postproc.py --isMC 0 --era 2023 --nanoVer 13 --output ${output_file} --input "$file" > log/postproc_log$run_$(basename "$file").log 2>&1 &  
    
    # If we've started the maximum number of jobs, wait for them to finish.
    if (( $i % $max_jobs == $((max_jobs-1)) )); then
    # if (( $i % $max_jobs == $((max_jobs-1)) )); then
        echo "Reached max jobs ($max_jobs), waiting..."
        wait
    fi
    i=$((i+1))
done
done

# Wait for any remaining jobs
wait




_jobs=80
i=0
for run in  DY ; #  
do 
for file in $(find  /data/bond/botaoguo/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/2023/preBPix/${run}/ -type f); do
    output_file="2023preBPix_postproc_output/${run}/"
    # echo $output_file
    if [ -f $output_file ]; then
        echo "Output file $output_file already exists, skipping..."
        continue
    fi
    ##
    if [[ "$file" == *"pileup"* ]]; then
        echo "Skipping pileup file: $file"
        continue
    fi


    # Run the python script in the background
    echo $file $output_file
    # python2 postproc.py --isMC 1 --era 2023 --nanoVer 13 --output ${output_file} --input "$file" > log/postproc_log$run_$(basename "$file").log 2>&1 &  
    
    # If we've started the maximum number of jobs, wait for them to finish.
    # if (( $i % $max_jobs == 0 )); then
    #     wait
    # fi
    # i=$((i+1))
done
done

