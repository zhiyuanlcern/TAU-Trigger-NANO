import ROOT

# Open the ROOT file
file = ROOT.TFile.Open("test/nano_1_Skim.root")

# Get the TH1F object
hist = file.Get("producer_selection")

# Create a canvas on which to draw the histogram
canvas = ROOT.TCanvas("canvas", "Title", 800, 600)

# Draw the histogram
hist.Draw()

# Save the canvas as a .png file
canvas.SaveAs("cutflow.png")

# Close the ROOT file
file.Close()