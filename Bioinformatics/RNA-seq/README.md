**Data**

* GEO GSE95077 <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE95077>
    - RNA-seq (Illumina HiSeq 2500 paired) on RNA isolated from multiple myeloma KMS12-BM untreated or treated with amiloride, 3 replicas each
    - SRA Run selector to download accession list (./data/SRR_Acc_List.txt) and metadata (./data/SRR_Acc_List.txt) files
    - `parallel-fastq-dump` to fetch and split the samples (very large > 5 Gb)

* Reference genome
    - Homo sapience NCBI assembly GRCh38 <https://support.illumina.com/sequencing/sequencing_software/igenome.html>

**Analysis**

* Pre-processing and differential gene expression analysis of RNA-seq data with `fastp`, `TopHat` and `Cufflinks` package 
(./RNA-seq_Analysis.ipynb)

* Exploration, manipulation and visualization of Cuffdiff RNA-seq differential analysis output using `CummeRbund` package

* Gene-set enrichment pathways (KEGG) analysis and visualization of Cuffdiff DE output with `gage` and `pathview` R packages 

* Gene-set disease ontology enrichment and visualization with `DOSE`, `enrichplot` and `cnetplot` R packages 

* Gene ontology enrichment and visualization with `clusterProfiler`, and `goplot` R packages
(./analysis/diffexpr2/diffexpr2.R
 ./analysis/diffexpr2/diffexpr2.Rmd
 ./analysis/diffexpr2/diffexpr2.pdf)

