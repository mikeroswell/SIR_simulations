library (deSolve)

year <- 1

ts <- sim(I0=1e-6
	, bet0=1.0/year
	, D=10*year, L=60*year, N0=1
	, a=1, kap=5
	, cars=4, q=100
)

summary(ts)

