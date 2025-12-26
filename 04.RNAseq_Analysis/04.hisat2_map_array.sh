#!/bin/bash
#PBS -N hisat2_map_array
#PBS -q high
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/04.hisat2_map_${PBS_ARRAYID}.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

hisat2_index="/public/home/benthic/miaobenben/database/Hdh_hifi/hisat2_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# Hisat2: CPU (), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/hisat2 \
	--new-summary \
	--threads 8 \
	-x ${hisat2_index} \
	-1 ./02.cleanreads/${sample}_1.fq.gz \
	-2 ./02.cleanreads/${sample}_2.fq.gz \
	| \
	/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/samtools \
	view -@ 4 -b \
	-o ./03.bams/${sample}.bam