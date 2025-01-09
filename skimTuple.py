#!/usr/bin/env python

import argparse
from array import array
import math
import numpy as np
import os
import re
import sys
import ROOT

parser = argparse.ArgumentParser(description='Skim full tuple.')
parser.add_argument('--input', required=True, type=str, nargs='+', help="input files")
parser.add_argument('--config', required=False, type=str, help="config with triggers description")
# parser.add_argument('--config', required=True, type=str, help="config with triggers description")
parser.add_argument('--selection', required=True, type=str, help="tau selection")
parser.add_argument('--output', required=True, type=str, help="output file")
parser.add_argument('--type', required=True, type=str, help="data or mc")
parser.add_argument('--pu', required=False, type=str, default=None,
                    help="file with the pileup profile for the data taking period")
parser.add_argument('--era', required=True, type=int, default=2018,
                    help="data taking period")
parser.add_argument('--nanoVer', required=True, type=int, default=11,
                    help="data taking period")


args = parser.parse_args()

path_prefix = '' if 'TAU-Trigger-NANO' in os.getcwd() else 'TAU-Trigger-NANO/'
sys.path.insert(0, path_prefix + 'Common/python')
from AnalysisTypes import *
from AnalysisTools import *
import TriggerConfig
ROOT.ROOT.EnableImplicitMT(4)
ROOT.gROOT.SetBatch(True)
ROOT.gInterpreter.Declare('#include "{}interface/PyInterface.h"'.format(path_prefix))
ROOT.gInterpreter.Declare('#include "{}interface/picoNtupler.h"'.format(path_prefix))

if args.type not in ['data', 'mc']:
    raise RuntimeError("Invalid sample type")

MC_without_pu = False
input_vec = ListToStdVector(args.input)
if args.type == 'mc':
    if args.pu is None:
        print("RuntimeWarning: Pileup file should be provided for mc!!!!!!!!")
        MC_without_pu =  True
    else:
        data_pu_file = ROOT.TFile(args.pu, 'READ')
        data_pu = data_pu_file.Get('pileup')
        df_all = ROOT.RDataFrame('Events', input_vec)
        mc_pu = df_all.Histo1D(ROOT.RDF.TH1DModel(data_pu), 'npu')
        ROOT.PileUpWeightProvider.Initialize(data_pu, mc_pu.GetPtr())


selection_id = ParseEnum(TauSelection, args.selection)
print("selection_id", selection_id)
df = ROOT.RDataFrame('Events', input_vec)
# df = df.Filter('''
#                muon_pt > 27 && muon_iso < 0.1 
#                && second_tau_pt > 20 && best_tau_pt > 27 
#                ''')

## lowering muon pt and tag tau pt cut to increase stats
print(" ===============      before selection       ================= ",df.Count().GetValue() )
df = df.Filter('''muon_pt > 20 && muon_iso < 0.1  && muon_mt < 60
               && best_tau_pt > 20 && abs(best_tau_eta) < 2.3 && best_tau_decayMode != 5 && best_tau_decayMode != 6
               && second_tau_pt > 20 && second_tau_decayMode != 5 && second_tau_decayMode != 6 '''
               ).Filter("sqrt(std::pow((best_tau_eta - second_tau_eta),2) + std::pow(ROOT::Math::VectorUtil::Phi_mpi_pi(best_tau_phi - second_tau_phi),2)) > 0.5"
               ).Filter("sqrt(std::pow((muon_eta - second_tau_eta),2) + std::pow(ROOT::Math::VectorUtil::Phi_mpi_pi(muon_phi - second_tau_phi),2)) > 0.5"
               ).Filter("sqrt(std::pow((muon_eta - best_tau_eta),2) + std::pow(ROOT::Math::VectorUtil::Phi_mpi_pi(muon_phi - best_tau_phi),2)) > 0.5")
               # && best_tau_decayMode != 5 && best_tau_decayMode != 6
            #    && second_tau_decayMode != 5 && second_tau_decayMode != 6
print(" ===============      after selection       ================= ",df.Count().GetValue() )
# if selection_id == TauSelection.DeepTau:
#     df = df.Filter('second_tau_idDeepTau2017v2p1VSmu >= {}'.format(DiscriminatorWP.Medium))
    # df = df.Filter('( tau_idDeepTau2017v2p1VSmu  & (1 << {})) != 0'.format(DiscriminatorWP.Medium))
    # df = df.Filter('( (tau_idDeepTau2017v2p1VSmu << 2) & (1 << {})) != 0'.format(DiscriminatorWP.Medium))
    # df = df.Filter('( (tau_idDeepTau2018v2p5VSmu << 2) & (1 << {})) != 0'.format(DiscriminatorWP.Medium))
if args.type == 'mc':
    # df = df.Filter('second_tau_charge + muon_charge == 0') ## no cuts should be applied on the true gen flavour for factorisation study ## don't cut on charge
    if MC_without_pu:
        df = df.Define('weight', "1.0")    
    else:
        df = df.Define('weight', "PileUpWeightProvider::GetDefault().GetWeight(npu) * 1.0")
else:
    df = df.Define('weight', "1.")

