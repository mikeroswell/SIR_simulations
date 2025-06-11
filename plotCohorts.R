library(shellpipes)
rpcall("plotCohorts.Rout plotCohorts.R forward.sim.rda deSolve.R")
loadEnvironments()
sourceFiles()
startGraphics(height = 4, width = 7)
library(ggplot2)
library(dplyr)
library(purrr)
library(patchwork)
RO <- c(1.2, 1.5, 2, 4, 8)

cohorts <- map_dfr(RO, function(R0){
  return(data.frame(sapply(cohortStats(R0, steps = 1e4, y0 = 1e-9, cars = 1), unlist), R0 = R0))
}
)

straightSim <- map_dfr(RO, function(R0){
  return(data.frame(simWrap(R0, steps = 1e4, y0 = 1e-9, cars = 1, tmult = 6)["sdat"], R0 = R0))
}
)

rc <- cohorts |> ggplot(aes(cohort, Rc, color = as.factor(R0))) +
  geom_hline(yintercept = 1) +
  geom_line(linewidth = 1, alpha = 0.8) +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  # ylim(c(0, 8)) +
  # scale_y_log10() +
  guides(color = "none")

# vc <- cohorts |>
#   ggplot(aes(cohort, varRc, color = as.factor(R0))) +
#   geom_line(linewidth = 1) +
#   theme_classic() +
#   scale_color_viridis_d(name = "R_0") +
#   ylim(c(0, 8)) +
#   theme(legend.position = "none"
#         # , legend.position.inside = c(0.75, 0.4)
#         )

ssc <- cohorts |>
  ggplot(aes(cohort, RcSS, color = as.factor(R0))) +
  geom_line(linewidth = 1, alpha = 0.8) +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.75, 0.4))



kc <- cohorts |>
  mutate(kappa_c = varRc/Rc^2) |>
  ggplot(aes(cohort, kappa_c, color = as.factor(R0))) +
  geom_line(linewidth = 1, alpha = 0.8) +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.75, 0.4))


epiPlot <- straightSim |>
  ggplot(aes(sdat.time, sdat.inc, color = as.factor(R0))) +
  # geom_line(color = "black")+
  # geom_line(aes(y = sdat.x), color = "black") +
  # geom_line(aes(y = sdat.y), color = "black") +
  geom_line(linewidth = 0.7)+ #, color = "red")+
  #geom_line(aes(y = sdat.cum), linewidth = 0.7, color = "darkorange") +
  # geom_line(aes(y = sdat.y), linewidth = 0.7, color = "darkred") +
  # facet_wrap(~R0, scales = "free_x") +
  scale_color_viridis_d()+
  labs(x = "time", y = "incidence", color = "R0") +
  xlim(c(0,150))+
  theme_classic()


rc + scale_y_continuous(limits = c(0,9), breaks = seq(0,8,2)) + kc + xlim(c(0, 150)) + epiPlot

saveEnvironment()
