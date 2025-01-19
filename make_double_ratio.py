# import uproot
import numpy as np
import ROOT as R

# Read the ROOT files
file1 = R.TFile.Open("Plot/2018latestgiventau_2.root")
file2 = R.TFile.Open("Plot/2018latesttau_2.root")
output_file = R.TFile("output.root", "RECREATE")
# Extract the histograms
for DM in ["_", "_dm0_", "_dm1_", "_dm1011_"]:
    for WP in ["VVVLoose", "VVLoose", "VLoose", "Loose", "Medium","Tight","VTight","VVTight", ]:
        hist1_mc_num = file1.Get(f"mc_mutau_{WP}{DM}plot_passed") #  file1[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist1_data_num = file1.Get(f"data_mutau_{WP}_{DM}lot_passed") #  file1[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()
        print(hist1_data_num, f"mc_mutau_{WP}{DM}plot_passed")
        hist1_mc_den = file1.Get(f"mc_mutau_{WP}{DM}plot_total") #  file1[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist1_data_den = file1.Get(f"data_mutau_{WP}{DM}plot_total") #  file1[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()

        hist1_mc_num.Divide(hist1_mc_den) #  file1[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist1_data_num.Divide(hist1_data_den) #  file1[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()


        hist2_mc_num = file2.Get(f"mc_mutau_{WP}{DM}plot_passed") #  file2[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist2_data_num = file2.Get(f"data_mutau_{WP}_{DM}lot_passed") #  file2[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()

        hist2_mc_den = file2.Get(f"mc_mutau_{WP}{DM}plot_total") #  file2[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist2_data_den = file2.Get(f"data_mutau_{WP}{DM}plot_total") #  file2[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()

        hist2_mc_num.Divide(hist2_mc_den) #  file1[f"mc_mutau_Medi{DM}m_plot_eff"].to_hist()
        hist2_data_num.Divide(hist2_data_den) #  file1[f"data_mutau_Medi{DM}m_plot_eff"].to_hist()

        # Compute the ratios
        hist1_data_num.Divide(hist1_mc_num)  # hist1_data / hist1_mc
        hist2_data_num.Divide(hist2_mc_num)  # hist2_data / hist2_mc

        # Compute the ratio of the ratios
        hist1_data_num.Divide(hist2_data_num) # ratio1 / ratio2

        print("finished, ", hist1_data_num)
        # Save to a new ROOT file using CERN ROOT
        output_file.cd()
        hist1_data_num.Write(f"{WP}_{DM}lot_doubleratio")
        output_file.Close()
