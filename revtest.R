library(shellpipes)

sourceFiles()
loadEnvironments()

R0 <- 12
rho <- 0

sdat <- sim(R0=R0, rho=rho)
## print(sdat[nrow(sdat), ])

rdat <- with(as.list(sdat[nrow(sdat), ]), 
	sim(R0=R0, rho=rho, x0=x, y0=y, forward=FALSE)
)
## print(rdat[nrow(rdat), ])

slist <- list(sdat, rdat)

with(as.list(rdat[nrow(rdat), ]), {
	mu <- cumR/cum
	Qwithin <- cumQ/cum
	Vwithin <- Qwithin - mu^2
	Qbetween <- cumRR/cum
	Vbetween <- Qbetween - mu^2
	print(c(mu=mu, Vwithin=Vwithin, Vbetween=Vbetween))
})

saveEnvironment()
