here::i_am("render_report.R")

library(rmarkdown)

render(
  "FinalReport.Rmd",
  knit_root_dir = here::here()
)