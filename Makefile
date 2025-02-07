# , a screens project directory
## makestuff/project.Makefile

current: target
-include target.mk

# include makestuff/perl.def

vim_session:
	bash -cl "vmt README.md notes.md"

######################################################################

Sources += README.md notes.md

Sources += $(wildcard *.R *.csv)

autopipeR = defined

burnout.plots.Rout.pdf: burnout.R
burnouts.plots.Rout.pdf: burnouts.R
newPlots.plots.Rout.pdf: newPlots.R

bigEpidemic.Rout: simulate.rda
fitSim.Rout: simulate.rda
longPlot.Rout: fitSim.Rout

hiv_sim.Rout: simulate.rda
hiv_plot.Rout: za.csv hiv_sim.rda
hiv_generations.Rout: za.csv hiv_sim.rda hiv_generations.R

##
hiv_long_sim.Rout: simulate.Rout
hiv_long_plot.Rout: za.csv hiv_long_sim.rda

## In haste for Utah (shows the match is really good at first)
## Not liking the overall attempt; keep just first pic.
za_gens.Rout: za.csv hiv_sim.rda za_gens.R

######################################################################

## model1.plots.Rout: Does not work
## model1.ws.Rout: Produces no plot

%.plots.Rout: %.sim.rda plots.R
	$(pipeR)
%.sim.Rout: simulate.Rout deSolve.R %.R
	$(pipeR)

## in extreme haste for 3SS2022
## recurrent.newplots.Rout: newplots.R
## Note that plots does work for burnouts
%.newplots.Rout: %.sim.rda newplots.R
	$(pipeR)

##################################################################

## Code to replicate Williams fitting experiments for NTU lecture

model1.ws.Rout:

williams.Rout: williams.R

%.ws.Rout: williams.Rout %.R
	$(pipeR)

test.ws.Rout: williams.Rout test.R

zim.prev.Rout: zim.csv prev.R
	$(pipeR)

live_fit.Rout: test.ws.Rout zim.prev.Rout compPlots.R
	$(pipeR)

## Weird file made for Juliet; how does Ignore override work?
## git rm pulliam.R ##
pulliam.Rfile: williams.R test.R zim.prev.wrapR.r compPlots.R
	$(cat)

######################################################################

## 3SS 

recurrent.plots.Rout: 

fs.Rout: fs.R

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
