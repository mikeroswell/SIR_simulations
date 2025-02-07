# This is SIR_simulations

current: target
-include target.mk

# include makestuff/perl.def

vim_session:
	bash -cl "vmt README.md notes.md"

######################################################################

Sources += README.md notes.md

Sources += $(wildcard *.R *.csv)

autopipeR = defined

## simulate.R has functions for simulating a simple epidemic
## burnout.plots.Rout: burnout.R
## newPlots.plots.Rout: newPlots.R

%.sim.Rout: %.R simulate.rda deSolve.R
	$(pipeR)

######################################################################

## Dropped lots of stuff into content.mk because most of it doesn't work and it made organization hard.

Sources += content.mk

######################################################################

## Working now on simulating _backwards_; can we get things to match?
## Goal is to calculating infectious potential distributions for Roswell-Weitz heterogeneity

## revtest.rev.plots.Rout: revtest.R
## revtest.rev.sim.Rout: revtest.R revsim.R
%.rev.sim.Rout: %.R revsim.rda deSolve.R
	$(pipeR)

######################################################################

## See notes in content.mk, and also rule for newplots

%.plots.Rout: plots.R %.sim.rda
	$(pipeR)

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk
-include makestuff/pipeR.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk

##################################################################
