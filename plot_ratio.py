import argparse
import os
import sys
import math
import numpy as np
import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import scipy
import copy
from scipy import interpolate

from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import Matern, ConstantKernel

import ROOT
ROOT.gROOT.SetBatch(True)
ROOT.TH1.SetDefaultSumw2()

path_prefix = '' if 'TauTriggerTools' in os.getcwd() else 'TauTriggerTools/'
sys.path.insert(0, path_prefix + 'Common/python')
from RootObjects import Histogram, Graph

parser = argparse.ArgumentParser(description='Fit turn-on curves.')
parser.add_argument('--input', required=True, type=str, help="ROOT file with turn-on curves")
parser.add_argument('--output', required=True, type=str, help="output file prefix")
parser.add_argument('--channels', required=False, type=str, default='etau,mutau,ditau', help="channels to process")
parser.add_argument('--decay-modes', required=False, type=str, default='0,1,10,11,1011', help="decay modes to process")
parser.add_argument('--working-points', required=False, type=str,
                    default='VVVLoose,VVLoose,VLoose,Loose,Medium,Tight,VTight,VVTight',
                    help="working points to process")
args = parser.parse_args()

channels = args.channels.split(',')
decay_modes = args.decay_modes.split(',')
working_points = args.working_points.split(',')
ch_validity_thrs = { 'etau': 35, 'mutau': 32, 'ditau': 40 }
inputfile = args.input.split(',')

file = ROOT.TFile(inputfile[0], 'READ')
fileLegacy = ROOT.TFile(inputfile[1], 'READ')
output_file = ROOT.TFile('{}.root'.format(args.output), 'RECREATE', '', ROOT.RCompressionSetting.EDefaults.kUseSmallest)

