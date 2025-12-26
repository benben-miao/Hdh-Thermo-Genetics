#!/bin/bash
#PBS -N bwameth_mem_array
#PBS -q high
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/04.bwameth_mem_${PBS_ARRAYID}.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgbs

bwameth_index="/public/home/benthic/miaobenben/database/Hdh_hifi/bwameth_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# BWAmeth: CPU (), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/bwameth.py \
	--reference ${bwameth_index} \
	./02.cleanreads/${sample}_1.fq.gz \
	./02.cleanreads/${sample}_2.fq.gz \
	--read-group "@RG\tID:${sample}\tSM:${sample}\tLB:${sample}\tPL:illumina\tPU:flowcell.lane.barcode" \
	--threads 8 \
	| \
	/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/samtools \
	view -@ 4 -b -q 30 \
	-o ./03.bams/${sample}.q30.bam