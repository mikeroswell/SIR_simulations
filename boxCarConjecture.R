library(shellpipes)
rpcall("boxCarConjecture.Rout boxCarConjecture.R forward.sim.rda deSolve.R")

sourceFiles()
loadEnvironments()
R0 <- c(1.2, 1.5, 2, 4, 8, 20)
steps <- c(1e3)


out <- as.data.frame(t(sapply(
  R0, function(x) outbreakStats(R0=x, y0 = 1e-9, steps=steps, cars = 2))
  ))

print(out)
saveEnvironment()