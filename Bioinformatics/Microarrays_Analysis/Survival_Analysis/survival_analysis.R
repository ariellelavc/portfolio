## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------------------------------------------------------------------------
x <- c(0:5)
y.a <- seq(from=1,to=.5,length=6)
y.b <- c(1,.7,.56,.52,.52,.5)

plot(c(0,5), c(0,1), type='n', xlab='Follow-up Time (years)', ylab='Survival probability', 
     main='Survival experience for groups A and B')
lines(x, y.a, col='red', lwd=2)
points(x, y.a, col='red', cex=1.5)
lines(x, y.b, col='blue', lwd=2)
points(x, y.b, col='blue', cex=1.5)


## -----------------------------------------------------------------------------------------------------------------------------------------------
plot(c(0,12),c(1,6),axes=FALSE,xlab="Weeks",ylab="Patients",type="n")
axis(side=2,at=c(1:6),labels=c("P1","P2","P3","P4","P5","P6"))
axis(side=1,at=seq(0,12,2),labels=c("0","2","4","6","8","10","12"))

#P6 - experiences event
lines(c(0:5),rep(6,6)); points(5,6,cex=1.5,pch="X");

#P5 - has censored survival time; study ends
lines(c(0:12),rep(5,13)); points(12,5,cex=1.5,pch="O");

#P4 - has censored survival time; withdrawn from study
lines(c(4:6),rep(4,3)); points(6,4,cex=1.5,pch="O");

#P3 - has censored survival time; study ends
lines(c(5:12),rep(3,8)); points(12,3,cex=1.5,pch="O");

#P2 - has censored survival time; lost
lines(c(4:10),rep(2,7)); points(10,2,cex=1.5,pch="O");

#P1 - experiences event
lines(c(9:12),rep(1,4)); points(12,1,cex=1.5,pch="X");

abline(v=12,lty=2) # end of study marker


## -----------------------------------------------------------------------------------------------------------------------------------------------
library(survival); library(splines);


## -----------------------------------------------------------------------------------------------------------------------------------------------
surv <- data.frame(c(0,6,6,6,6,7,7,10,10,10,13,16,16,16,16,22,23,23,23,23,23,23),
                c(0,1,1,1,0,1,0,1,0,0,1,1,0,0,0,1,1,0,0,0,0,0))
names(surv) <- c('time', 'status')
surv$x <- 'remission'
surv


## -----------------------------------------------------------------------------------------------------------------------------------------------
f <- survfit(Surv(time, status) ~ x, type= 'kaplan-meier', data = surv)
summary(f)


## -----------------------------------------------------------------------------------------------------------------------------------------------
plot(f, lwd=2, xlab='Weeks', ylab='S_hat(t)', main='KM Plots for Remission data')


## ---- warning=FALSE, message=FALSE--------------------------------------------------------------------------------------------------------------
#install.packages("survminer")
library(survminer)

ggsurvplot(f, linetype = "strata", conf.int = TRUE, pval = TRUE, palette = "Dark2")


## -----------------------------------------------------------------------------------------------------------------------------------------------
survdiff(Surv(time, status) ~ x, data = aml)


## -----------------------------------------------------------------------------------------------------------------------------------------------
leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml)
plot(leukemia.surv, lty = 2:3,xlab="Weeks",ylab="S(t)",col=c("red", "blue"))
legend(100, .9, c("Maintenance", "No Maintenance"), lty = 2:3, col=c("red", "blue"))
title("Kaplan-Meier Curves - AML Maintenance Study")


## -----------------------------------------------------------------------------------------------------------------------------------------------
ggsurvplot(leukemia.surv, linetype = "strata", conf.int = FALSE, pval = TRUE, 
           risk.table = TRUE, risk.table.y.text.col = TRUE, risk.table.y.text = FALSE,
           risk.table.height = 0.25, risk.table.col = "strata",
           break.time.by = 20,
           ggtheme = theme_bw(),  
           palette = c("red", "blue"))


## -----------------------------------------------------------------------------------------------------------------------------------------------
fit <- coxph( Surv(time,status)~x,data=aml)
summary(fit)


## -----------------------------------------------------------------------------------------------------------------------------------------------
plot(survfit(fit),xlab="Weeks",ylab="S(t)",main="Cox PH model predicted value - AML data")


## -----------------------------------------------------------------------------------------------------------------------------------------------
ggsurvplot(survfit(fit, data=aml), conf.int = TRUE, palette = "Dark2")

