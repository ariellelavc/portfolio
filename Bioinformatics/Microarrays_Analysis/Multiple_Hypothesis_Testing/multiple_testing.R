#' ---
#' title: "Multiple Testing"
#' author: "Lavinia Carabet"
#' output: 
#'   pdf_document: default
#'   html_document: default
#' ---
#' 
## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' ## Preparation
#' 
#' Load the GEO GSE1572 Brain Aging study - transcriptional profiling of the human frontal cortex 
#' 
#' from individuals ranging from 26 to 106 years of age
#' 
#' <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE1572>
#' 
#' Dataset - Transcript (RNA) abundance in aging human brain tissue samples
#' 
#' Load also the annotation file for this dataframe
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat <- read.table('./agingStudy11FCortexAffy.txt', header=T, row.names=1)
dim(dat)
#dat
dat[1:5,]

#' 
## --------------------------------------------------------------------------------------------------------------------------------
ann <- read.table('./agingStudy1FCortexAffyAnn.txt', header=T, row.names=1)
dim(ann)
ann

#' 
#' Create 2 vectors for sample (group) comparison:
#' 
#' 1. between male and female patients
#' 2. between patients >= 50 years of age and those < 50 years of age.
#' 
## --------------------------------------------------------------------------------------------------------------------------------
M <- row.names(ann[ann$Gender =="M",]); F <- row.names(ann[ann$Gender =="F",])

M; F
length(M); length(F)

O <- row.names(ann[ann$Age >=50,]); Y <- row.names(ann[ann$Age < 50,])

O; Y
length(O); length(Y)

#' 
#' Gene vectors (indices of specific genes/rows) for gender and age comparisons:
#' 
## --------------------------------------------------------------------------------------------------------------------------------
g.g <- c(1394,  1474,  1917,  2099,  2367,  2428, 2625,  3168,  3181,  3641,  3832,  4526,
         4731,  4863,  6062,  6356,  6684,  6787,  6900,  7223,  7244,  7299,  8086,  8652,
         8959,  9073,  9145,  9389, 10219, 11238, 11669, 11674, 11793)

g.a <- c(25, 302,  1847,  2324,  246,  2757, 3222, 3675,  4429,  4430,  4912,  5640, 5835, 
         5856,  6803,  7229,  7833,  8133, 8579,  8822,  8994, 10101, 11433, 12039, 12353,
         12404, 12442, 67, 88, 100)

#' 
#' ## Statistical hypothesis testing
#' 
#' Are there significant differences between the groups? 
#' 
#' Calculate Student's two-sample t-test on all genes at once
#' 
## --------------------------------------------------------------------------------------------------------------------------------
# s1 and s2 are dimensions of the two samples/groups
# returns the p-value for the t-test
# p-value is a measure of the probability that an observed difference could have occurred
# just by random chance. 
# The lower the p-value, the greater the statistical significance of the observed difference

t.test.all.genes <- function(x, s1, s2) {
  x1 <- x[s1]
	x2 <- x[s2]
	x1 <- as.numeric(x1)
	x2 <- as.numeric(x2)
	t.out <- t.test(x1, x2, alternative='two.sided', var.equal = TRUE)
	out <- as.numeric(t.out$p.value)
	return(out)
}

#' 
#' Gender comparison
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat2 <- dat[g.g,]
dim(dat2)

names(dat2) <- substr(names(dat2),1,8)

# apply(X, MARGIN, FUN) MARGIN=1 on rows, =2 on columns
rawp.gender<- apply(dat2,1,t.test.all.genes,s1=M,s2=F) 
length(rawp.gender)
rawp.gender

# look at distribution of p-values
hist(rawp.gender, col="blue")

#' Age comparison
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat3 <- dat[g.a,]
dim(dat3)

names(dat3) <- substr(names(dat3),1,8)

rawp.age <- apply(dat3,1,t.test.all.genes,s1=O,s2=Y)
length(rawp.age)
rawp.age

# look at distribution of p-values
hist(rawp.age, col="red")

#' 
#' ## Multiple testing
#' 
#' When conducting a statistical test, under the null hypothesis (samples' means are equal), the p-value (observed significance)
#' is the chance of getting a test statistic more extreme than the observed test statistic
#' 
#' When conducting a single statistical test, this probability is a good estimate
#' 
#' When conducting multiple statistical tests, the likelihood of getting a significant p-value increases due to the shear number of independent tests:
#'   - Effect of testing too many genes can result in high false positive rate
#'   - For 100 t-tests, the number of significant results occurring by chance at $\alpha$=0.05 is 5
#'   - Alpha level ($\alpha$) represents the probability of making a Type I error and 
#'     is the p-value below which the null hypothesis that there is no difference between means is rejected.
#'     A p-value of 0.05 indicates accepting a 5% chance of being wrong when rejecting the null hypothesis.
#'     A p-value < 0.05 indicates rejection of the null hypothesis and existence of a significant difference.
#'     
#' There is a need to adjust the raw p-values (or criteria) to compensate for multiple tests (genes)
#' 
#' Adjust the raw p-values for multiple testing corrections with the Holm's step-down procedure 
#' for strong control of the family-wise Type I error rate (FWER)
#' 
#' FWER - the probability of at least one type I error (false positive)
#' Type I error - incorrect rejection of a true null hypothesis
#' 
## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("multtest")

#' 
## ---- message=FALSE--------------------------------------------------------------------------------------------------------------
library(multtest)

