#' ---
#' title: "Dimensionality Reduction"
#' author: "Lavinia Carabet"
#' output: 
#'   pdf_document: default
#'   html_document: default
#' ---
#' 
## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
#' ## Dimensionality Reduction
#' 
#' Techniques that attempt to examine the underlying patterns or relationships for a large number of variables and
#' determine whether the information can be better summarized in a few factors or components
#' 
#' ## Principal Component Analysis
#' 
#' Statistical method that projects a high-dimensional space into a much lower-dimensional subspace (2D or 3D)
#' 
#' Identifies principal components to reduce dimensionality while maintaining the inherent structure of the data
#' 
#' Principal components are uncorrelated linear combinations of the original variables with variances as large as possible,
#' with each successive component explaining less and less variability
#' 
#' The first principal component can be defined as a direction that maximizes the variance of the projected data
#' The i-th principal component can be taken as a direction orthogonal to the first i-1 principal components that maximizes the variance of the projected data
#' 
#' Principal components are eigenvectors of the data's covariance matrix often computed by eigen decomposition of the data covariance matrix or singular value decomposition of the data matrix
#' 
#' Eigenvector - of a linear transformation - is a non-zero vector that changes at most by a scalar factor 
#' when that linear transformation is applied to it
#' 
#' Eigenvalue - corresponding to the eigenvector - is the factor by which the eigenvector is scaled
#' 
#' Geometrically, an eigenvector, corresponding to a real non-zero eigenvalue, points in a direction in which it is stretched by the transformation and the eigenvalue is the factor by which it is stretched
#' 
#' ## Preparation
#' 
#' Load the GEO GSE2990 Sotiriou Breast Cancer data - Gene Expression Profiling in Breast Cancer: Understanding the Molecular Basis of Histologic Grade To Improve Prognosis
#' 
#' <https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE2990>
#' 
#' Dataset - microarray experiments (gene expression data) from primary breast tumors of tamoxifen-untreated patients
#' 
#' Load also the annotation file for this dataframe
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat <- read.table('./sotiriou.txt', header=T, row.names=1)
dim(dat)
#dat
dat[1:5,]

#' 
#' 
## --------------------------------------------------------------------------------------------------------------------------------
ann <- read.table('./sotiriouAnn.txt', header=T, row.names=1)
dim(ann)
ann

#' 
#' ## Conduct Principal Component Analysis (PCA) and plot PCA results
#' 
#' `prcomp` performs a PCA by a singular value decomposition of the given (centered and possibly scaled) data matrix and 
#' returns a list with class `prcomp` containing the following components:
#' 
#'   `sdev`     the standard deviations of the principal components (i.e., the square roots of the eigenvalues of the covariance/correlation matrix,               though the calculation is actually done with the singular values of the data matrix)
#'   
#'   `rotation` the matrix of variable loadings (i.e., a matrix whose columns contain the eigenvectors);
#'              (the coordinates of the variables -genes- in the projected principal components' space)
#'              
#'   `X`        the value of the rotated data (the centered (and scaled if requested) data multiplied by the rotation matrix); 
#'              (the coordinates of the observations -samples- in the projected principal components' space
#'              
#'   `center`,`scale`  the centering and scaling used, or FALSE
#' 
## --------------------------------------------------------------------------------------------------------------------------------
dat.pca <- prcomp(t(dat))
# unclass(dat.pca)

dat.loadings <- dat.pca$x[,1:2] 	#dim(dat.loadings) [1] 125   2
dat.loadings

#' 
## --------------------------------------------------------------------------------------------------------------------------------
levels(as.factor(ann$site))

dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]]

length(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]])
length(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]])

#' 
## ---- fig.height=8---------------------------------------------------------------------------------------------------------------
col <- as.numeric(as.factor(unique(ann$site))) +1

plot(range(dat.loadings[,1]), range(dat.loadings[,2]), 
     xlab='First Principal Component',ylab='Second Principal Component',
     main='PCA plot of Sotiriou breast cancer data')

points(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
       dat.loadings[,2][ as.character(ann$site)==levels(as.factor(ann$site))[1]],
       col=col[1],pch=16,cex=1.5)

text(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
     dat.loadings[,2][ as.character(ann$site)==levels(as.factor(ann$site))[1]],
     col=col[1] ,cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[1], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[1],]), sep= ' '), 
     pos=2)

