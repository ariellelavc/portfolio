## ----setup, include=FALSE------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- message = FALSE----------------------------------------------------------------------------------------
library("limma")
library("Glimma")
library("edgeR")
library("Homo.sapiens")
#library("DEFormats")

library("airway")
library("gplots")
library("RColorBrewer")


## ------------------------------------------------------------------------------------------------------------
data(airway)
airway


## ------------------------------------------------------------------------------------------------------------
head(assay(airway))


## ------------------------------------------------------------------------------------------------------------
as.data.frame(colData(airway))


## ------------------------------------------------------------------------------------------------------------
dge <- edgeR::SE2DGEList(airway)
dim(dge)

## ------------------------------------------------------------------------------------------------------------
dge$samples
head(rownames(dge)) # genes
head(dge$counts)


## ------------------------------------------------------------------------------------------------------------
dge$samples$group <- dge$samples$dex
dge$samples


## ---- message=FALSE------------------------------------------------------------------------------------------
geneid <- rownames(dge)
genes <- select(Homo.sapiens, keys=geneid, columns=c("ENTREZID", "SYMBOL", "TXCHROM"),
                keytype="ENSEMBL")
head(genes)
dim(genes)


## ------------------------------------------------------------------------------------------------------------
genes <- genes[!duplicated(genes$ENSEMBL),]
dim(genes)


## ------------------------------------------------------------------------------------------------------------
dge$genes <- genes
dge


## ------------------------------------------------------------------------------------------------------------
avg_lib_size <- mean(dge$samples$lib.size) * 1e-6 #million
avg_lib_size
median_lib_size <- median(dge$samples$lib.size) * 1e-6 #million
median_lib_size

cpm <- edgeR::cpm(dge)
lcpm <- edgeR::cpm(dge, log = TRUE)
summary(lcpm)


## ------------------------------------------------------------------------------------------------------------
# number of genes unexpressed across all 8 sample 
table(rowSums(dge$counts==0)==8)

# automated gene filtering with filterByExpr keeping as many genes as possible with worthwhile counts
keep.exprs <- edgeR::filterByExpr(dge, group=dge$samples$group)
dge <- dge[keep.exprs,,keep.lib.sizes=FALSE]
dim(dge)
dge

## ------------------------------------------------------------------------------------------------------------
lcpm.cutoff <- log2(10/median_lib_size + 2/avg_lib_size)

samplenames <- colnames(dge)
nsamples <- ncol(dge)
col <- brewer.pal(nsamples, "Paired")
par(mfrow=c(1,2))
plot(density(lcpm[,1]), col=col[1], lwd=2, ylim=c(0,0.26), las=2, main="", xlab="")
title(main="Raw data", xlab="Log-cpm")
abline(v=lcpm.cutoff, lty=3)

for (i in 2:nsamples){
  den <- density(lcpm[,i])
  lines(den$x, den$y, col=col[i], lwd=2)
}
legend("topright", samplenames, text.col=col, bty="n")

lcpm <- cpm(dge, log=TRUE)
plot(density(lcpm[,1]), col=col[1], lwd=2, ylim=c(0,0.26), las=2, main="", xlab="")
title(main="Filtered data", xlab="Log-cpm")
abline(v=lcpm.cutoff, lty=3)

for (i in 2:nsamples){
  den <- density(lcpm[,i])
  lines(den$x, den$y, col=col[i], lwd=2)
}
legend("topright", samplenames, text.col=col, bty="n")


## ------------------------------------------------------------------------------------------------------------
dge <- calcNormFactors(dge, method = "TMM")
dge$samples$norm.factors


## ------------------------------------------------------------------------------------------------------------
lcpm <- cpm(dge, log=TRUE)
boxplot(lcpm, las=2, col=col, main="")
title(main="Normalized data",ylab="Log-cpm")


## ------------------------------------------------------------------------------------------------------------
limma::plotMDS(lcpm, labels=dge$samples$group, col=as.numeric(dge$samples$group)+1)
title(main="Sample groups")


## ------------------------------------------------------------------------------------------------------------
glMDSPlot(lcpm, groups = dge$samples$group, launch = FALSE)


## ------------------------------------------------------------------------------------------------------------
group <- dge$samples$group
design <- model.matrix(~0+group) # no intercept model
#design
colnames(design) <- gsub("group", "", colnames(design))
design

## ------------------------------------------------------------------------------------------------------------
contr.matrix <- makeContrasts(
   trt_vs_untrt = trt-untrt, 
   levels = colnames(design))
contr.matrix


## ------------------------------------------------------------------------------------------------------------
v <- voom(dge, design, plot=TRUE)
v


## ------------------------------------------------------------------------------------------------------------
vfit <- lmFit(v, design)
vfit <- contrasts.fit(vfit, contrasts=contr.matrix)
efit <- eBayes(vfit)
plotSA(efit, main="Final model: Mean-variance trend")


## ------------------------------------------------------------------------------------------------------------
vfit


## ------------------------------------------------------------------------------------------------------------
efit


## ------------------------------------------------------------------------------------------------------------
dt <- decideTests(efit, method = "separate",
                    adjust.method = "BH", p.value = 0.05, lfc = 0)
summary(dt)


## ------------------------------------------------------------------------------------------------------------
tt <- topTable(efit, coef = 1, number = Inf, genelist = efit$genes,
         adjust.method = "BH", p.value = 0.05, lfc=0,
         sort.by = "B") # B-log-odds that the gene is differentially expressed
dim(tt)
head(tt, n=20)


## ------------------------------------------------------------------------------------------------------------
tfit <- treat(vfit, lfc=1)
dt <- decideTests(tfit)
summary(dt)


## ------------------------------------------------------------------------------------------------------------
trt_vs_untrt <- topTreat(tfit, coef=1, n=Inf)
head(trt_vs_untrt, n=30)


## ------------------------------------------------------------------------------------------------------------
plotMD(tfit, column=1, status=dt[,1], main=colnames(tfit)[1], 
       xlim=c(-8,13))


## ------------------------------------------------------------------------------------------------------------
glMDPlot(tfit, coef=1, status=dt, main=colnames(tfit)[1],
         side.main="SYMBOL", counts=lcpm, groups=group, launch=FALSE)


## ---- fig.height=8, fig.width=6------------------------------------------------------------------------------
trt_vs_untrt.topgenes <- trt_vs_untrt$ENSEMBL[1:30]
i <- which(v$genes$ENSEMBL %in% trt_vs_untrt.topgenes)
mycol <- colorpanel(100,"blue","white","red")
heatmap.2(lcpm[i,], scale="row",
   labRow=v$genes$SYMBOL[i], labCol=group, 
   col=mycol, trace="none", density.info="none", 
   margin=c(8,6), dendrogram="column")


## ------------------------------------------------------------------------------------------------------------
sessionInfo()

