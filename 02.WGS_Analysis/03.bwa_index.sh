#!/bin/bash
#PBS -N bwa_index
#PBS -q high
#PBS -l nodes=2:ppn=16
#PBS -l mem=64gb
#PBS -j oe
#PBS -o 00.logs/03.bwa_index.log
#PBS -m bea
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgrs

genome="/public/home/benthic/miaobenben/database/Hdh_hifi/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"
bwa_index="/public/home/benthic/miaobenben/database/Hdh_hifi/bwa_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

# BWA index: CPU (), Mem () -> Loop
/public/home/benthic/miaobenben/miniconda3/envs/wgrs/bin/bwa \
	index \
	-p ${bwa_index} \
	${genome}