cx <- 1.7
par(cex=cx, cex.axis=1.2, cex.lab=cx, mar = c(5,6,4,1.5))

genTime <- 10

prev <- read.csv(input_files[[1]])
baseYear <- prev$year[[1]]

expPlot <- function(lastYear=NULL){
	with(prev, {
		if (is.null(lastYear)) lastYear <- max(year)
		plot(year, prev/100
			, xlab = "Year"
			, ylab = "HIV prevalence", bty = 'n', pch = 19
			, yaxt='n'
			, xlim = c(min(year), lastYear)
		)
	})
	axis(2, seq(0,.3,b=.1), las = 2)
	with(simList[[4]], lines(baseYear+genTime*time, y, , lwd = 3))
}

expPlot()
expPlot(lastYear=1998)
