library(CMplot)
library(dplyr)

dmr <- read.table(
	"06.dmrs/JJ_G2_vs_HN_G2_DMR_CpG_2k_Sig_Anno.txt",
	header = TRUE,
	sep = "\t",
	stringsAsFactors = FALSE)

chrs <- paste0("chr", 1:18)

data <- dmr %>%
	filter(chr %in% chrs) %>%
	mutate(id = paste0(chr, "_", start)) %>%
	mutate(chr = gsub("chr", "", chr), chr = as.numeric(chr)) %>%
	select(id, chr, start, meth.diff)

highlight <- dmr %>%
	filter(chr %in% chrs) %>%
	mutate(id = paste0(chr, "_", start)) %>%
	filter(!is.na(anno_genes)) %>%
	slice_max(order_by = abs(meth.diff), n = 100) %>%
	select(id, anno_genes)

CMplot(
	data,
	LOG10 = FALSE,
	### chromosome
	bin.size = 1e6, # 1Mb
	band = 1,
	chr.labels = NULL,
	chr.border = FALSE,
	chr.pos.max = FALSE,
	chr.labels.angle = 0,
	chr.den.col = c("#0088ff", "#ff8800", "#ff0000"),
	cir.band = 1,
	cir.chr = TRUE,
	cir.chr.h = 1,
	cir.axis = TRUE,
	cir.axis.col = "black",
	cir.axis.grid = TRUE,
	### multitrack
	multraits = FALSE,
	multracks = FALSE,
	multracks.xaxis = FALSE,
	H = 1,
	ylim = NULL,
	### points
	pch = 16,
	type = "p", # "p" (point), "l" (cross line), "h" (vertical lines)
	col = rep(c("#0088ff55", "#ff880055"), 9),
	# points.alpha = 100L,
	### circle
	plot.type = "d", # "m","c","q","d"
	cex = c(0.5, 1, 1), # circle, manhattan, qqplot
	r = 1, # circle
	outward = FALSE, # circle
	axis.cex = 1, # circle
	axis.lwd = 1, # circle
	lab.cex = 1, # circle
	lab.font = 2, # circle
	### manhattan
	# ylab = expression(-log[10](italic(p))), # manhattan and qqplot
	ylab = "Meth Diff",
	ylab.pos = 3, # manhattan
	xticks.pos = 1, # manhattan
	mar = c(3, 6, 3, 3), # manhattan, bottom, left, up, and right
	mar.between = 0, # manhattan
	### threshold
	threshold = c(-25, 25),
	threshold.col = c("#008800", "#ff0000"),
	threshold.lty = 2,
	threshold.lwd = 2,
	### signal
	amplify = FALSE,
	signal.cex = 2,
	signal.pch = 16,
	signal.line = 2,
	signal.col = NULL,
	### highlight
	highlight = highlight$id,
	highlight.text = as.vector(highlight$anno_genes),
	highlight.cex = 1,
	highlight.pch = 16,
	highlight.type = "p",
	highlight.col = "#ff0000",
	highlight.text.font = 2,
	highlight.text.cex = 0.8,
	highlight.text.col = "#000000",
	### save
	conf.int = TRUE,
	conf.int.col = "white",
	file.output = TRUE,
	file.name = "JJ_G2_vs_HN_G2",
	file = "jpg", # "jpg", "pdf", "tiff", "png"
	box = FALSE,
	main = "",
	main.cex = 2,
	main.font = 2,
	legend.ncol = NULL,
	legend.cex = 1,
	legend.pos = "right", # "left","middle","right"
	dpi = 300,
	width = NULL,
	height = NULL,
	verbose = TRUE
)