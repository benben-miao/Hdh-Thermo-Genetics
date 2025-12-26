#!/bin/bash
#PBS -N fastp_clean_array
#PBS -q high
#PBS -l nodes=1:ppn=8
#PBS -l mem=32gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/01.fastp_clean_${PBS_ARRAYID}.log
#PBS -m bea
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# Fastp: CPU (<16), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/fastp \
	--detect_adapter_for_pe \
	--cut_mean_quality 20 \
	--cut_front \
	--cut_tail \
	--length_required 15 \
	--n_base_limit 5 \
	--thread 8 \
	-i ./01.rawreads/${sample}_1.fq.gz \
	-I ./01.rawreads/${sample}_2.fq.gz \
	-o ./02.cleanreads/${sample}_1.fq.gz \
	-O ./02.cleanreads/${sample}_2.fq.gz \
	--html ./02.cleanreads/${sample}_fastp_report.html \
	--json ./02.cleanreads/${sample}_fastp_report.json