procs <- c("Holm")
p.gender.mt.cor.h <- mt.rawp2adjp(rawp.gender,procs)
p.age.mt.cor.h <- mt.rawp2adjp(rawp.age,procs)
p.gender.mt.cor.h;p.age.mt.cor.h

#' 
#' The mt.rawp2adjp function sorts the raw and adjusted p-values and 
#' returns a list with components:
#' 
#' `adjp`	A matrix of adjusted p-values, with rows corresponding to hypotheses (genes) and columns to multiple testing procedures. Hypotheses are sorted in increasing order of their raw (unadjusted) p-values.
#' 
#' `index`	A vector of row indices, between 1 and `length(rawp)`, where rows are sorted according to their raw (unadjusted) p-values. To obtain the adjusted p-values in the original data order, use `adjp[order(index),]`. 
#' 
#' `as.data.frame(p.gender.mt.cor.h$adjp)$Holm` – gives the sorted adjusted p-values
#' 
#' `as.data.frame(p.gender.mt.cor.h$adjp)$rawp` – gives the sorted non-adjusted p-values
#' 
#' ## Plotting results from multiple testing procedures
#' 
## --------------------------------------------------------------------------------------------------------------------------------
procs <- c("rawp","Holm")
cols <- c("black","orange")
ltypes <- c(3,1)
mt.plot(p.age.mt.cor.h$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(as.data.frame(p.age.mt.cor.h$adjp)$Holm)), lty=ltypes,col=cols,lwd=2, 
        main="Adjusted Holm p-values vs. number of rejected hypotheses\nComparison between patients age >= 50 years and those < 50 years")

#' 
## --------------------------------------------------------------------------------------------------------------------------------
procs <- c("rawp","Holm")
cols <- c("black","purple")
ltypes <- c(3,1)
mt.plot(p.gender.mt.cor.h$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(as.data.frame(p.gender.mt.cor.h$adjp)$Holm)), lty=ltypes,col=cols,lwd=2, 
        main="Adjusted Holm p-values vs. number of rejected hypotheses\nComparison between male and female patients")

#' 
#' Adjust the raw p-values for multiple testing corrections with the Bonferroni's single step procedure 
#' for strong control of the family-wise Type I error rate (FWER)
#' 
#' Only dependent on the number of tests (genes)
#' 
#' More conservative method compared to Holm's:
#'  - p-values larger reducing the possibility of getting a statistically significant result
#'  - appropiate when a single false positive would be a problem
#'  - useful for small number of multiple comparisons and looking for one or two that might be significant
#' 
## --------------------------------------------------------------------------------------------------------------------------------
#library(multtest)

procs <- c("Bonferroni")
p.gender.mt.cor.b <- mt.rawp2adjp(rawp.gender,procs)
p.age.mt.cor.b <- mt.rawp2adjp(rawp.age,procs)
p.gender.mt.cor.b;p.age.mt.cor.b

## --------------------------------------------------------------------------------------------------------------------------------
procs <- c("rawp","Bonferroni")
cols <- c("black","green")
ltypes <- c(3,1)
mt.plot(p.age.mt.cor.b$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(as.data.frame(p.age.mt.cor.b$adjp)$Bonferroni)), lty=ltypes,col=cols,lwd=2, 
        main="Adjusted Bonferroni p-values vs. number of rejected hypotheses\nComparison between patients age >= 50 years and those < 50 years")

## --------------------------------------------------------------------------------------------------------------------------------
procs <- c("rawp","Bonferroni")
cols <- c("black","blue")
ltypes <- c(3,1)
mt.plot(p.gender.mt.cor.b$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(as.data.frame(p.gender.mt.cor.b$adjp)$Bonferroni)), 
        lty=ltypes,col=cols,lwd=2, main="Adjusted Bonferroni p-values vs. number of rejected hypotheses\nComparison between male and female patients")

## --------------------------------------------------------------------------------------------------------------------------------
#library(multtest)

procs <- c("Bonferroni", "Holm")
p.gender.mt.cor.bh <- mt.rawp2adjp(rawp.gender,procs)
p.age.mt.cor.bh <- mt.rawp2adjp(rawp.age,procs)
p.gender.mt.cor.bh;p.age.mt.cor.bh

## --------------------------------------------------------------------------------------------------------------------------------
procs <- c("rawp","Bonferroni", "Holm")
cols <- c("black","green", "orange")
ltypes <- c(3,rep(1,2))
mt.plot(p.age.mt.cor.bh$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(max(as.data.frame(p.age.mt.cor.bh$adjp)$Bonferroni), 
                     max(as.data.frame(p.age.mt.cor.bh$adjp)$Holm))), lty=ltypes,col=cols,lwd=2, 
        main="Adjusted p-values (Type I Error Rate) vs. number of rejected hypotheses\nComparison between patients age >= 50 years and those < 50 years")

## --------------------------------------------------------------------------------------------------------------------------------
procs<-c("rawp","Bonferroni", "Holm")
cols<-c("black","blue", "purple")
ltypes<-c(3,rep(1,2))
mt.plot(p.gender.mt.cor.bh$adjp, plottype='pvsr',proc=procs, 
        leg=c(1, max(max(as.data.frame(p.gender.mt.cor.bh$adjp)$Bonferroni),
                     max(as.data.frame(p.gender.mt.cor.bh$adjp)$Holm))), lty=ltypes,col=cols,lwd=2, 
        main="Adjusted p-values (Type I Error Rate) vs. number of rejected hypotheses\nComparison between male and female patients")

