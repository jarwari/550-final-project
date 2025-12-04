.PHONY: all clean

all: FinalReport.html

FinalReport.html: FinalReport.Rmd outputs/table_glyphosate_oxstress.png outputs/figure_glyphosate_iso.png
	Rscript render_report.R

outputs/table_glyphosate_oxstress.png: code/01_make_table.R data/simulated_data.xlsx
	Rscript code/01_make_table.R

outputs/figure_glyphosate_iso.png: code/02_make_figure.R data/simulated_data.xlsx
	Rscript code/02_make_figure.R

install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
clean:
	rm -f outputs/*.png
	rm -f FinalReport.html
	
docker-run:
	rm -rf report
	mkdir report
	docker run --rm \
		-v "$$(PWD)/report":/home/rstudio/project/final_report \
		final_project

	@echo "Report generated in the report/ directory."

