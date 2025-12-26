#!/bin/bash
#PBS -N bwameth_index
#PBS -q high
#PBS -l nodes=2:ppn=16
#PBS -l mem=64gb
#PBS -j oe
#PBS -o 00.logs/03.bwameth_index.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgbs

mkdir /public/home/benthic/miaobenben/database/Hdh_hifi/bwameth_index

bwameth_index="/public/home/benthic/miaobenben/database/Hdh_hifi/bwameth_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

# BWAmeth index: CPU (), Mem () -> Loop
/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/bwameth.py \
	index \
	${bwameth_index}