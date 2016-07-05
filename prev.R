library(ggplot2)
theme_set(theme_bw(base_size=20))

dat <- read.csv(input_files[[1]])

prevPlot <- (
	ggplot(dat, aes(x=Year, y=Prevalence))
	+ geom_point()
)

print(prevPlot)
