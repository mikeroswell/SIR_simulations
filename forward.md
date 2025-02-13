Do a simulation

Look at the simulation and calculate cohort statistics

Average over cohorts and apply EVE.

I'm doing all of these things with an ODE solver and approxfun for linear extrapolation (this is a cute idea, not clear about efficiency or robustness, but certainly feels better than just summing over the discrete steps).

Repeat for different values of R0
* ideally we should have some sort of approximation that allows us to cleverly vary the time window as we vary R0

----------------------------------------------------------------------

There is probably a way to do this with more mathematical slickness and less going back over the same ground …
