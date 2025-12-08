# build final report
run docker pull jarwari/final_project and make docker-run in the terminal to build the report. 
## build image 
run docker build -t jarwari/final_project
## repo description
This repository contains all code and workflows for generating the final report for the project.  
The workflow is fully automated using a `Makefile`, and the package environment is managed with `renv`.
## file descriptions
`code/01_make_table.R`
- log tranforms outcomes, scales exposures by IQR, and performs unadjusted linear regressions
- saves table with betas and cis as a `table_glyphosate_oxstress.png` object in the `outputs/` folder

`code/02_make_figure.R`
- runs a generalized additive model for the isoprotanes outcome
- saves the plot as `figure_glyphosate_iso.png` object in the `outputs/` folder

`FinalReport.Rmd`
- loads the table and figure

`render_report.R`
- renders final report

`Makefile`
- contains rules and dependencies for building the report 
- includes an `install` rule for restoring the project’s package environment

`Dockerfile`
- defines the containerized environment used to build the report.