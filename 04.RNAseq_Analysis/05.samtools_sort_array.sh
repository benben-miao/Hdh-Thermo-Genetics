#!/bin/bash
#PBS -N samtools_sort_array
#PBS -q high
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/05.samtools_sort_${PBS_ARRAYID}.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# SAMtools sort: CPU (), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/samtools \
	sort -@ 8 \
	-o ./03.bams/${sample}.sort.bam \
	./03.bams/${sample}.bam