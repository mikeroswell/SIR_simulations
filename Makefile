# SIR_simulations
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: burnout.plots.Rout.pdf 

##################################################################


# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

##################################################################

## Content

burnout.plots.Rout.pdf: burnout.R

Sources += $(wildcard *.R *.csv)

bigEpidemic.Rout: simulate.Rout
fitSim.Rout: simulate.Rout
shortPlot.Rout longPlot.Rout: fitSim.Rout
hiv_plot.Rout: za.csv hiv_sim.Rout
hiv_sim.Rout: simulate.Rout

%.plots.Rout: %.sim.Rout plots.R
	$(run-R)
%.sim.Rout: simulate.Rout deSolve.R %.R
	$(run-R)

## Crib

.PRECIOUS: %.csv
%.csv:
	/bin/cp /home/dushoff/Dropbox/Downloads/WorkingWiki-export/SIR_model/$@ .

.PRECIOUS: %.R
%.R:
	/bin/cp /home/dushoff/Dropbox/Downloads/WorkingWiki-export/SIR_model/$@ .

######################################################################

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
