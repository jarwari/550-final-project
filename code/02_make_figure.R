here::i_am("code/02_make_figure.R"
)

library(readxl)
library(here)
library(mgcv)
library(openxlsx)
library(tidyverse)

data <- read_excel(here("data/simulated_data.xlsx"))

data <- data |>
  mutate(
    log.iso_sg_avg = log(iso_sg_avg.sim + 1e-6)
  )

gam1 <- gam(log.iso_sg_avg ~ s(log_Glyphosate_PA_SG.sim), data = data)

png(
  filename = here("outputs", "figure_glyphosate_iso.png"),
  width = 900,
  height = 650,
  res = 120
)

plot(
  gam1,
  shade = TRUE,
  seWithMean = TRUE,
  main = "Relationship between Glyphosate and Isoprotanes",
  xlab = "Glyphosate (log-transformed)",
  ylab = "Smooth function of Glyphosate"
)

dev.off()