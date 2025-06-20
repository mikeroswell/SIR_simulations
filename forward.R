library(shellpipes)
rpcall("forward.sim.Rout forward.R simulate.rda finalSize.rda deSolve.R")
library(rlang)

sourceFiles()
loadEnvironments()

## This robust solver was built without gamma (equivalent to gamma=1), which seems ok if we can remember that
R0 <- 4
rho <- 0 # values > 1 give reinfection, at 0 SIRS <-> SIR

## Make an environment so that I can pass things to mderivs (which is called by deSolve, so I don't know how to pass the normal way).
## TODO: See if there is a deSolve solution to pass extra stuff

mfuns <- env()

## m for moment; these two functions integrate across the infectors from a given cohort
mderivs <- function(time, vars, parms){
	Ri <- parms$flist$sfun(time)
	dens <- with(parms$plist, cars^cars*(time - T0)^(cars-1)*exp(-cars*(time - T0))/factorial(cars-1))
	return(with(c(parms, vars), list(c(
		Rcdot = Ri
		, ddot = dens
		, Rctotdot = Rc*dens
		, RcSSdot = Rc*Rc*dens
	))))
}

cMoments <- function(time, sfun, T0, cars){
	mfuns$sfun <- sfun
	mom <- as.data.frame(ode(
		y=c(Rc=0, cum=0, Rctot=0, RcSS=0)
		, func=mderivs
		, times=time
		, parms=list(
			plist=list(T0=T0, cars=cars)
			, flist=list(sfun=sfun)
		)
	))
	return(mom)
}

cCalc <- function(sdat, cohort, sfun, bet, tol=1e-4, cars){
	with(sdat, {
		sTime <- time[time>=cohort]
		mom <- cMoments(sTime, sfun, T0=cohort, cars = cars)
		## print(cohort)
		## print(mom[nrow(mom), ])
		with(mom[nrow(mom), ], {
			stopifnot(abs(cum-1)<tol)
			Rctot=Rctot/cum
			RcSS=RcSS/cum
			return(list(
				cohort=cohort, Rc=bet*Rctot, varRc=bet^2*(RcSS-Rctot^2), RcSS = bet^2*RcSS
			))
		})
	})
}

cohortStats <- function(R0
                        , sdat = NULL
                        , maxCohort = NULL
                        , cohortProp=0.6
                        , dfun = boxcar
                        , cars
                        , ...){
  # figure out error/warning if incompatible combos provided
  if(is.null(sdat)){mySim <- simWrap(R0, dfun=dfun, cars=cars, ...)
    sdat <- mySim$sdat
    if(is.null(maxCohort)){
      maxCohort <- mySim$finTime * cohortProp
   }
  }
	sfun <- approxfun(sdat$time, sdat$x, rule=2)
	cohorts <- with(sdat, time[time<=maxCohort])
	return(as.data.frame(t(
		sapply(cohorts, function(c) cCalc(sdat=sdat, cohort=c, sfun=sfun, bet=R0, cars=cars))
	)))
}

oderivs <- function(time, vars, parms){
	inc <- parms$flist$ifun(time)
	Rc <- parms$flist$rcfun(time)
	varRc <- parms$flist$varrcfun(time)
	wss <- parms$flist$wssfun(time)


	return(with(c(parms, vars), list(c(
		cumdot = inc
		, mudot = inc*Rc
		, SSdot = inc*Rc*Rc
		, Vdot = inc*varRc
		, wdot = inc*wss
		, checkVdot = inc*(wss - Rc^2)

	))))
}

simWrap <- function(R0
                    , y0=1e-3
                    , rho=0
                    , tmult=6
                    , steps=300
                    , dfun  = boxcar
                    , cars
                    ){
  rate <- (R0-1)/R0

  # (R0-1) = r
  # (-log(y0)+log((R0-1)/R0))/(R0-1) = timePeak
  # Right part re-written (log(R0-1)-log(R0))/(R0-1)
  # still don't see it

  finTime <- tmult*(-log(y0))/rate
  sdat <- sim(R0=R0, rho=rho, timeStep=finTime/steps, y0=y0
              , finTime=finTime, dfun=dfun, cars=cars
  )
  return(list(sdat =sdat, finTime =finTime))
}

outbreakStats <- function(R0
                          , y0=1e-3
                          , rho=0
                          , tmult=6
                          , cohortProp=0.6
                          , steps=300
                          , dfun = boxcar
                          , cars = 1
                           ){
   	mySim<- simWrap(R0, y0, rho, tmult, steps, dfun, cars)
   	with(mySim, {
     	ifun <- approxfun(sdat$time, sdat$x*sdat$y, rule=2)
     	cStats <- cohortStats(R0=R0, sdat=sdat, maxCohort=cohortProp*finTime, cars=cars)
     	rcfun <- approxfun(cStats$cohort, cStats$Rc, rule=2)
     	varrcfun <- approxfun(cStats$cohort, cStats$varRc, rule=2)
      wssfun <- approxfun(cStats$cohort, cStats$RcSS, rule = 2)

     	mom <- as.data.frame(ode(
       		y=c(cum=0, mu=0, SS=0, V=0, w = 0, checkV = 0)
       		, func=oderivs
       		, times=sdat$time
       		, parms=list(flist = list(ifun=ifun, rcfun=rcfun, varrcfun=varrcfun, wssfun = wssfun ))
       	))

       	with(mom[nrow(mom), ], {
         		mu <- mu/cum
         		SS <- SS/cum
         		w <- w/cum
         		checkV <- (checkV/cum)/mu^2
         		within <- (V/cum)/mu^2
         		between <- (SS-mu^2)/mu^2
         		total = within + between
         		otherCheck = (w-mu^2)/mu^2
         		aSize <- finalSize(R0)
         		size <- R0*cum
         		return(c(R0=R0
         		         , size=size
         		         , sizeRat=size/aSize
         		         , cars = cars
         		         , mu=mu
         		         , mu2 = mu^2
         		         , within=within
         		         , checkWithin = checkV
         		         , between=between
         		         , withinSS = w
         		         , simplifiedTotalV = w - mu^2
         		         , totalV = total*mu^2
         		         , totalK=total
         		         , simplifiedTotalK = otherCheck
                      		))
         	})
   	})
   	}

saveEnvironment()

