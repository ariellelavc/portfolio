#' ---
#' title: "Differential Expression"
#' author: "Lavinia Carabet"
#' output: 
#'   pdf_document: default
#'   html_document: default
#' ---
#' 
## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' ## Differential Expression
#' 
#' ## Load GEO rat ketogenic brain data 
#' 
#' Differential gene expression between rats given a control diet and rats given a ketogenic diet (which prevents epileptic seizures)
#' 
#' (<https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE1155>)
#' 
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat <- read.table('./rat_KD.txt', header=T, row.names=1)
dim(dat)
dat[1:5,]

#classes
control.diet <- names(dat[,grep('control', names(dat))])
control.diet

ketogenic.diet <- names(dat[, grep('ketogenic', names(dat))])
ketogenic.diet

#' 
#' ## Calculate the changing genes between the control diet and ketogenic diet classes 
#' 
#' Significance tests determine differential expression between means as a function of variance
#' 
## --------------------------------------------------------------------------------------------------------------------------------
# function to calculate Student’s two-sample t-test on all genes at once
# function returns the p-value for the test
# NAs are removed for each test
t.test.all.genes <- function(x,s1,s2) {
	x1 <- x[s1]
	x2 <- x[s2]
	x1 <- as.numeric(x1)
	x2 <- as.numeric(x2)
	t.out <- t.test(x1, x2, alternative='two.sided', var.equal = TRUE)
	out <- as.numeric(t.out$p.value)
	return(out)
}

t.test.run <- apply(dat,1,t.test.all.genes,s1=control.diet,s2=ketogenic.diet)

#' 
#' Plot a histogram of the p-values
#' 
## --------------------------------------------------------------------------------------------------------------------------------
xname <- "p-values"
hist(t.test.run, col='orange', 
     main=paste("Histogram of" , xname, "for", nrow(dat), 
                "genes \nin the GEO rat ketogenic brain data set"), 
     xlab=xname)

#' 
#' ## Calculate fold change between the groups
#' 
#' Fold change is a relative measure of the magnitude of difference between means
#' 
## --------------------------------------------------------------------------------------------------------------------------------
#calculate means of the groups 
control.diet.mean <- apply(log2(dat[,control.diet]), 1, mean, na.rm = T)
ketogenic.diet.mean <- apply(log2(dat[,ketogenic.diet]), 1, mean, na.rm = T)

#calculate fold change
fold.change <- control.diet.mean - ketogenic.diet.mean 
range(fold.change)

#' 
#' Plot a histogram of the fold change values
#' 
## --------------------------------------------------------------------------------------------------------------------------------
hist(fold.change, col='dark green', main=paste("Histogram of fold change\n(data on log2 scale)"))

#' 
#' ## Volcano plot combining the fold.change and transformed p-values 
#' ## to determine the most significantly differentially expressed genes
#' 
## --------------------------------------------------------------------------------------------------------------------------------
p.trans <- -1 * log10(t.test.run)

x.line <- -log10(.05)	#p-value=0.05
y.line <- log2(2)	    #fold change=2

plot(range(p.trans),range(fold.change),type='n',
     xlab='-1*log10(p-value)',ylab='fold change (data on log2 scale)',
     main='Volcano Plot')

points(p.trans,fold.change,col='black')
points(p.trans[(p.trans>x.line&fold.change>y.line)],fold.change[(p.trans>x.line&fold.change>y.line)],
       col='red',pch=16)
points(p.trans[(p.trans>x.line&fold.change< -y.line)],fold.change[(p.trans>x.line&fold.change< -y.line)],
       col='green',pch=16)

text(p.trans[p.trans>x.line&fold.change>y.line], fold.change[p.trans>x.line&fold.change>y.line],
     labels=dimnames(dat)[[1]][p.trans[p.trans >x.line&fold.change>y.line]], 
     cex=0.65, col='red', pos=4)
text(p.trans[p.trans>x.line&fold.change< -y.line], fold.change[p.trans>x.line&fold.change< -y.line],
     labels=dimnames(dat)[[1]][p.trans[p.trans>x.line&fold.change< -y.line]], 
     cex=0.65, col='green', pos=4)

abline(v=x.line)
abline(h=-y.line)
abline(h=y.line)

#' 
## --------------------------------------------------------------------------------------------------------------------------------
p.trans <- -1 * log10(t.test.run)

plot(range(p.trans),range(fold.change),type='n',
     xlab='-1*log10(p-value)',ylab='fold change (data on log2 scale)',
     main='Volcano Plot')
points(p.trans,fold.change,col='black')
points(p.trans[(p.trans>1.3&fold.change>1)],fold.change[(p.trans>1.3&fold.change>1)],
       col='red',pch=16)
points(p.trans[(p.trans>1.3&fold.change< -1)],fold.change[(p.trans>1.3&fold.change< -1)],
       col='green',pch=16)
abline(v=1.3)
abline(h=-1)
abline(h=1)

#' 
#' ## Gene filtering
#' 
## --------------------------------------------------------------------------------------------------------------------------------
# Select genes with significance alpha=0.05
diff.exp.genes.t.test <- t.test.run[t.test.run < 0.05]

# Select log2 values with significance and filter data
diff.exp.genes.fold <- c(fold.change[fold.change < -log2(2)], fold.change[fold.change > log2(2)])

# Filters original data set
dat.fs = dat[names(diff.exp.genes.t.test),]
dat.fs = dat.fs[names(diff.exp.genes.fold),]

# handle missing values (NA's in gene names) created by second filter
dat.fs = dat.fs[!is.na(dat.fs[,1]),]
dim(dat.fs)

#' 
#' ## Top 5 most significantly differentiated genes (up or down-regulated)
#' 
## --------------------------------------------------------------------------------------------------------------------------------
#Builds data frame with p-value and fold information
ds.featured.genes <- cbind(dat, t.test.run, fold.change)
#Filters data frame with featured selection genes found
ds.featured.genes <- ds.featured.genes [rownames(dat.fs),]
#Orders data frame by fold change
ds.order <- ds.featured.genes[order(ds.featured.genes[,13]),]
dim(ds.order[,12:13])

#' 
#' ## Top 5 down-regulated genes
#' 
## --------------------------------------------------------------------------------------------------------------------------------
head(ds.order, n=5)[,12:13]

#' 
#' ## Top 5 up-regulated genes
#' 
## --------------------------------------------------------------------------------------------------------------------------------
tail(ds.order, n=5)[,12:13]

#' 
#' ## Functional annotations can then be obtained using DAVID 
#' 
#' DAVID bioinformatics database and analysis web resource <https://david.ncifcrf.gov/tools.jsp>
