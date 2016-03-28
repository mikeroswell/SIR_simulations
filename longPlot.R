par(cex=1.6)
genTime <- 10/365

sim <- within(sim,{
	t <- genTime*time
	inc <- incGen/genTime
})

with(sim, {
	plot(t, y, type="l",
		xlab = "Time (years)",
		ylab = "Proportion infected",  bty = 'n',
		xlim = c(0, 10)
	)
})

with(sim, {
	plot(t, y, type="l",
		xlab = "Time (years)",
		ylab = "Proportion of population",  bty = 'n',
		xlim = c(0, 10)
	)
	lines(t, x, col="blue")
})
