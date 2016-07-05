library (deSolve)

ts <- sim(I0=0.001
	, bet0=.18
	, D=10, L=60, N0=1
)

summary(ts)

