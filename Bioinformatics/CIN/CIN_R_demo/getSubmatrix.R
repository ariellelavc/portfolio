# Generate submatrix based on sample IDs
getSubmatrix.twogrps <- function(datmat, grp1ids, grp2ids) {
	allids <- dimnames(datmat)[[2]]
	if (length(dimnames(datmat)[[1]])==1) {
	Submatrix <- t(as.matrix(c(datmat[,allids%in%grp1ids],datmat[,allids%in%grp2ids])))
	dimnames(Submatrix)[[1]] <- dimnames(datmat)[[1]]
	}
	else {
    	Submatrix <- cbind(datmat[,allids%in%grp1ids],datmat[,allids%in%grp2ids])
	}
    	return(as.matrix(Submatrix))
}

# Submatrix <- getSubmatrix.twogrps(datmat, grp1ids, grp2ids)  
