library(shellpipes)

loadEnvironments()

for (r in 1:nrow(out)){
	print(rownames(out)[[r]])
	print(unlist(out[[r, 1]]))
}
