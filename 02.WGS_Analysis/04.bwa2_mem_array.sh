#!/bin/bash
#PBS -N bwa2_mem_array
#PBS -q high
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -t 1-270
#PBS -j oe
#PBS -o 00.logs/04.bwa2_mem_${PBS_ARRAYID}.log
#PBS -m bea
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgrs

bwa2_index="/public/home/benthic/miaobenben/database/Hdh_hifi/bwa2_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

samples=(JJ_G0_{1..30} HN_G0_{1..30} JJ_G1_{1..30} HN_G1_{1..30} JJ_G2_{1..30} HN_G2_{1..30} JJ_G3_{1..30} HN_G3_{1..30} HN_G2_31_{1..30})
sample=${samples[$PBS_ARRAYID-1]}

# BWA-Mem2 mem: CPU (), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/wgrs/bin/bwa-mem2 \
	mem \
	-R "@RG\tID:${sample}\tSM:${sample}\tLB:${sample}\tPL:illumina\tPU:flowcell.lane.barcode" \
	-t 4 \
	-M \
	${bwa2_index} \
	./02.cleanreads/${sample}_1.fq.gz \
	./02.cleanreads/${sample}_2.fq.gz \
	| \
	/public/home/benthic/miaobenben/miniconda3/envs/wgrs/bin/samtools \
	view -@ 4 -b \
	-o ./03.bams/${sample}.bam