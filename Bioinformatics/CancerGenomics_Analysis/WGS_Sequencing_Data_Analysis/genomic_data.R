# Installation for genomic analysis in R

# install data.table from CRAN
install.packages("data.table")

# install package to manage Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# install bioconductor packages
BiocManager::install(c("VariantAnnotation", "GenomicRanges", "Rsamtools", "BSgenome.Hsapiens.UCSC.hg19", "GenomicFeatures", "TxDb.Hsapiens.UCSC.hg19.knownGene", "biomaRt"), update = TRUE, ask = FALSE)