points(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       dat.loadings[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
       col=col[2],pch=16,cex=1.5)

text(dat.loadings[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]], 
     dat.loadings[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
     col=col[2],cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[2], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[2],]), sep= ' '), 
     pos=2)

legend(min(range(dat.loadings[,1])), max(range(dat.loadings[,2]) ), 
       levels(as.factor(ann$site)),
       col=col,pch=16,cex=.75)


#' 
#' ## Biplot
#' 
#' Visualize both the observations (samples) and the variables (genes) of a data matrix on the same plot
#' 
## ---- fig.height=16, fig.width=16------------------------------------------------------------------------------------------------
names(dat) <- paste(as.character(ann$site), '-', row.names(ann), sep= ' ')
dat.pca <- prcomp(t(dat))
col <- c("black", "orange")
biplot(dat.pca,scale=TRUE,col=col, 
       xlab='First Principal Component', ylab='Second Principal Component', 
       main='PCA biplot of Sotiriou breast cancer data')

#' 
#' ## Scree plot corresponding to the PCA above
#' 
## --------------------------------------------------------------------------------------------------------------------------------
# standard deviation of the principal components 
# (i.e. the square roots of the eigenvalues of the covariance/correlation matrix)
print("Standard deviation of the principal components")
dat.pca$sdev

# percent variability of the principal components
print("Percent variability of the principal components")
dat.pca.var <- round(dat.pca$sdev^2 / sum(dat.pca$sdev^2)*100,2)
dat.pca.var

plot(c(1:length(dat.pca.var)),dat.pca.var,type='b',
     xlab='# components',ylab='% variance',
     main='Scree plot of Sotiriou breast cancer data', col='orange')

#' 
#' ## How much variability in the data is explained using only the first two eigenvalues?
#' 
## --------------------------------------------------------------------------------------------------------------------------------
#summary(dat.pca) 
summary(dat.pca)$importance[, 1:2]

variability <- round((summary(dat.pca)$importance[3,2])*100,2)
variability

# or

variability <- round((summary(dat.pca)$importance[2,1] + 
                        summary(dat.pca)$importance[2,2])*100,2)
variability

#or

variability <- dat.pca.var[1] + dat.pca.var[2]
variability

#' 
#' ## Multidimensional scaling (MDS)
#' 
#' Dimensionality reduction technique that fits the original data into a low-dimensional coordinate system,
#' such that any distortion caused by dimension reduction is minimized
#' 
#' MDS uses the distances or similarities between instances (genes or samples) in representing proximities,
#' while preserving (nearly matching) the original distances or similarities
#' 
#' `Stress` is the measure used to determine how close the low-dimensional space matches the high-dimensional space 
#' 
#' ## Metric (classical) MDS
#' 
#' Determine the distance or similarity values between all pairs of genes/samples
#' 
#' Arranges the N items in low-dimensional space using the actual magnitudes of the distances/similarities
#' 
#' Also known as `principal coordinate analysis`
#' 
#' `dist`       this function computes and returns the distance matrix computed by using the specified distance measure
#'              to compute the distances between the rows of a data matrix
#'        
#' `cmdscale`   classical multidimensional scaling of a data matrix. 
#'              takes a set of distances/dissimilarities and
#'              returns a set of points such that the distances between the points are approximatively equal to the dissimilarities
#'              
#' 'points'     a matrix with k=2 columns whose rows give the coordinates of the points chosen to represent the dissimilarities
#'              k the dimension of the space which the data are to be represented in
#' 
#' 
## ---- fig.height=8---------------------------------------------------------------------------------------------------------------
dat.dist <- dist(t(dat), method = "euclidean")
dat.loc <- cmdscale(dat.dist)

col <- as.numeric(as.factor(unique(ann$site))) +1

#xlab='1st dimension of space coordinates of the points representing dissimilarities between all pairs of samples'
#ylab='2nd dimension of space coordinates of the points representing dissimilarities between all pairs of samples')

plot(dat.loc, type = "n",xlab='1st dimension of space', ylab='2nd dimension of space')

points(dat.loc[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]],
       dat.loc[,2][as.character(ann$site)==levels(as.factor(ann$site))[1]],
       col=col[1],pch=16,cex=1.5)

text(dat.loc[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
     dat.loc[,2][ as.character(ann$site)==levels(as.factor(ann$site))[1]],
     col=col[1] ,cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[1], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[1],]), sep= ' '), 
     pos=2)

