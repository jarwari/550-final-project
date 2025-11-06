# repo description

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