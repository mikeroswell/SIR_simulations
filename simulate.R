library(shellpipes)

sir <- function(time, vars, parms){
	x <- with(as.list(vars), exp(lx))
	y <- with(as.list(vars), exp(ly))

	return(with(parms, list(c(
		lxdot = rho*(1-x)/x - R0*y,
		lydot = R0*x-1,
		cumdot = R0*x*y
	))))
}

boxcar <- function(time, vars, parms){
  with(as.list(c(vars, parms)), {
    x <- exp(lx)
    # make ys
    yvec <- exp(unlist(mget(paste0("ly", 1:cars))))
    y <- sum(yvec)
    lydots <- numeric(cars)
    lydots[[1]] <- R0*x*y/yvec[[1]] - cars
    lxdot <- rho*(1-x)/x - R0*y
    cumdot <- R0*x*y
    if (cars > 1) {
      lydots[2:cars] <- cars * (yvec[1:(cars - 1)] / yvec[2:cars] - 1)
    }
    out <- c(lxdot, lydots, cumdot)
    names(out) <- c("lxdot", paste0("ly", 1:cars, "dot"), "cumdot")
    return(list(out))
    }
  )
}

sim <- function(x0=NULL, y0=0.001, R0=5, rho=0.01, cars = 1, finTime=20, timeStep=0.1, dfun=boxcar){
	if(is.null(x0)){x0 <- 1-y0}
  # previous version: had problems with 0
#   logy <- rep(-Inf, cars)
#   logy[1] <- log(y0)
  # try again with tiny values?
  init_ly <- log(c(y0, rep(1e-12, cars - 1)))
  names(init_ly) <- paste0("ly", 1:cars)

  y_init <- c(lx = log(x0), init_ly, cum = 0)
	sim <- as.data.frame(ode(
		#y=c(lx=log(x0), setNames(logy, paste0("ly", 1:cars)), cum = 0),
		y = y_init
	  , func=dfun
		, times=seq(from=0, to=finTime, by=timeStep)
		, parms=list(R0=R0, rho=rho, cars = cars)
	))

	return(within(sim, {

		x <- exp(lx)
		yvec <- sapply(1:cars, function(i) exp(sim[[paste0("ly", i)]]))
		y <- rowSums(yvec)
		z <- 1-x-y
		inc <- c(NA, cum[-1] - cum[-nrow(sim)])
		incGen <- inc/timeStep
	}))
}
saveEnvironment()