points(dat.loc[,1][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
       dat.loc[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       col=col[2],pch=16,cex=1.5)

text(dat.loc[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]], 
     dat.loc[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
     col=col[2],cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[2], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[2],]), sep= ' '), 
     pos=2)

title(main='MDS plot of Sotiriou breast cancer data')

legend(min(range(dat.loc[,1])), max(range(dat.loc[,2]) ), levels(as.factor(ann$site)),
       col=col,pch=16,cex=.75)


#' 
#' ## Non-Metric MDS
#' 
#' Determine the distance or similarity values between all pairs of genes/samples
#' 
#' Arrange the N items in low-dimensional space using only the rank orders of the distances/similarities
#' 
#' `isoMDS`   Kruskal's non-metric MDS
#'            chooses a k-dimensional (default k=2) configuration to minimize the stress, which is
#'            the square root of the ratio of the sum of squared differences between the input distances and
#'            those of the configuration to the sum of configuration distances squared
#'            
#'            Arguments:
#'            
#'            `d` distance structure of the form returned by dist, or a full, symmetric matrix. 
#'                Data are assumed to be dissimilarities or relative distances, 
#'                but must be positive except for self-distance. 
#'                Both missing and infinite values are allowed
#'            
#'            `y` an initial configuration. 
#'                If none is supplied, cmdscale is used to provide the classical solution, 
#'                unless there are missing or infinite dissimilarities.
#'            
#'            `k` the desired dimension for the solution, passed to cmdscale
#'            
#'            `trace` logical for tracing optimization (default TRUE). 
#'                   If TRUE, the initial stress and the current stress are printed out every 5 iterations
#'            
#'            Returns:
#'            
#'            `points` a k-column vector of the fitted configuration
#'            `stress` the final stress achieved (in percent)
#'                     Kruskal's guidelines for stress values:
#'                     
#'                     Stress     Goodness of fit
#'                     20%        Poor
#'                     10%        Fair
#'                     5%         Good
#'                     2.5%       Excellent
#'                     0%         Perfect
#' 
## --------------------------------------------------------------------------------------------------------------------------------
library(MASS)
dat.dist <- dist(t(dat))
dat.mds <- isoMDS(dat.dist)

## --------------------------------------------------------------------------------------------------------------------------------

dat.mds$stress
dat.mds$points

## ---- fig.height=8---------------------------------------------------------------------------------------------------------------
col <- as.numeric(as.factor(unique(ann$site))) +1

# xlab='1st dimension of the fitted configuration coordinates of the points 
# representing dissimilarities between all pairs of samples'
# ylab='2nd dimension of the fitted configuration coordinates of the points 
# representing dissimilarities between all pairs of samples'

plot(dat.mds$points, type = "n", 
     xlab='1st dimension of the fitted configuration', 
     ylab='2nd dimension of the fitted configuration')

points(dat.mds$points[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]],
       dat.mds$points[,2][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
       col=col[1],pch=16,cex=1.5)

text(dat.mds$points[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
     dat.mds$points[,2][ as.character(ann$site)==levels(as.factor(ann$site))[1]],
     col=col[1], cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[1], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[1],]), sep= ' '), 
     pos=2)

points(dat.mds$points[,1][ as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       dat.mds$points[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       col=col[2],pch=16,cex=1.5)

text(dat.mds$points[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]], 
     dat.mds$points[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
     col=col[2],cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[2], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[2],]), sep= ' '), 
     pos=2)

title(main=paste('MDS plot of Sotiriou breast cancer data', ' - stress = ', 
                 round(dat.mds$stress,5), '%'))

legend(min(range(dat.mds$points[,1])), max(range(dat.mds$points[,2]) ), 
       levels(as.factor(ann$site)),
       col=col,pch=16,cex=.75)


