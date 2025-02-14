library(shellpipes)
library(rlang)

sourceFiles()
loadEnvironments()

## This robust solver was built without gamma (equivalent to gamma=1), which seems ok if we can remember that
R0 <- 4
rho <- 0
timeStep = 0.1

## Make an environment so that I can pass things to mderivs (which is called by deSolve, so I don't know how to pass the normal way).
## TODO: See if there is a deSolve solution to pass extra stuff
mfuns <- env()

## m for moment; these two functions integrate across the infectors from a given cohort
mderivs <- function(time, vars, parms){
	Ri <- mfuns$sfun(time)
	dens <- with(parms, exp(-(time-T0)))
	return(with(c(parms, vars), list(c(
		Rcdot = Ri
		, ddot = dens
		, Rctotdot = Rc*dens
		, RcSSdot = Rc*Rc*dens
	))))
}

cMoments <- function(times, sfun, T0){
	mfuns$sfun <- sfun
	mom <- as.data.frame(ode(
		y=c(Rc=0, cum=0, Rctot=0, RcSS=0)
		, func=mderivs
		, times=times
		, parms=list(T0=T0)
	))
	return(mom)
}

cCalc <- function(sdat, cohort, sfun, bet, tol=1e-4){
	with(sdat, {
		sTime <- time[time>=cohort]
		mom <- cMoments(sTime, sfun, T0=cohort)
		## print(cohort)
		## print(mom[nrow(mom), ])
		with(mom[nrow(mom), ], {
			stopifnot(abs(cum-1)<tol)
			Rctot=Rctot/cum
			RcSS=RcSS/cum
			return(list(
				cohort=cohort, Rc=bet*Rctot, varRc=bet^2*(RcSS-Rctot^2)
			))
		})
	})
}

cohortStats <- function(R0, sdat, maxCohort){
	sfun <- approxfun(sdat$time, sdat$x, rule=2)
	cohorts <- with(sdat, time[time<=maxCohort])
	return(as.data.frame(t(
		sapply(cohorts, function(c) cCalc(sdat, sfun, cohort=c, bet=R0))
	)))
}

oderivs <- function(time, vars, parms){
	inc <- mfuns$ifun(time)
	Rc <- mfuns$rcfun(time)
	varRc <- mfuns$varrcfun(time)

	return(with(c(parms, vars), list(c(
		cumdot = inc
		, mudot = inc*Rc
		, SSdot = inc*Rc*Rc
		, Vdot = inc*varRc
	))))
}

outbreakStats <- function(R0, rho=0, timeStep=0.1, maxCohort=40, buffer=25){
	sdat <- sim(R0=R0, rho=rho, timeStep=timeStep
		, finTime=maxCohort+buffer
	)
	mfuns$ifun <- approxfun(sdat$time, sdat$x*sdat$y, rule=2)
	cStats <- cohortStats(R0, sdat, maxCohort)
	mfuns$rcfun <- approxfun(cStats$cohort, cStats$Rc, rule=2)
	mfuns$varrcfun <- approxfun(cStats$cohort, cStats$varRc, rule=2)

	mom <- as.data.frame(ode(
		y=c(cum=0, mu=0, SS=0, V=0)
		, func=oderivs
		, times=sdat$time
		, parms=list()
	))
	
	with(mom[nrow(mom), ], {
		mu <- mu/cum
		SS <- SS/cum
		within <- (V/cum)/mu^2
		between <- (SS-mu^2)/mu^2
		total <- within+between
		return(c(within=within, between=between, total=total))
	})
}

outbreakStats(10)
