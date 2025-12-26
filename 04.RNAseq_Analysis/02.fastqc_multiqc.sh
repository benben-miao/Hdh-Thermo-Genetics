#!/bin/bash
#PBS -N fastqc_multiqc
#PBS -q high
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -j oe
#PBS -o 00.logs/02.fastqc_multiqc.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

# FastQC: CPU (<= 16), Mem (100 - 10000 -> 9999) -> Loop
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/fastqc \
	--format fastq \
	--noextract \
	--svg \
	--threads 4 \
	--memory 9999 \
	--outdir ./02.cleanreads/ \
	./02.cleanreads/*.fq.gz
	
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/multiqc \
	--outdir ./02.cleanreads/ \
	./02.cleanreads/*_fastqc.zip