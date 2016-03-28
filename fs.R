par(cex=1.4)

balance <- function(Re, z){
	return(Re*z+log(1-z))
}

final_size <- function(Re){
	sapply(Re, function(curr){
		if(curr<=1) return(0)
		bot <- 1-1/curr
		top <- 1-exp(-curr)
		u <- uniroot(balance, c(bot, top), Re=curr)
		return(u$root)
	})
}

R0 <- seq(0.5, 5, by=0.1)
z <- final_size(R0)
ybar <- ifelse(R0<=1, 0, 1-1/R0)
print(z)
plot(
	R0, z
	, type="l", log="x", lwd = 1.5
	, xlab=expression(R[0])
	, ylab="Proportion affected"
	, main = 'epidemic size'
)

plot(
	R0, ybar
	, type="l", log="x", lwd = 1.5
	, xlab=expression(R[0])
	, ylab="Proportion infected"
	, main = 'endemic equilibrium'
)

