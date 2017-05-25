
# 6107
# 6697

del <- function(time, vars, parms){
	Ivec <- vars[grep("^I", names(vars))]
	Itot <- sum(Ivec)
	vp <- c(as.list(vars), parms)
	N <- with(vp, S+Itot)
	P <- with(vp, Itot/N)
	M <- with(vp, Ivec[length(Ivec)]/D)
	trans <- with(vp, 
		bet0
		*S*Itot/N
		*N^a
		*(1-P)^kap
		* exp(-M*q)
	)
	
	return(with(vp, list(c(
		Sdot = N0/L - trans - S/L
		, Idot <- c(trans, cars*Ivec[-length(Ivec)]/D) - cars*Ivec/D - Ivec/L
		, cumdot = trans
	))))
}

sim <- function(S0=NULL, I0=0.001
	, bet0=.18
	, a=0, kap=0
	, D=10, L=60, N0=1
	, startTime=1976, finTime=2020, timeStep=0.5
	, cars=1, q=0
){
	if(is.null(S0)){S0 <- 1-I0}
	sim <- as.data.frame(ode(
		y=c(S=S0, I=rep(I0/cars, cars), cum=0),
		func=del,
		times=seq(from=startTime, to=finTime, by=timeStep),
		parms=list(bet0=bet0, a=a, kap=kap, D=D, L=L, N0=N0, cars=cars, q=q)
	))

	return(within(sim, {
		inc <- c(NA, cum[-1] - cum[-nrow(sim)])
		incRate <- inc/timeStep
		Itot <- rowSums(sim[grep("^I", names(sim))])
		N <- S+Itot
		prev <- Itot/N
	}))
}

library (deSolve)

year <- 1

ts <- sim(I0=1e-6
	, bet0=1.0/year
	, D=10*year, L=60*year, N0=1
	, a=1, kap=5
	, cars=4, q=100
)

summary(ts)

# This file was generated automatically by wrapR.pl
# You probably don't want to edit it


input_files <- c("zim.csv")
rtargetname <- "zim.prev"
pdfname <- ".zim.prev.Rout.pdf"
csvname <- "zim.prev.Rout.csv"
rdsname <- "zim.prev.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file zim.prev.wrapR.r
source('prev.R', echo=TRUE)
# Wrapped output file zim.prev.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script zim.prev.wrapR.r (or something it called) did not close properly
save.image(file=".zim.prev.RData")

par(cex=1.6)
with(ts, plot(time, prev
	, type="l"
	, xlab="Year", ylab="Prevalence"
))
with(dat, points(Year, Prevalence))

with(dat, plot(Year, Prevalence))
with(ts, lines(time, prev))

with(ts, plot(time, N), type="l")

