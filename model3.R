library (deSolve)

ts <- sim(I0=1e-5
	, bet0=.78
	, D=10, L=60, N0=1
	, a=1, kap=4
	, cars=4
)

summary(ts)

