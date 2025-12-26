# 1. Conda env wgbs
mamba create -n wgbs python=3.10
conda activate wgbs
# 1.1 fastqc or multiqc
mamba install -c bioconda fastqc
mamba install -c bioconda -c conda-forge multiqc
# 1.2 bwameth v0.2.7 with samtools v1.5.0
mamba install -c bioconda bwameth
# 1.3 trim-galore v0.6.10 with fastqc v0.12.1 and cutadapt v4.8.0 and samtools v1.18.0
# mamba install -c bioconda trim-galore # Error: packages incompatible
mamba install -c bioconda -c conda-forge trim-galore
# 1.4 Warning: libtinfow.so.6, libncursesw.so.6
mamba list ncurses
mamba search ncurses -c conda-forge
mamba install -c conda-forge ncurses=6.4=hcb278e6_0
# 1.5 methyldackel v0.6.1
mamba install -c bioconda methyldackel
# 1.6 bedtools v2.31.1
mamba install -c bioconda -c conda-forge bedtools=2.31.1

# 2. Conda env gatk
mamba create -n gatk python=3.10
conda activate gatk
# 2.1 gatk v4.6.2 with openjdk v17.0.3
mamba install -c bioconda -c conda-forge gatk4
# 2.2 samtools v1.2.0
mamba install -c bioconda -c conda-forge samtools

# 3. Conda env rlang
mamba create -n rlang python=3.10
# 3.1 r-base v4.3.3
mamba install -c conda-forge r-base=4.3.3
# 3.2 libxml2 v2.12.6 for error
mamba install -c conda-forge libxml2
# 3.3 methylKit v1.28.0
R
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("methylKit", dependencies = TRUE)