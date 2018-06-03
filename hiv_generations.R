## This is a terrible hybrid done under time pressure at MMED

cx <- 1.7
par(cex=cx, cex.axis=1.2, cex.lab=cx, mar = c(5,6,4,1.5))

genTime <- 10

prev <- read.csv(input_files[[1]])
baseYear <- prev$year[[1]]
finYear <- 1997

## Attach a simulation and get time and prevalence projections
modprev <- with(simList[[length(simList)-1]], y)
timescale <- with(simList[[length(simList)-1]], time)
time <- baseYear+genTime*timescale

## A function for arrow steps
arrowStep <- function(t, i, astart, adist, asteps, ss){
	pts <- (astart + adist*(0:asteps)/asteps)*ss
	x <- t[pts]
	y <- i[pts]
	## points(c(min(x), max(x)), c(min(y), max(y))) 
	arrows(x[-length(x)], y[-length(y)] 
		, x[-1], y[-length(y)] 
	)
	arrows(x[-1], y[-length(y)] 
		, x[-1], y[-1]
		, length=0
	)
}

## Plot the loaded data
## Using a manual y-axis for some reason
with(prev, plot(year, prev/100
	## , log = "y"
	, xlab = "Year", ylab = "HIV prevalence"
	, bty = 'n', pch = 19
	, yaxt='n'
	, xlim = c(baseYear, finYear)
	, ylim = c(0, 0.2)
))
axis(2, seq(0,.3,b=.1), las = 2)

## Add simulation lines
lines(time, modprev, lwd = 3)

## Add arrowSteps
arrowStep(time, modprev, 1, adist=30, asteps=1, ss=1)

## FRY!!
with(prev, plot(year, prev/100
	## , log = "y"
	, xlab = "Year", ylab = "HIV prevalence"
	, bty = 'n', pch = 19
	, yaxt='n'
	, xlim = c(baseYear, finYear)
	, ylim = c(0, 0.2)
))
axis(2, seq(0,.3,b=.1), las = 2)

## Add simulation lines
lines(time, modprev, lwd = 3)

## Add arrowSteps
arrowStep(time, modprev, 1, adist=30, asteps=3, ss=1)

data.frame(time, modprev)
