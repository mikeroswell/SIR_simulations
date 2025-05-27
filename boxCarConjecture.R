library(shellpipes)
rpcall("boxCarConjecture.Rout boxCarConjecture.R forward.sim.rda deSolve.R")

sourceFiles()
loadEnvironments()
R0 <- c(1.2, 1.5, 2, 4, 8, 20, 25)
steps <- c(1e4)
cars <- c(1:6)

out <- sapply(cars,function(bxs){
  as.data.frame(t(sapply(
  R0, function(x) outbreakStats(R0=x, y0 = 1e-9, steps=steps, cars = bxs))
  ))
})

print(out)
saveEnvironment()