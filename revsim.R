library(shellpipes)

sir <- function(time, vars, parms){
	x <- with(as.list(vars), exp(lx))
	y <- with(as.list(vars), exp(ly))
	Ri <- with(parms, R0*x)
	inc <- with(parms, Ri*y)
	Ri <- with(parms, R0)

	return(with(c(parms, as.list(vars)), list(c(
		lxdot = dir*(rho*(1-x)/x - R0*y)
		, lydot = dir*(R0*x-1)
		, Rcdot = Ri - Rc
		, Qcdot = Ri^2 - Qc
		, cumdot = inc
		, cumRdot = Rc*inc
		, cumQdot = Qc*inc
		, cumRRdot = Rc*Rc*inc
	))))
}

sim <- function(x0=NULL, y0=0.001
	, R0=5, rho=0.01, finTime=20, timeStep=0.1
	, forward=TRUE, dfun=sir
){
	if(is.null(x0)){x0 <- 1-y0}
	sim <- as.data.frame(ode(
		y=c(lx=log(x0), ly=log(y0), Rc=0, Qc=0, cum=0, cumR=0, cumQ=0, cumRR=0),
		func=dfun,
		times=seq(from=0, to=finTime, by=timeStep),
		parms=list(R0=R0, rho=rho, dir=ifelse(forward, 1, -1))
	))

	return(within(sim, {
		x <- exp(lx)
		y <- exp(ly)
		z <- 1-x-y
	}))
}
saveEnvironment()
