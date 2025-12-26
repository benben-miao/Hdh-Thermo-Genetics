#!/bin/bash
#PBS -N trimgalore_trim_array
#PBS -q high
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/01.trimgalore_trim_${PBS_ARRAYID}.log
#PBS -m bea
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgbs

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# TrimGalore: CPU (<= 8), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/trim_galore \
	--paired \
	--quality 20 \
	--phred33 \
	--length 20 \
	--max_n 5 \
	--trim-n \
	--cores 4 \
	--gzip \
	--output_dir ./02.cleanreads \
	./01.rawreads/${sample}_1.fq.gz \
	./01.rawreads/${sample}_2.fq.gz