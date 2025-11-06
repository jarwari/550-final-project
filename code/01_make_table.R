here::i_am("code/01_make_table.R"
)

library(readxl)
library(tidyverse)
library(utils)
library(dplyr)
library(stringr)
library(dplyr)
library(knitr)
library(kableExtra)
library(openxlsx)
library(gridExtra)
library(ggplot2)
library(here)

data <- read_excel(here("data/simulated_data.xlsx"))

#log transform outcomes
data <- data |>
  mutate(
    log.iso_sg_avg      = log(iso_sg_avg.sim + 1e-6),
    log.isom_sg_avg     = log(isom_sg_avg.sim + 1e-6),
    log.isom_new_sg_avg = log(isom_new_sg_avg.sim + 1e-6),
    log.pgf_sg_avg      = log(pgf_sg_avg.sim + 1e-6),
    log.iso_chem_sg_avg = log(iso_chem_sg_avg.sim + 1e-6),
    log.iso_enz_sg_avg  = log(iso_enz_sg_avg.sim + 1e-6)
  )

#scaling glyphosate by iqr 
data$glyph_constant <- data$Glyphosate_PA_SG.sim + 0.0001
data$glyph.iqr<-log(data$glyph_constant)/(IQR(log(data$glyph_constant),na.rm=T))

#unadjusted linear regression ox stress & glyphosate scaled by iqr
outcome1 <- lm(data$log.iso_sg_avg ~ data$glyph.iqr)
outcome2 <- lm(data$log.isom_sg_avg ~ data$glyph.iqr)
outcome3 <- lm(data$log.isom_new_sg_avg ~ data$glyph.iqr)
outcome4 <- lm(data$log.pgf_sg_avg ~ data$glyph.iqr)
outcome5 <- lm(data$log.iso_chem_sg_avg ~ data$glyph.iqr)
outcome6 <- lm(data$log.iso_enz_sg_avg ~ data$glyph.iqr)

#mapping variable names to readable labels
outcome_labels <- tibble(
  Outcome = c("iso_sg", "isom_sg", "isom_new_sg", "pgf_sg", "iso_chem_sg", "iso_enz_sg"),
  Label = c(
    "Isoprostanes",
    "Isoprostane isomers",
    "New isomers",
    "Prostaglandin F",
    "Chem isoprostanes",
    "Enz isoprostanes"
  )
)
models <- list(
  iso_sg      = outcome1,
  isom_sg     = outcome2,
  isom_new_sg = outcome3,
  pgf_sg      = outcome4,
  iso_chem_sg = outcome5,
  iso_enz_sg  = outcome6
)
# extracting coef + CI for glyph.iqr from each
results <- lapply(names(models), function(name) {
  coefs <- coef(models[[name]])
  ci <- confint(models[[name]])
  
  tibble(
    Outcome = name,
    Beta = coefs["data$glyph.iqr"],
    `95% CI` = sprintf("(%.2f, %.2f)", ci["data$glyph.iqr", 1], ci["data$glyph.iqr", 2])
  )
}) %>% bind_rows()

results <- results %>%
  left_join(outcome_labels, by = "Outcome") %>%
  select(Label, Beta, `95% CI`) %>%
  rename(Outcome = Label)

knitr::kable(results, digits = 2,
             caption = "Glyphosate and oxidative stress biomarker outcomes") |> 
  kable_styling(full_width = FALSE, font_size = 13, bootstrap_options = c("striped", "hover", "condensed"))

results_df <- results
rownames(results_df) <- NULL

results_df <- results
rownames(results_df) <- NULL

table_plot <- gridExtra::tableGrob(
  results_df,
  rows = NULL,
  theme = gridExtra::ttheme_default(
    core = list(fg_params = list(cex = 1.4)),           
    colhead = list(fg_params = list(cex = 1.5, fontface = "bold"))
  )
)

table_plot$widths <- unit(rep(1, ncol(results_df)), "null")
table_plot$heights <- unit(rep(1, nrow(results_df) + 1), "null")

png(
  filename = here("outputs", "table_glyphosate_oxstress.png"),
  width = 900,          # width in pixels
  height = 650,         # height in pixels
  res = 120             # resolution
)

grid::grid.newpage()
grid::grid.draw(table_plot)
dev.off()