print("finished defining weight")
skimmed_branches = [
        'tau_pt', 'tau_eta', 'tau_phi', 'tau_mass', 'tau_charge', 'tau_decayMode', 'best_tau_idDeepTau2017v2p1VSjet', 'weight', 'best_tau_idDeepTau2017v2p1VSmu',
        'second_tau_pt', 'second_tau_eta', 'second_tau_phi', 'second_tau_mass', 'second_tau_charge', 'second_tau_decayMode','second_tau_idDeepTau2017v2p1VSjet', 'second_tau_idDeepTau2017v2p1VSmu',
        'best_tau_pt', 'best_tau_eta', 'best_tau_phi', 'best_tau_mass', 'best_tau_charge', 'best_tau_decayMode',  
        'best_tau_rawIso', 'second_tau_rawIso',
        'muon_pt', 'muon_mt', 'muon_iso', 'muon_phi', 'muon_eta'
]
if args.era >= 2022:
    skimmed_branches.append('best_tau_idDeepTau2018v2p5VSjet')
    skimmed_branches.append('best_tau_idDeepTau2018v2p5VSmu')
    skimmed_branches.append('second_tau_idDeepTau2018v2p5VSjet')
    skimmed_branches.append('second_tau_idDeepTau2018v2p5VSmu')
triggers = {
    2018: {
        "mutau_trigger" : "HLT_IsoMu20_eta2p1_LooseChargedIsoPFTauHPS27_eta2p1_CrossL1",
        "etau_trigger" : "HLT_IsoMu20_eta2p1_LooseChargedIsoPFTauHPS27_eta2p1_CrossL1",
        "ditau_trigger" : "HLT_IsoMu24_eta2p1_MediumChargedIsoPFTauHPS35_Trk1_eta2p1_Reg_CrossL1"    ,
        "ditau_trigger_monitor": "HLT_IsoMu24_eta2p1_MediumChargedIsoPFTauHPS35_Trk1_eta2p1_Reg_CrossL1",
    },
    2017 : {
        "mutau_trigger" : "HLT_IsoMu20_eta2p1_LooseChargedIsoPFTau27_eta2p1_CrossL1",
        "etau_trigger" : "HLT_IsoMu20_eta2p1_LooseChargedIsoPFTau27_eta2p1_CrossL1",
        "ditau_trigger" : "HLT_IsoMu24_eta2p1_MediumChargedIsoPFTau35_Trk1_TightID_eta2p1_Reg_CrossL1"    ,
        "ditau_trigger_monitor": "HLT_IsoMu24_eta2p1_MediumChargedIsoPFTau35_Trk1_TightID_eta2p1_Reg_CrossL1",
    },
    2022: {
        "mutau_trigger": "HLT_IsoMu24_eta2p1_MediumDeepTauPFTauHPS20_eta2p1_SingleL1",
        "etau_trigger": "HLT_IsoMu20_eta2p1_LooseDeepTauPFTauHPS27_eta2p1_CrossL1",
        "ditau_trigger_monitor": "HLT_IsoMu24_eta2p1_MediumDeepTauPFTauHPS35_L2NN_eta2p1_CrossL1",
        "ditau_trigger": "HLT_DoubleMediumDeepTauPFTauHPS35_L2NN_eta2p1",
    }
    
}
df = df.Define("pass_mutau_tag", f"PassMuTauTrig_lowpT_byNanoVer(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, best_tau_pt, best_tau_eta, best_tau_phi, {args.nanoVer}) && {triggers[args.era]['mutau_trigger']} == 1")
df = df.Define("pass_mutau_probe", f"PassMuTauTrig_lowpT_byNanoVer(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, second_tau_pt, second_tau_eta, second_tau_phi, {args.nanoVer}) && {triggers[args.era]['mutau_trigger']} == 1")
df = df.Define("pass_mutau_muon", f"PassMuTauTrig_lowpT_byNanoVer_muon(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, muon_pt, muon_eta, muon_phi, {args.nanoVer}) ")


df = df.Define("pass_etau", f"PassElTauTrig(nTrigObj, TrigObj_l1pt, TrigObj_l1iso, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, tau_pt, tau_eta, tau_phi) && {triggers[args.era]['etau_trigger']} == 1")
if args.era >= 2022:
    df = df.Define("pass_ditau_tag", f"PassDiTauTrig(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, best_tau_pt, best_tau_eta, best_tau_phi) && {triggers[args.era]['ditau_trigger']} == 1")
    df = df.Define("pass_ditau_probe", f"PassDiTauTrig(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, second_tau_pt, second_tau_eta, second_tau_phi) && {triggers[args.era]['ditau_trigger']} == 1")
df = df.Define("pass_ditau_tag_monitor", f"PassDiTauTrig(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, best_tau_pt, best_tau_eta, best_tau_phi) && {triggers[args.era]['ditau_trigger_monitor']} == 1")
df = df.Define("pass_ditau_probe_monitor", f"PassDiTauTrig(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, second_tau_pt, second_tau_eta, second_tau_phi) && {triggers[args.era]['ditau_trigger_monitor']} == 1")

df = df.Define("pass_mutau_second_tau", f"PassMuTauTrig_lowpT_byNanoVer(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, second_tau_pt, second_tau_eta, second_tau_phi,{args.nanoVer}) " ) 

df = df.Define("pass_mutau_second_tau_given", f"PassMuTauTrig_lowpT_byNanoVer(nTrigObj, TrigObj_id, TrigObj_filterBits, TrigObj_pt, TrigObj_eta, TrigObj_phi, second_tau_pt, second_tau_eta, second_tau_phi,{args.nanoVer}) && pass_mutau_tag > 0.5 " ) 

skimmed_branches.append("pass_mutau_tag")
skimmed_branches.append("pass_mutau_probe")
skimmed_branches.append("pass_mutau_muon")
skimmed_branches.append("pass_etau")
skimmed_branches.append("pass_ditau_tag_monitor")
skimmed_branches.append("pass_ditau_probe_monitor")
skimmed_branches.append("pass_mutau_second_tau")
skimmed_branches.append("pass_mutau_second_tau_given")
if args.era >= 2022:
    skimmed_branches.append("pass_ditau_tag")
    skimmed_branches.append("pass_ditau_probe")

df.Snapshot('Events', args.output, ListToStdVector(skimmed_branches))