#' 
#' ## Non-linear Dimensionality Reduction
#' 
#' ## Weighted Graph Laplacian
#' 
#' Determines the subspace that best preserves local distances and minimizes large distances
#' Does not calculate linear projections of the data (e.g. MDS & PCA)
#' 
#' Builds a graph from neighborhood information of the data set
#' 
#' Each data point serves as a vertex (node) on the graph and 
#' connectivity between vertices is governed by the proximity of neighboring points (edge weights)
#' 
#' The graph thus generated can be considered as a discrete approximation of the low-dimensional manifold in the high-dimensional space
#' 
#' Minimization of a cost function based on the graph ensures that points close to each other on the manifold 
#' are mapped close to each other in the low-dimensional space, preserving local distances
#' 
#' Distances are calculated between each pair of genes/samples
#' 
#' Each pair of vertices is assigned a weight specific to the distance between them
#' 
#' A kernel is implemented to transform the distances to a predefined function (cells in adjacency matrix)
#' 
#' The Laplacian operator decomposes the adjacency matrix
#' 
## --------------------------------------------------------------------------------------------------------------------------------
k.speClust2 <- function (X, qnt=NULL) {
  
	dist2full <- function(dis) {
		      n <- attr(dis, "Size")
	        full <- matrix(0, n, n)
	        full[lower.tri(full)] <- dis
	        full + t(full)
	}
	
	#squared Euclidean distances between all pairs of samples
	dat.dis <- dist(t(X),"euc")^2   
	
	if(!is.null(qnt)) {eps <- as.numeric(quantile(dat.dis,qnt))}
	if(is.null(qnt)) {eps <- min(dat.dis[dat.dis!=0])}
	
	# a radial basis function (RBF) kernel to transform the distances
	# the RBF kernel decreases with distance, ranges from 0 to 1 (identity), and 
	# is readily interpreted as a similarity measure
	kernel <- exp(-1 * dat.dis/(eps))
	
	# calculate the adjacency matrix K1 - square matrix with elements indicating 
	# whether pairs of vertices are adjacent or not in the graph
	K1 <- dist2full(kernel)
	diag(K1) <- 0
	
	# calculate the degree matrix D - diagonal matrix calculated from the row sums of K1
	# contains information about the degree of each vertex 
	# (i.e. the number of edges attached to each vertex)
	D = matrix(0,ncol=ncol(K1),nrow=ncol(K1))
	tmpe <- apply(K1,1,sum)
	tmpe[tmpe>0] <- 1/sqrt(tmpe[tmpe>0])
	tmpe[tmpe<0] <- 0
	diag(D) <- tmpe
	
	# calculate the normalized Laplacian
	L <- D%*% K1 %*% D
	
	# calculate eigenvectors by single value decomposition of the Laplacian and
	# place as columns of matrix X
	X <- svd(L)$u
	
	# scale the rows of matrix X to unit length and place in matrix Y
	# can then create n-dimensional embedding of data utilizing the first n columns of the matrix Y
	Y <- X / sqrt(apply(X^2,1,sum))
}


#' 
#' ## Plot a two-dimensional embedding of the weighted graph Laplacian
#' 
## ---- fig.height=8---------------------------------------------------------------------------------------------------------------
# center and scale the rows of the data matrix 
dat.t.c.s <- t(dat)
dat.t.c.s <- scale(dat.t.c.s, center=T, scale=T) 

# conduct spectral graph dimensionality reduction
phi <- k.speClust2(t(dat.t.c.s), qnt=NULL)
#phi

#plot
col <- as.numeric(as.factor(unique(ann$site))) +1

plot(range(phi[,1]),range(phi[,2]),
     xlab="phi1",ylab="phi2",
     main="Weighted Graph Laplacian plot of Sotiriou breast cancer data")

points(phi[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]],
       phi[,2][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
       col=col[1],pch=16,cex=1.5)

text(phi[,1][as.character(ann$site)==levels(as.factor(ann$site))[1]], 
     phi[,2][ as.character(ann$site)==levels(as.factor(ann$site))[1]],
     col=col[1],cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[1], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[1],]), sep= ' '), 
     pos=2)

points(phi[,1][ as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       phi[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]], 
       col=col[2],pch=16,cex=1.5)

text(phi[,1][as.character(ann$site)==levels(as.factor(ann$site))[2]], 
     phi[,2][ as.character(ann$site)==levels(as.factor(ann$site))[2]],
     col=col[2],cex=0.7, 
     labels= paste(levels(as.factor(ann$site))[2], '-',
                   row.names(ann[as.character(ann$site)==levels(as.factor(ann$site))[2],]), sep= ' '), 
     pos=2)

legend(min(range(phi[,1])), max(range(phi[,2])-0.5), 
       levels(as.factor(ann$site)),col=col,pch=16,cex=.75)


