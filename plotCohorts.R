library(shellpipes)
rpcall("plotCohorts.Rout plotCohorts.R forward.sim.rda deSolve.R")
loadEnvironments()
sourceFiles()
startGraphics(height = 3.5, width = 7)
library(ggplot2)
library(dplyr)
library(purrr)
library(patchwork)
ggplot2::theme_set(theme_classic(base_family = "CMU Serif"))
RO <- c(1.2, 2, 8)
RO <- c(2, 4, 8)

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
  geom_line(linewidth = 1.5, alpha = 1, lineend = "round", linejoin = "round") +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  # geom_line(alpha = 0.5
  #           , linewidth = 0.5
  #           , data = straightSim |> mutate(Re = R0*sdat.x)
  #           , aes(y = Re, x = sdat.time)) +
  # # ylim(c(0, 8)) +
  # scale_y_log10() +
  guides(color = "none") +
  scale_y_continuous(limits = c(0,9), breaks = seq(0,8,2)) +
  xlim(c(0, 150)) +
  labs(x = "cohort infection time", y = "mean cohort cases per case")

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
  geom_line(linewidth = 1.3, alpha = 0.8, lineend = "round", linejoin = "round") +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.75, 0.4))



kc <- cohorts |>
  mutate(kappa_c = varRc/Rc^2) |>
  ggplot(aes(cohort, kappa_c, color = as.factor(R0))) +
  geom_line(linewidth = 1.3, alpha = 0.8, lineend = "round", linejoin = "round") +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.75, 0.4)) +
  labs(x = "cohort infection time", y = "CV^2 for cohort cases per case" )


epiPlot  <- straightSim |>
  ggplot(aes(sdat.time, sdat.inc, color = as.factor(R0))) +
  # geom_line(color = "black")+
  # geom_line(aes(y = sdat.x), color = "black") +
  # geom_line(aes(y = sdat.y), color = "black") +
  geom_line(linewidth = 1.3, lineend = "round", linejoin = "round")+ #, color = "red")+
  #geom_line(aes(y = sdat.cum), linewidth = 0.7, color = "darkorange") +
  # geom_line(aes(y = sdat.y), linewidth = 0.7, color = "darkred") +
  # facet_wrap(~R0, scales = "free_x") +
  scale_color_viridis_d()+
  labs(x = "time", y = "incidence", color = "R0") +
  xlim(c(0,150))+
  theme_classic() +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.7, 0.6))


RePlot <- straightSim |> mutate(Re = R0*sdat.x) |>
  ggplot(aes(sdat.time, Re, color = as.factor(R0))) +
  # geom_line(color = "black")+
  # geom_line(aes(y = sdat.x), color = "black") +
  # geom_line(aes(y = sdat.y), color = "black") +
  geom_line(linewidth = 1, linetype = "dashed")+ #, color = "red")+
  #geom_line(aes(y = sdat.cum), linewidth = 0.7, color = "darkorange") +
  # geom_line(aes(y = sdat.y), linewidth = 0.7, color = "darkred") +
  # facet_wrap(~R0, scales = "free_x") +
  scale_color_viridis_d()+
  labs(x = "time", y = "R_effective", color = "R0") +
  xlim(c(0,150)) +
  scale_y_continuous(limits = c(0,9), breaks = seq(0,8,2)) +
  theme_classic()


epiPlot + xlim(c(0,35)) + scale_color_manual(values = c(rgb(red = 0.8,  green = 0.8, blue= 0.8), rgb(red = 0.4,  green = 0.4, blue= 0.4), rgb(red =0,green = 0,  blue=0))) +
  rc + xlim(c(0,35)) + scale_color_manual(values = c(rgb(red = 0.8,  green = 0.8, blue= 0.8), rgb(red = 0.4,  green = 0.4, blue= 0.4), rgb(red =0,green = 0,  blue=0))) +
  kc + xlim(c(0,35)) + scale_color_manual(values = c(rgb(red = 0.8,  green = 0.8, blue= 0.8), rgb(red = 0.4,  green = 0.4, blue= 0.4), rgb(red =0,green = 0,  blue=0))) + guides(color = "none")  + plot_annotation(tag_levels ="a")

saveEnvironment()

# for Tapan
# Squish x axis (to x = 40ish)
# plots for 2, 4, 8, and also one for 1.2
# Greyscale RGBs: 0,0,0 (r0=8); 0.4*255,, 0.8*255 (r0=2)
# Latex print (Times New Roman ish)
