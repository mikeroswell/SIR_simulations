# SIR_simulations
### Hooks for the editor to set the default target

current: target
-include target.mk

##################################################################

# make files

Sources = Makefile .gitignore README.md sub.mk LICENSE.md
include sub.mk
# include $(ms)/perl.def

##################################################################

## This was built as a stripped-down, robust simulator while at Princeton. I hijacked it for a couple of things and then moved on. It could still be a good engine, with scaling-related helper functions. I think.

## See also SIR_model on some wiki

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

##################################################################

## Code to replicate Williams fitting experiments for NTU lecture

williams.Rout: williams.R

%.ws.Rout: williams.Rout %.R
	$(run-R)

test.ws.Rout: williams.Rout test.R

zim.prev.Rout: zim.csv prev.R
	$(run-R)

live_fit.Rout: test.ws.Rout zim.prev.Rout compPlots.R
	$(run-R)

pulliam.R: williams.R test.R zim.prev.wrapR.r compPlots.R
	$(cat)

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
