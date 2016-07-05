
# 6107
# 6697

del <- function(time, vars, parms){
	q <- c(as.list(vars), parms)
	N <- with(q, S+I)
	bet <- with(q, b*N^k)
	trans <- with(q, bet*S*I/N)
	
	return(with(q, list(c(
		Sdot = N0/L - trans - S/L
		, Idot = trans - I/D - I/L
		, cumdot = trans
	))))
}

sim <- function(S0=NULL, I0=0.001
	, b=1.8, k=0
	, D=10, L=60, N0=1
	, startTime=1976, finTime=2020, timeStep=0.5
){
	if(is.null(S0)){S0 <- 1-I0}
	sim <- as.data.frame(ode(
		y=c(S=S0, I=I0, cum=0),
		func=del,
		times=seq(from=startTime, to=finTime, by=timeStep),
		parms=list(b=b, k=k, D=D, L=L, N0=N0)
	))

	return(within(sim, {
		inc <- c(NA, cum[-1] - cum[-nrow(sim)])
		incRate <- inc/timeStep
		prev <- I/(S+I)
	}))
}

