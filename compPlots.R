par(cex=1.6)
with(ts, plot(time, prev
	, type="l"
	, xlab="Year", ylab="Prevalence"
))

with(dat, plot(Year, Prevalence))
with(ts, lines(time, prev))