for channel in channels:
    with PdfPages('{}_{}.pdf'.format(args.output, channel)) as pdf:
        for wp in working_points:
            for dm in decay_modes:
                # point
                #dm_label = '_dm{}'.format(dm) if dm != 'all' else ''
                dm_label = '_dm'+ dm if len(dm) > 0 else ''
                name_pattern = '{{}}_{}_{}{}_eff'.format(channel, wp, dm_label)
                print("name pattern : {}".format(name_pattern))
                print(name_pattern.format('data'))
                eff_data_root = file.Get(name_pattern.format('data'))
                eff_mc_root = file.Get(name_pattern.format('mc'))
                eff_data = Graph(root_graph=eff_data_root)
                eff_mc = Graph(root_graph=eff_mc_root)
                
                # fit
                dm_label_fit = '_dm'+ dm if len(dm) > 0 else ''
                name_pattern_fit = '{{}}_{}_{}{}_{}'.format(channel, wp, dm_label_fit, 'fitted')
                print("name pattern fit : {}".format(name_pattern_fit))
                
                # Legacy
                dm_label_L = '_dm'+ dm if len(dm) > 0 else ''
                # name_pattern_L = '{}_{}DeepTau{}_{}'.format(channel, wp.casefold(), dm_label_L, 'CoarseBinSF')
                name_pattern_L = '{{}}_{}_{}{}_{}'.format(channel, wp, dm_label_L, 'fitted')
                print("name_pattern_L : {}".format(name_pattern_L))
                #exit(0)
                
                SF_L = fileLegacy.Get(name_pattern_L.format('sf'))
                SF = []
                SF_ERR = []
                for _i in range(9801):
                    SF.append(SF_L.GetBinContent(_i))
                    SF_ERR.append(SF_L.GetBinError(_i))
                sf_L = np.asarray(SF)
                sf_L_sigma = np.asarray(SF_ERR)
                
                # pred_step_L = 1
                pred_step_L = 0.1
                # x_low_L, x_high_L = 20, 499
                x_low_L, x_high_L = 20, 1000
                x_pred_L = np.arange(x_low_L, x_high_L + pred_step_L / 2, pred_step_L)
                
                eff_data_fitted_th1 = file.Get(name_pattern_fit.format('data'))
                eff_mc_fitted_th1 = file.Get(name_pattern_fit.format('mc'))
                pred_step = 0.1
                x_low, x_high = 20, 1000
                x_pred = np.arange(x_low, x_high + pred_step / 2, pred_step)
                print(x_pred)
                eff_data_fitted_point = []
                eff_data_fitted_point_sigma_pred = []
                eff_mc_fitted_point = []
                eff_mc_fitted_point_sigma_pred = []
                for _i in range(len(x_pred)):
                    eff_data_fitted_point.append( eff_data_fitted_th1.GetBinContent(_i) )
                    eff_data_fitted_point_sigma_pred.append( eff_data_fitted_th1.GetBinError(_i) )
                    eff_mc_fitted_point.append( eff_mc_fitted_th1.GetBinContent(_i) )
                    eff_mc_fitted_point_sigma_pred.append( eff_mc_fitted_th1.GetBinError(_i) )
                eff_data_fitted = np.asarray(eff_data_fitted_point)
                eff_data_fitted_sigma_pred = np.asarray(eff_data_fitted_point_sigma_pred)
                eff_mc_fitted = np.asarray(eff_mc_fitted_point)
                eff_mc_fitted_sigma_pred = np.asarray(eff_mc_fitted_point_sigma_pred)
                sf = eff_data_fitted / eff_mc_fitted
                sf_sigma = np.sqrt((eff_data_fitted_sigma_pred / eff_mc_fitted) ** 2 \
                         + (eff_data_fitted / (eff_mc_fitted ** 2) * eff_mc_fitted_sigma_pred ) ** 2 )

                fig, (ax, ax_ratio) = plt.subplots(2, 1, figsize=(7, 7), sharex=True,
                                                           gridspec_kw = {'height_ratios':[2, 1]})
                mc_color = 'g'
                data_color = 'k'
                trans = 0.3

                plt_data = ax.errorbar(eff_data.x, eff_data.y, xerr=(eff_data.x_error_low, eff_data.x_error_high),
                                       yerr=(eff_data.y_error_low, eff_data.y_error_high), fmt=data_color+'.',
                                       markersize=5)
                plt_mc = ax.errorbar(eff_mc.x, eff_mc.y, xerr=(abs(eff_mc.x_error_low), abs(eff_mc.x_error_high)),
                                     yerr=(eff_mc.y_error_low, eff_mc.y_error_high), fmt=mc_color+'.', markersize=5)

                plt_data_fitted = ax.plot(x_pred, eff_data_fitted, data_color+'--')
                ax.fill(np.concatenate([x_pred, x_pred[::-1]]),
                        np.concatenate([eff_data_fitted - eff_data_fitted_sigma_pred,
                                       (eff_data_fitted + eff_data_fitted_sigma_pred)[::-1]]),
                        alpha=trans, fc=data_color, ec='None')

                plt_mc_fitted = ax.plot(x_pred, eff_mc_fitted, mc_color+'--')
                ax.fill(np.concatenate([x_pred, x_pred[::-1]]),
                        np.concatenate([eff_mc_fitted - eff_mc_fitted_sigma_pred,
                                       (eff_mc_fitted + eff_mc_fitted_sigma_pred)[::-1]]),
                        alpha=trans, fc=mc_color, ec='None')

                UL = ax_ratio.plot(x_pred, sf, 'b--', label='Nano2p5') # 2p5, NanoAOD
                ax_ratio.fill(np.concatenate([x_pred, x_pred[::-1]]),
                              np.concatenate([sf - sf_sigma, (sf + sf_sigma)[::-1]]),
                              alpha=trans, fc='b', ec='None')
                
                Legacy = ax_ratio.plot(x_pred_L, sf_L, 'y--', label='Nano2p1') # 2p1, MiniAOD
                ax_ratio.fill(np.concatenate([x_pred_L, x_pred_L[::-1]]),
                              np.concatenate([sf_L - sf_L_sigma, (sf_L + sf_L_sigma)[::-1]]),
                              alpha=trans, fc='y', ec='None')
                
                title = "Turn-ons for {} trigger with {} DeepTau VSjet".format(channel, wp)
                if dm != 'all':
                    title += " for DM={}".format(dm)
                else:
                    title += " for all DMs"
                ax.set_title(title, fontsize=16)
                ax.set_ylabel("Efficiency", fontsize=12)
                ax.set_ylim([ 0., 1.1 ])
                ax.set_xlim([ 20, min(200, plt.xlim()[1]) ])

                ax_ratio.set_xlabel("$p_T$ (GeV)", fontsize=12)
                ax_ratio.set_ylabel("Data/MC SF", fontsize=12)
                # ax_ratio.set_ylabel("Data/Embedding SF", fontsize=12)
                ax_ratio.set_ylim([0.5, 1.49])

                validity_plt = ax.plot( [ ch_validity_thrs[channel] ] * 2, ax.get_ylim(), 'r--' )
                ax_ratio.plot( [ ch_validity_thrs[channel] ] * 2, ax_ratio.get_ylim(), 'r--' )

                ax.legend([ plt_data, plt_mc, plt_data_fitted[0], plt_mc_fitted[0], validity_plt[0] ],
                         [ "Data", "MC", "Data fitted", "MC fitted", "Validity range"], fontsize=12, loc='lower right')
                        #   [ "Data", "Embedding", "Data fitted", "Embedding fitted", "Validity range"], fontsize=12, loc='lower right')

                # ax_ratio.legend([UL, Legacy], ["Nano TauPOGUL", "Mini ULegacy"], fontsize=12, loc='lower right')
                ax_ratio.legend()

                plt.subplots_adjust(hspace=0)
                pdf.savefig(bbox_inches='tight')
                plt.close()
                
                out_name_pattern = '{{}}_{}_{}{}_{{}}'.format(channel, wp, dm_label)
                output_file.WriteTObject(eff_data_root, out_name_pattern.format('data', 'eff'), 'Overwrite')
                output_file.WriteTObject(eff_mc_root, out_name_pattern.format('mc', 'eff'), 'Overwrite')
                # output_file.WriteTObject(eff_mc_root, out_name_pattern.format('embedding', 'eff'), 'Overwrite')
                # eff_data_fitted_hist = Histogram.CreateTH1(eff_data_fitted.y_pred, [x_low, x_high],
                #                                            eff_data_fitted.sigma_pred, fixed_step=True)
                # eff_mc_fitted_hist = Histogram.CreateTH1(eff_mc_fitted.y_pred, [x_low, x_high],
                #                                          eff_mc_fitted.sigma_pred, fixed_step=True)
                # sf_fitted_hist = eff_data_fitted_hist.Clone()
                # sf_fitted_hist.Divide(eff_mc_fitted_hist)
                # output_file.WriteTObject(eff_data_fitted_hist, out_name_pattern.format('data', 'fitted'), 'Overwrite')
#                output_file.WriteTObject(eff_mc_fitted_hist, out_name_pattern.format('mc', 'fitted'), 'Overwrite')
                # output_file.WriteTObject(eff_mc_fitted_hist, out_name_pattern.format('embedding', 'fitted'), 'Overwrite')
                # output_file.WriteTObject(sf_fitted_hist, out_name_pattern.format('sf', 'fitted'), 'Overwrite')
                #exit(0)

output_file.Close()
print('All done.')