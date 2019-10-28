# , a screens project directory
## makestuff/project.Makefile

current: target
-include target.mk

# include makestuff/perl.def

######################################################################


## This was built as a stripped-down, robust simulator while at Princeton (Wilton sojourn). I hijacked it for a couple of things and then moved on. It could still be a good engine, with scaling-related helper functions. I think.

## See also SIR_model on some wiki

burnout.plots.Rout.pdf: burnout.R

Sources += $(wildcard *.R *.csv)

bigEpidemic.Rout: simulate.Rout
fitSim.Rout: simulate.Rout
shortPlot.Rout longPlot.Rout: fitSim.Rout

hiv_sim.Rout: simulate.Rout
hiv_plot.Rout: za.csv hiv_sim.Rout
hiv_generations.Rout: za.csv hiv_sim.Rout hiv_generations.R

## In haste for Utah
## Not liking the overall attempt; keep just first pic.
za_gens.Rout: za.csv hiv_sim.Rout za_gens.R

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

## Weird file made for Juliet; how does Ignore override work?
## git rm pulliam.R ##
pulliam.Rfile: williams.R test.R zim.prev.wrapR.r compPlots.R
	$(cat)

######################################################################

## 3SS 

recurrent.plots.Rout: 

fs.Rout: fs.R

######################################################################

vim_session:
	bash -cl "vmt"

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
-include makestuff/wrapR.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk

##################################################################
