#!/bin/bash
#PBS -N hisat2_build
#PBS -q high
#PBS -l nodes=2:ppn=16
#PBS -l mem=64gb
#PBS -j oe
#PBS -o 00.logs/03.hisat2_build.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate mrna

mkdir /public/home/benthic/miaobenben/database/Hdh_hifi/hisat2_index

genome="/public/home/benthic/miaobenben/database/Hdh_hifi/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"
hisat2_index="/public/home/benthic/miaobenben/database/Hdh_hifi/hisat2_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

# Hisat2-Build: CPU (), Mem () -> Loop
/public/home/benthic/miaobenben/miniconda3/envs/mrna/bin/hisat2-build \
	-p 32 \
	${genome} \
	${hisat2_index}