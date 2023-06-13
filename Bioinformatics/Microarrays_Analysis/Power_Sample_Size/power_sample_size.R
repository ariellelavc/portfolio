## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------------------------------------------------------------------------
dat <- read.table('./agingStudy11FCortexAffy.txt', header=T, row.names=1)
dim(dat)

dat[1:5,]

## -----------------------------------------------------------------------------------------------------------------------------------------------
dat <- as.data.frame(scale(dat))
dat[1:5,]


## -----------------------------------------------------------------------------------------------------------------------------------------------
ann <- read.table('./agingStudy1FCortexAffyAnn.txt', header=T, row.names=1)
dim(ann)
ann


## -----------------------------------------------------------------------------------------------------------------------------------------------
names(dat) <- substr(names(dat),1,8)


## -----------------------------------------------------------------------------------------------------------------------------------------------
o <- row.names(ann[ann$Age >=50,]); y <- row.names(ann[ann$Age < 50,])
o; y


## -----------------------------------------------------------------------------------------------------------------------------------------------
o.1 <- as.numeric(dat[8822, o])
y.1 <- as.numeric(dat[8822, y])

o.1; y.1


## -----------------------------------------------------------------------------------------------------------------------------------------------
# box plot
oy1.list <- list(o.1, y.1)
boxplot(oy1.list, col=c('red','blue'), names = c('age >= 50','age < 50'), main='Gene #1')


## -----------------------------------------------------------------------------------------------------------------------------------------------
boxplot(oy1.list, col=c('red','blue'), names = c('age >= 50','age < 50'), main='Gene #1', plot = FALSE)


## -----------------------------------------------------------------------------------------------------------------------------------------------
par(mfrow=c(2, 1))

xname<-"Gene #1 - Age >= 50"
hist(o.1,col='red', main=paste("Histogram of" , xname), xlab=xname, 
     labels = TRUE, freq = FALSE, axes = FALSE, col.lab='red', col.main='red')
axis(side=1, col='red', col.axis='red')
axis(side=2, col='red', col.axis='red')

xname<-"Gene #1 - Age < 50"
hist(y.1,col='blue', main=paste("Histogram of" , xname), xlab=xname, 
     labels = TRUE, freq = FALSE, axes = FALSE, col.lab='blue', col.main='blue')
axis(side=1, col='blue', col.axis='blue')
axis(side=2, col='blue', col.axis='blue')



## -----------------------------------------------------------------------------------------------------------------------------------------------
par(mfrow=c(2, 1))

xname<-"Gene #1 - Age >= 50"
hist(o.1,col='red', main=paste("Histogram of" , xname), xlab=xname, 
     labels = TRUE, axes = FALSE, col.lab='red', col.main='red')
axis(side=1, col='red', col.axis='red')
axis(side=2, col='red', col.axis='red')

xname<-"Gene #1 - Age < 50"
hist(y.1,col='blue', main=paste("Histogram of" , xname), xlab=xname, 
     labels = TRUE, axes = FALSE, col.lab='blue', col.main='blue')
axis(side=1, col='blue', col.axis='blue')
axis(side=2, col='blue', col.axis='blue')


## -----------------------------------------------------------------------------------------------------------------------------------------------
xname<-"Gene #1 - Age >= 50"
hist(o.1, plot = FALSE)


## -----------------------------------------------------------------------------------------------------------------------------------------------
xname<-"Gene #1 - Age < 50"
hist(y.1, plot = FALSE)


## -----------------------------------------------------------------------------------------------------------------------------------------------
o.1.sd <- sd(o.1)
y.1.sd <- sd(y.1)
max <- max(o.1.sd, y.1.sd)
o.1.sd; y.1.sd; max


## -----------------------------------------------------------------------------------------------------------------------------------------------
min.ssize <- ceiling(power.t.test(delta=log2(1.5),
                                  sd=max, 
                                  sig.level=1-0.99,
                                  power=.8)$n)
min.ssize


## -----------------------------------------------------------------------------------------------------------------------------------------------
power.t.test(delta=log2(1.5), sd=max, sig.level=1-0.99,power=.8)


## -----------------------------------------------------------------------------------------------------------------------------------------------
n <- min(length(o.1),length(y.1))
n

power <- round(
  power.t.test(n=n, delta=log2(2), sd=max, sig.level=1-0.99)$power*100, 2)
power


## ---- message=FALSE, warning=FALSE--------------------------------------------------------------------------------------------------------------
library(ssize)
library(gdata)


## -----------------------------------------------------------------------------------------------------------------------------------------------
dat.sd <- apply(dat, 1, sd)
genes.no <- length(dat.sd)
hist(dat.sd, breaks=20, col="cyan", border="blue", main="", 
     xlab=" Standard deviation for data on the log scale ", labels=TRUE) 
dens <- density(dat.sd) 
dens
lines(dens$x, dens$y*par("usr")[4]/max(dens$y),col="red",lwd=2) 
title(main = paste("Histogram of Standard Deviations for",genes.no, "genes"))

## ---- fig.height=6, fig.width=12----------------------------------------------------------------------------------------------------------------
fold.change=3.0; power=0.8; sig.level=0.05;

all.size <- ssize(sd=dat.sd, delta=log2(fold.change), 
                  sig.level=sig.level, power=power)
ssize.plot(all.size, lwd=2, col="blue", xlim=c(1,20)) 
xmax <- par("usr")[2]-1; 
ymin <- par("usr")[3] + 0.05 
legend(x=xmax, y=ymin, 
       legend= strsplit(paste("fold change=",fold.change,",", 
                                               "alpha=", sig.level, ",", 
                                               "power=",power,",", "# genes=", 
                              length(dat.sd), sep=''), "," )[[1]], 
       xjust=1, yjust=0, cex=1.0) 
title("Sample Size to Detect 3-Fold Change")


## ---- fig.width=8-------------------------------------------------------------------------------------------------------------------------------
par(mfrow=c(1,2))
ssize.plot(all.size, lwd=2, col="blue", xlim=c(1,20),marks=5) 
xmax <- par("usr")[2]-1; 
legend(x=xmax, y=0, 
       legend= strsplit( paste("fold change=",fold.change,",", 
                               "alpha=", sig.level, ",", "power=",power,",", 
                               "# genes=", length(dat.sd), sep=''), "," )[[1]], 
       xjust=1, yjust=0, cex=1.0) 
title("Detail ssize = 5")

ssize.plot(all.size, lwd=2, col="blue", xlim=c(1,20), marks=6) 
xmax <- par("usr")[2]-1; 
legend(x=xmax, y=0, 
       legend= strsplit( paste("fold change=",fold.change,",", 
                               "alpha=", sig.level, ",", "power=",power,",", 
                               "# genes=", length(dat.sd), sep=''), "," )[[1]], 
       xjust=1, yjust=0, cex=1.0) 
title("Detail ssize = 6")


## ---- fig.height=6, fig.width=12----------------------------------------------------------------------------------------------------------------
fold.change=3.0; power=0.8; sig.level=0.05; n=4
all.power <- pow(sd=dat.sd, n=n, delta=log2(fold.change), sig.level=sig.level)
power.plot(all.power, lwd=2, col="green") 
xmax <- par("usr")[2] -0.05; 
ymin <- par("usr")[4] -0.05
legend(x=xmax, y=ymin, 
       legend= strsplit( paste("n=",n,",","fold change=",fold.change,",", 
                               "alpha=", sig.level, ",", 
                               "# genes=", length(dat.sd), sep=''), "," )[[1]], 
       xjust=1, yjust=1, cex=1.0) 
title("Power to Detect 3-Fold Change")

