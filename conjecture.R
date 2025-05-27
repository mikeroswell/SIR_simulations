library(shellpipes)
rpcall("conjecture.Rout conjecture.R forward.sim.rda deSolve.R")
sourceFiles()
loadEnvironments()
R0 <- c(1.2, 1.5, 2, 4, 8, 20)
steps <- c(3e2, 1e3, 3e3, 1e4)
cars <- 1

sapply(steps, function(s){
  print(as.data.frame(
  t(sapply(R0, function(x) outbreakStats(R0=x, y0 = 1e-9, steps=s, cars = cars))
    )
  ))
  }
  )

conjectureDat <- as.data.frame(
 t(sapply(R0, function(x) outbreakStats(R0=x,  y0 = 1e-9, steps=1e4, cars = cars))))


saveEnvironment()
