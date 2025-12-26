#!/usr/bin/env Rscript

# 1. Library Packages
suppressPackageStartupMessages({
	library(argparse)
	library(clusterProfiler)
	library(enrichplot)
	library(ggplot2)
	library(ggsci)
	library(reshape2)
	library(tidyr)
	library(dplyr)
})

# 2. Argument Parser
parser <- ArgumentParser(description = "KEGG Enrichment and Dotplot based on DESeq2, MethylKit, FST Results")

# 3. Add Argument
parser$add_argument(
	"--gene_pathway",
	type = "character",
	default = "./gene_pathway.txt",
	required = TRUE,
	help = "Gene/GeneID tab Pathway [./gene_pathway.txt]."
)
parser$add_argument(
	"--deg_res",
	type = "character",
	default = "./deg_res.txt",
	required = TRUE,
	help = "DESeq2/MethylKit/FST results [./deg_res.txt]."
)
parser$add_argument(
	"--output_dir",
	type = "character",
	default = "./",
	required = TRUE,
	help = "Output directory [./]."
)
parser$add_argument(
	"--padjust_method",
	type = "character",
	default = "fdr",
	choices = c(
		"holm",
		"hochberg",
		"hommel",
		"bonferroni",
		"BH",
		"BY",
		"fdr",
		"none"),
	required = FALSE,
	help = "Pvalue adjust methods [fdr]."
)
parser$add_argument(
	"--pvalue_plot",
	type = "character",
	default = "pvalue",
	choices = c(
		"pvalue",
		"p.adjust",
		"qvalue"),
	required = FALSE,
	help = "Pvalue plot [pvalue]."
)
parser$add_argument(
	"--plot_width",
	type = "numeric",
	default = 6,
	required = FALSE,
	help = "Plot width (inch) [6]."
)
parser$add_argument(
	"--plot_height",
	type = "numeric",
	default = 7,
	required = FALSE,
	help = "Plot height (inch) [7]."
)
parser$add_argument(
	"--pathway_num",
	type = "integer",
	default = 30,
	required = FALSE,
	help = "Pathway number show in plot [30]."
)

# 4. Parse Args
args <- parser$parse_args()

## 1. Read Files
file_base <- sub("\\.txt$", "", basename(args$deg_res))

gene_pathway <- read.table(
	args$gene_pathway,
	header = TRUE,
	sep = "\t",
	quote = "",
	stringsAsFactors = FALSE
)

deg_res <- read.table(
	args$deg_res,
	header = TRUE,
	sep = "\t",
	quote = "",
	stringsAsFactors = FALSE
)
deg_unique <- unique(sort(deg_res[,1]))
print(deg_unique)

## 2. Enricher
enrich_kegg <- enricher(
	gene = deg_unique,
	TERM2GENE = data.frame(gene_pathway[, 2], gene_pathway[, 1]),
	TERM2NAME = NA,
	pvalueCutoff = 1.00,
	pAdjustMethod = args$padjust_method, # "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"
	qvalueCutoff = 1.00,
	minGSSize = 3,
	maxGSSize = 10000
)
print(enrich_kegg)

write.table(
	enrich_kegg@result,
	file = file.path(args$output_dir, paste0(file_base, "_KEGG.txt")),
	col.names = TRUE,
	row.names = FALSE,
	append = FALSE,
	sep = "\t",
	quote = FALSE,
	na = "NA"
)

## 3. Plot
p <- dotplot(
	enrich_kegg,
	x = "GeneRatio",
	color = args$pvalue_plot, # "pvalue", "p.adjust", "qvalue"
	showCategory = args$pathway_num,
	size = NULL,
	split = NULL,
	font.size = 12,
	title = "",
	orderBy = "x",
	label_format = 200
	) +
	geom_text(
		aes(label = Count),
		vjust = 0.5,
		hjust = 0.5,
		size = 2,
		fontface = "bold",
		color = "#ffffff"
	) +
	scale_fill_gradient(
		low = "#ff0000",
		high = "#0033ff",
		space = "Lab"
	) +
	labs(
		y = "KEGG Pathways",
		fill = "Pvalue"
	) +
	theme_light() +
	theme(
		panel.border = element_rect(colour = "black", linewidth = 1, fill = NA),
		panel.grid.major = element_blank(),
		panel.grid.minor = element_blank(),
		axis.ticks = element_line(colour = "black", linewidth = 1),
		axis.ticks.length = unit(0.2, "cm"),
		text = element_text(color = "black", size = 12),
		axis.text.x = element_text(color = "black", angle = 45, hjust = 1),
		axis.text.y = element_text(color = "black"),
	)

## 5. Save
ggsave(
	filename = file.path(args$output_dir, paste0(file_base, "_KEGG.pdf")),
	plot = p,
	device = "pdf",
	path = NULL,
	scale = 1,
	width = args$plot_width,
	height = args$plot_height,
	units = "in", # "in", "cm", "mm", "px"
	dpi = 300,
	limitsize = TRUE
)
ggsave(
	filename = file.path(args$output_dir, paste0(file_base, "_KEGG.jpeg")),
	plot = p,
	device = "jpeg",
	path = NULL,
	scale = 1,
	width = args$plot_width,
	height = args$plot_height,
	units = "in", # "in", "cm", "mm", "px"
	dpi = 300,
	limitsize = TRUE
)