library(shellpipes)
rpcall("conjecture.Rout conjecture.R forward.sim.rda deSolve.R")
sourceFiles()
loadEnvironments()
R0 <- c(1.4, 2, 4)
steps <- c(3e2)
rho = 0.1
tmult = 6
cohortProp = 0.6

sapply(steps, function(s){
	print(as.data.frame(
		t(sapply(R0, function(x)
			outbreakStats(R0=x, y0 = 1e-9, steps=s
				, rho=rho, tmult=tmult, cohortProp=cohortProp
			)
		))
	))
})

saveEnvironment()
