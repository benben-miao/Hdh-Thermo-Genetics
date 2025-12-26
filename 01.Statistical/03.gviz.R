library(dplyr)
library(Gviz)
library(GenomicRanges)
library(GenomicFeatures)

txdb <- makeTxDbFromGFF(
	"../Genome/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.gtf",
	format = "gtf"
)

grtrack <- GeneRegionTrack(
	txdb,
	name = "Genes",
	genome = "myGenome",
	chromosome = "chr18",
	fill = "blue",
	col = "darkblue",
	stacking = "squish",
	showId = TRUE,
	transcriptAnnotation = "symbol"
)

# gtrack <- GenomeAxisTrack()
# plotTracks(
# 	gtrack,
# 	chromosome = "chr1",
# 	from = 0,
# 	to = 3e6)

dmr_anno <- read.table(
	"./06.dmrs/JJ_G2_vs_HN_G2_DMR_CpG_2k_Sig.txt.anno",
	header = TRUE,
	sep = "\t",
	stringsAsFactors = FALSE
)
dmr_anno <- dmr_anno[grepl("^chr", dmr_anno$chr), ]

dmr_gr <- GRanges(
	seqnames = dmr_anno$chr,
	ranges = IRanges(start = dmr_anno$start, end = dmr_anno$end),
	score = dmr_anno$meth.diff,
	gene = dmr_anno$gene_id,
	anno = dmr_anno$anno_type
)

dmr_track <- DataTrack(
	range = dmr_gr,
	name = "Meth Diff",
	genome = "myGenome",
	chromosome = "chr1",
	type = "h", # "p", "l", "b", "h", "s", "a", "g", "r", "polygon", "horizon", "boxplot", "gradient", "heatmap"
	col = "firebrick",
	fill = "firebrick",
	lwd = 3,
	pch = 16,
	cex = 1
)

gtrack <- GenomeAxisTrack(
	col = "black",
	col.axis = "black",
	fontcolor = "black",
	lwd = 2,
	cex = 1
)

pdf("chr_methylation.pdf", width = 10, height = 5)
plotTracks(
	list(gtrack, grtrack, dmr_track, dmr_track),
	chromosome = "chr18",
	# littleTicks = TRUE,
	showId = TRUE,
	# from = 1e6,
	# to = 5e6,
	from = 5987031,
	to = 5996063,
	col.title = "black",
	col.axis = "black",
	cex.title = 0.8,
	# exponent = 4,
	showSampleNames = TRUE,
	cex.sampleNames = 0.8
)
dev.off()