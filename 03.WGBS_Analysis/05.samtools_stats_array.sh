#!/bin/bash
#PBS -N samtools_stats_array
#PBS -q high
#PBS -l nodes=1:ppn=4
#PBS -l mem=16gb
#PBS -t 1-27
#PBS -j oe
#PBS -o 00.logs/05.samtools_stats_${PBS_ARRAYID}.log
#PBS -m b
#PBS -M benben.miao@outlook.com

cd $PBS_O_WORKDIR
export PATH="/public/home/benthic/miaobenben/miniconda3/bin":$PATH
source activate wgbs

hisat2_index="/public/home/benthic/miaobenben/database/Hdh_hifi/hisat2_index/HALdis.HiFi.Genome.hapX_Mitochondrion.Chrom.fasta"

samples=(JJ_G0_{1..3} HN_G0_{1..3} JJ_G1_{1..3} HN_G1_{1..3} JJ_G2_{1..3} HN_G2_{1..3} JJ_G3_{1..3} HN_G3_{1..3} HN_G2_31_{1..3})
sample=${samples[$PBS_ARRAYID-1]}

# SAMtools: CPU (), Mem () -> Array
/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/samtools \
	flagstat \
	-@ 4 \
	./03.bams/${sample}.q30.sort.bam \
	> ./03.bams/${sample}.q30.sort.bam.flagstat

/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/samtools \
	stats \
	-@ 4 \
	./03.bams/${sample}.q30.sort.bam \
	> ./03.bams/${sample}.q30.sort.bam.stats

/public/home/benthic/miaobenben/miniconda3/envs/wgbs/bin/plot-bamstats \
	--prefix ./03.bams/${sample}/${sample}.q30.sort.bam \
	./03.bams/${sample}.q30.sort.bam.stats

for gp in $(ls ./03.bams/${sample}/*.gp)
do
sed 's/terminal png/terminal svg/g; s/truecolor//g; s/png"/svg"/g' ${gp} > ${gp}.svg.gp
gnuplot ${gp}.svg.gp
done