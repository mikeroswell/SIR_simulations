library(shellpipes)

sourceFiles()
loadEnvironments()

sdat <- sim(R0=3, rho=0)
qdat <- sim(R0=3.1, rho=0)

rdat <- with(as.list(sdat[nrow(sdat), ]), 
	sim(R0=3, rho=0, x0=x, y0=y, forward=FALSE)
)

slist <- list(qdat, rdat)

saveEnvironment()
