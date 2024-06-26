# event tuple for 2018
nohup python postproc.py --input /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2018/SingleMuon_Run2018B/nano_18.root --isMC 0 --era 2018 > nohup.log 2>&1 &


##### MC sample 
/DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/RunIISummer19UL18NanoAODv2-106X_upgrade2018_realistic_v15_L1v1-v1/NANOAODSIM
/SingleMuon/Run2018*12Nov2019_UL2018*/MINIAOD

/SingleMuon/Run2018A-UL2018_MiniAODv1_NanoAODv2-v3/NANOAOD
/SingleMuon/Run2018B-UL2018_MiniAODv1_NanoAODv2-v2/NANOAOD
/SingleMuon/Run2018C-UL2018_MiniAODv1_NanoAODv2-v2/NANOAOD
/SingleMuon/Run2018D-UL2018_MiniAODv1_NanoAODv2-v2/NANOAOD

# MC sample
/DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/RunIISummer20UL18NanoAODv2-106X_upgrade2018_realistic_v15_L1v1-v1/NANOAODSIM

nohup python postproc.py --input nanoMC-1.root --isMC 1 --era 2018 > nohup.log 2>&1 &
# run event tuple using MC

nohup python postproc.py --input nanoAOD-2018MC-2.root --isMC 1 --era 2018 > nohup.log 2>&1 &

# run event tuple using data

nohup python postproc.py --input nanoAOD-2018data-1.root --isMC 0 --era 2018 > nohup.log 2>&1 &

# activate ROOT env to run the script

##############
# skim tuple #
##############
nohup python skimTuple.py --input CRAB_1219_output/DYJetsToTauTauToMuTauh_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/*.root --config ./2017trigger.json --selection DeepTau --output 2017skim_1222/2017skim_1222_DYToTauTau.root --type mc --pu PileupHistogram-goldenJSON-13tev-2017-80000ub.root > nohup-skim.log 2>&1 &

nohup python skimTuple.py --input nanoAOD-2018MC_Skim.root --config ./2018trigger.json --selection DeepTau --output test.root --type mc --pu PileupHistogram-goldenJSON-13tev-2018-66000ub-99bins.root > nohup-skim.log 2>&1 &

# test for MC
nohup python skimTuple.py --input nanoAOD-2018MC-2_Skim.root --config ./2018trigger.json --selection DeepTau --output nanoAOD-2018MC-2_Skim-skimtuple.root --type mc --pu PileupHistogram-goldenJSON-13tev-2018-66000ub-99bins.root > nohup-skim-MC.log 2>&1 &
# test for data
nohup python skimTuple.py --input nanoAOD-2018data-1_Skim.root --config ./2018trigger.json --selection DeepTau --output nanoAOD-2018data-1_Skim-skimtuple.root --type data > nohup-skim-data.log 2>&1 &

##################
# create turn on #
##################
nohup python createTurnOn.py --input-data ztest20230404_data/skim_data_weight.root --input-dy-mc ztest20230404_mc/skim_mc_weight.root --output ztest230426/TrunOn --channels mutau > nohup-createTurnOn.log 2>&1 &

nohup python createTurnOn.py --input-data ztest20230404_data/skim_data_weight.root --input-dy-mc ztest20230404_mc/skim_mc_weight.root --output ztest230426/TrunOn --channels mutau --working-points VVVLoose,VVLoose,VLoose,Loose > nohup-createTurnOn.log 2>&1 &

###############
# fit turn on #
###############
nohup python fitTurnOn.py --input ztest230426/TrunOn.root --output ztest230426/fitTrunOn --channels mutau --working-points VVVLoose,VVLoose,VLoose,Loose > nohup-fitTurnOn.log 2>&1 &





###### new test
nohup python postproc.py --input /eos/cms/store/group/phys_tau/TauFW/nanoV10/Run2_2018/DYJetsToTauTauToMuTauh_M-50/nano_99.root --isMC 1 --era 2018 > nohup.log 2>&1 &

nohup python skimTuple.py --input nano_*_Skim.root --selection DeepTau --output nano_skimtuple.root --type mc --pu PileupHistogram-goldenJSON-13tev-2018-66000ub-99bins.root > nohup-skim.log 2>&1 &

nohup python skimTuple.py --input ztest_0514_data/SingleMuon_Run2018A/nano_*_Skim.root --selection DeepTau --output ztest_0514_003/nano_skimtuple.root --type data > nohup-skim.log 2>&1 &

nohup python createTurnOn.py --input-data ztest_0514_003/data_skimtuple.root --input-dy-mc ztest_0514_003/mc_skimtuple.root --output ztest_0514_003/TrunOn --channels mutau > nohup-createTurnOn.log 2>&1 &

nohup python fitTurnOn.py --input ztest_0514_003/TrunOn.root --output ztest_0514_003/fitTrunOn --channels mutau > nohup-fitTurnOn.log 2>&1 &



nohup python createTurnOn.py --input-data ztest_0516_3channel/data_skimtuple.root --input-dy-mc ztest_0516_3channel/mc_skimtuple.root --output ztest_0516_3channel/TrunOn > nohup-createTurnOn.log 2>&1 &


nohup python createTurnOn.py --input-data ztest_0516_3channel_002/data_skimtuple.root --input-dy-mc ztest_0516_3channel_002/mc_skimtuple.root --output ztest_0516_3channel_002/TrunOn > nohup-createTurnOn.log 2>&1 &

nohup python fitTurnOn.py --input ztest_0516_3channel_002/TrunOn.root --output ztest_0516_3channel_002/fitTrunOn > nohup-fitTurnOn.log 2>&1 &


# plot comparision
nohup python TauTriggerTools/TauTagAndProbe/python/plot_ratio.py --input /eos/user/b/boguo/botao/CRAB_/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/ztest_0516_3channel_002/fitTrunOn.root,/eos/user/b/boguo/botao/tau/CMSSW_10_6_17_patch1/src/TauAnalysisTools/TauTriggerSFs/data/2018UL_tauTriggerEff_DeepTau2017v2p1.root --output /eos/user/b/boguo/botao/CRAB_/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/ztest_0516_3channel_002/comparision/plot_2018 > /eos/user/b/boguo/botao/CRAB_/CMSSW_10_6_29/src/PhysicsTools/NanoAODTools/TAU-Trigger-NANO/ztest_0516_3channel_002/comparision/nohup_plot_2018.log 2>&1 &