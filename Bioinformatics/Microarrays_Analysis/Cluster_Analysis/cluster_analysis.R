#' ---
#' title: "Cluster Analysis"
#' author: "Lavinia Carabet"
#' output: 
#'   pdf_document: default
#'   html_document: default
#' ---
#' 
## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' ## Cluster Analysis
#' 
#' Clustering is an unsupervised analysis technique used to group similar objects (genes or samples) together
#' 
#' Builds structure to help explain the relationships that may exist between the objects
#' 
#' ## Hierarchical Clustering
#' 
#' Provides an informative display of ordered objects
#' 
#' Builts a tree structure dynamically (not model-based) using dissimilarities between objects being clustered
#' 
#' ## Preparation
#' 
#' Load the fibroEset library and dataset
#' Obtain the classifications for the samples
#' 
## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("fibroEset")

#' 
## ---- message=FALSE, warning=FALSE-----------------------------------------------------------------------------------------------
library(fibroEset)
data(fibroEset)

fibro.data <- exprs(fibroEset)

dim(fibro.data)
fibro.data[1:5,]

phenoData(fibroEset)$species

#' 
#' Select a random set of 50 genes from the data frame, and subset the data frame
#' 
## --------------------------------------------------------------------------------------------------------------------------------
rand.genes <- sample(row.names(fibro.data),50,replace=FALSE)
fibro.sample <- as.data.frame(fibro.data[rand.genes,])
dim(fibro.sample)

row.names(fibro.sample)

bs <-as.character(phenoData(fibroEset)$species)[as.character(phenoData(fibroEset)$species)=="b"]
gs <- as.character(phenoData(fibroEset)$species)[as.character(phenoData(fibroEset)$species)=="g"]
hs <- as.character(phenoData(fibroEset)$species)[as.character(phenoData(fibroEset)$species)=="h"]

length(bs); length(gs); length(hs)

names(fibro.sample)<- c(paste(bs, '.', 1:length(bs), sep=''), 
                        paste(gs, '.', 1:length(gs), sep=''), paste(hs, '.', 1:length(hs), sep=''))
names(fibro.sample)

#' 
#' Run and plot hierarchical clustering of the samples using Manhattan distance metric and median linkage agglomeration (grouping) method
#' 
#' See <https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/hclust> for details 
#' 
## --------------------------------------------------------------------------------------------------------------------------------
fibro.sample.dist <- dist(t(fibro.sample), method='manhattan')
fibro.hclust <- hclust(fibro.sample.dist, method='median')
# an object of class hclust which describes the tree produced by the iterative clustering process
unclass(fibro.hclust)   

#' 
## --------------------------------------------------------------------------------------------------------------------------------
fibro.hclust <- hclust(dist(t(fibro.sample), method='manhattan'), method='median')

plot(fibro.hclust, 
     main = 'Dendogram of Karaman human, bonobo and gorilla cultured fibroblasts\nHierarchical clustering of the samples', col='purple', labels=FALSE)
axis(1, at = 1:length(fibro.hclust$labels), labels= fibro.hclust$labels[fibro.hclust$order], las=2)


#' 
## --------------------------------------------------------------------------------------------------------------------------------
plot(fibro.hclust, 
     main = 'Dendogram of Karaman human, bonobo and gorilla cultured fibroblasts\nHierarchical clustering of the samples',
     col='purple')

## --------------------------------------------------------------------------------------------------------------------------------
plot(fibro.hclust, 
     main = 'Dendogram of Karaman human, bonobo and gorilla cultured fibroblasts', 
     labels= fibro.hclust$order, 
     hang =-1)

#' Hierachical clustering of the genes
#' 
## --------------------------------------------------------------------------------------------------------------------------------
fibro.hclust.g <- hclust(dist(fibro.sample, method='manhattan'),method='median')
plot(fibro.hclust.g, 
     main = 'Dendogram of Karaman human, bonobo and gorilla cultured fibroblasts\nHierarchical clustering of the genes',
     col='orange')

#' 
#' Run hierarchical clustering and plot the results in two dimensions (on genes and samples):
#' Plot a heatmap with genes on the y-axis and samples on the x-axis
#' <https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/heatmap> 
#' 
## --------------------------------------------------------------------------------------------------------------------------------
hm.rg <- c("#FF0000","#CC0000","#990000","#660000","#330000","#000000",
           "#000000","#0A3300","#146600","#1F9900","#29CC00","#33FF00")
heatmap(as.matrix(fibro.sample), 
        main='Heatmap for all samples on 50 random genes', 
        col=hm.rg, margins=c(2,2))

#' 
#' ## k-means clustering
#' 
#' Iterative algorithm that attempts to partition the dataset into k predefined distinct non-overlapping clusters
#' where each data point belongs to only one cluster
#' 
#' Intra-cluster data points are as similar as possible while the clusters are kept as distinct (far) as possible.
#' 
#' Algorithm converges by minimization of distortion (solution is found by expectation-maximization method)
#' Terminates the iterative assignment of data points to a cluster (E-step) when the sum of the squared distance between the data points and the cluster's centroid (calculated in M-step) is at the minimum
#' The centroid is the arithmetic mean of all data points belonging to that cluster
#' 
#' The less variation within clusters, the more similar the data points are within the same cluster
#' 
#' Calculate PCA on the samples
#' 
#' Calculate k-means clustering on the first two principal components with k=3
#' 
## --------------------------------------------------------------------------------------------------------------------------------
fibro.sample.pca <- prcomp(t(fibro.sample))
fibro.loadings <- fibro.sample.pca$x[,1:2] 	
fibro.loadings
dim(fibro.loadings)

cl <- kmeans(fibro.loadings, centers=3, iter.max=20)
cl

cluster1 <- cl$cluster[cl$cluster==1]
print("Cluster1 membership")
cluster1
cluster2 <- cl$cluster[cl$cluster==2]
print("Cluster2 membership")
cluster2
cluster3 <- cl$cluster[cl$cluster==3]
print("Cluster3 membership")
cluster3

length(cluster1);length(cluster2);length(cluster3)

#' 
#' Plot a two-dimensional scatter plot of the sample classification labels,
#' embedded with the first two PCA eigenfunctions
#' 
## --------------------------------------------------------------------------------------------------------------------------------
plot(fibro.loadings, col = cl$cluster,cex=1, 
     main='PCA plot of  kmeans clustered samples in Karaman experiment', 
     xlab='First Principal Component', ylab='Second Principal Component')
text(fibro.loadings[,1], fibro.loadings[,2],
     col= cl$cluster,cex=0.7, 
     labels= row.names(fibro.loadings), pos=2)
points(cl$centers, col = 1:3, pch = 19, cex=2.5)

