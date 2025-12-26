#!/bin/bash
#PBS -N subread_featurecount
#PBS -q high
#PBS -l nodes=2:ppn=16
#PBS -l mem=64gb
#PBS -j oe
#PBS -o 00.logs/06.subread_featurecount.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

genome_anno_gtf="/public/home/benthic/miaobenben/database/Hdh_hifi/02.genes/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.gtf"

# FeatureCounts: CPU (), Mem () -> Loop
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/featureCounts \
	-a ${genome_anno_gtf} \
	-F GTF -t exon -g gene_id \
	-p \
	-T 32 \
	-o ./04.degs/feature_counts.txt \
	./03.bams/*.bam