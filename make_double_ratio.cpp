#include <TFile.h>
#include <TH1.h>
#include <iostream>

void make_double_ratio() {
    // Read the ROOT files
    TFile* file1 = new TFile("Plot/2018_2p1giventau_2.root", "READ");
    TFile* file2 = new TFile("Plot/2018_2p1tau_2.root", "READ");
    TFile* output_file = new TFile("2018_Factorisation_corrections_DeepTau2017v2p1.root", "RECREATE");

    const char* DMs[] = {"_", "_dm0_", "_dm1_", "_dm1011_"};
    const char* WPs[] = {"VVVLoose", "VVLoose", "VLoose", "Loose", "Medium", "Tight", "VTight", "VVTight"};

    for (const auto& DM : DMs) {
        for (const auto& WP : WPs) {
            // Extract the histograms
            std::cout<< Form("mc_mutau_%s%splot_passed", WP, DM) << std::endl;
            std::cout<<  Form("data_mutau_%s%splot_total", WP, DM)<< std::endl;
            TH1* hist1_mc_num = (TH1*)file1->Get(Form("mc_mutau_%s%splot_passed", WP, DM));
            TH1* hist1_data_num = (TH1*)file1->Get(Form("data_mutau_%s%splot_passed", WP, DM));
            TH1* hist1_mc_den = (TH1*)file1->Get(Form("mc_mutau_%s%splot_total", WP, DM));
            TH1* hist1_data_den = (TH1*)file1->Get(Form("data_mutau_%s%splot_total", WP, DM));

            hist1_mc_num->Divide(hist1_mc_den);
            hist1_data_num->Divide(hist1_data_den);

            TH1* hist2_mc_num = (TH1*)file2->Get(Form("mc_mutau_%s%splot_passed", WP, DM));
            TH1* hist2_data_num = (TH1*)file2->Get(Form("data_mutau_%s%splot_passed", WP, DM));
            TH1* hist2_mc_den = (TH1*)file2->Get(Form("mc_mutau_%s%splot_total", WP, DM));
            TH1* hist2_data_den = (TH1*)file2->Get(Form("data_mutau_%s%splot_total", WP, DM));

            hist2_mc_num->Divide(hist2_mc_den);
            hist2_data_num->Divide(hist2_data_den);

            // Compute the ratios
            hist1_data_num->Divide(hist1_mc_num);
            hist2_data_num->Divide(hist2_mc_num);

            // Compute the ratio of the ratios
            hist1_data_num->Divide(hist2_data_num);

            TF1* fitFunc = new TF1("fitFunc", "pol0", 40, 200);
            hist1_data_num->Fit(fitFunc, "RQ"); // "R" option for the range and "Q" for quiet mode
            // Save to a new ROOT file using CERN ROOT
            output_file->cd();
            hist1_data_num->Write(Form("%s%sdoubleratio", WP, DM));
            fitFunc->Write(Form("%s%sfit", WP, DM));
            std::cout << "Finished: " << hist1_data_num->GetName() << std::endl;

        }
           

    }
    

    // Don't forget to close the output file after writing!


    // Save and close the output file after writing!
    output_file->Close();
}


int main() {
    make_double_ratio();
    return 0;
}
