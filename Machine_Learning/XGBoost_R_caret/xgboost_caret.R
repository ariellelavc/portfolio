## ----setup, include=FALSE------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- message=FALSE------------------------------------------------------------------------------------------------------------
library(xgboost)
library(caret)
library(Matrix)
library(dplyr)
library(ggplot2)


## ------------------------------------------------------------------------------------------------------------------------------
iris <- read.csv("./iris.csv")


## ------------------------------------------------------------------------------------------------------------------------------
train_index <- caret::createDataPartition(iris$Species, p=0.8, list = FALSE)
train_set <- iris[train_index,] # Training Set
test_set <- iris[-train_index,] # Test Set

write.csv(train_set, "trainset.csv")
write.csv(test_set, "testset.csv")


## ------------------------------------------------------------------------------------------------------------------------------
train_set <- read.csv("trainset.csv", header = TRUE)
head(train_set)
train_set <- train_set[,-1]
train_set$Species <- factor(train_set$Species)

test_set  <- read.csv("testset.csv", header = TRUE)
test_set <- test_set[,-1]
test_set$Species <- factor(test_set$Species)


## ------------------------------------------------------------------------------------------------------------------------------
trainset_labels <- train_set$Species
trainset_labels_num <- as.integer(train_set$Species) - 1
trainset_mat <- Matrix(as.matrix(train_set[, -length(train_set)]), sparse = TRUE)
dim(trainset_mat)

testset_labels <- test_set$Species
testset_labels_num <- as.integer(test_set$Species) - 1
testset_mat <- Matrix(as.matrix(test_set[, -length(test_set)]), sparse = TRUE)
dim(testset_mat)

model <- xgboost( data = trainset_mat, label=trainset_labels_num, 
                  max_depth=2, eta=1, nthread=2, nrounds=20, 
                  num_class = 3, objective="multi:softprob", eval_metric="mlogloss")


## ------------------------------------------------------------------------------------------------------------------------------
pred <- predict(model, testset_mat)
pred <- matrix(pred, nrow=30, byrow = TRUE)
pred
# or
# dim(pred) <- c(3, 30)
# pred <- t(pred)


## ------------------------------------------------------------------------------------------------------------------------------
xgbpred <- as.data.frame(ifelse(pred > 0.5, 1, -1)) 
xgbpred$pred <- if_else(xgbpred$V1==1, 0, -1)
xgbpred$pred2 <- if_else(xgbpred$V2==1, 1, xgbpred$pred)
xgbpred$pred3 <- if_else(xgbpred$V3==1, 2, xgbpred$pred2)


## ------------------------------------------------------------------------------------------------------------------------------
caret::confusionMatrix(factor(xgbpred$pred3), factor(testset_labels_num))
cm <- caret::confusionMatrix(factor(xgbpred$pred3), factor(testset_labels_num))
plt <- as.data.frame(cm$table)
plt$Prediction <- factor(plt$Prediction, levels=rev(levels(plt$Prediction)))

ggplot(plt, aes(Prediction, Reference, fill= Freq)) +
  geom_tile() + 
  geom_text(aes(label=Freq)) +
  scale_fill_gradient(low="white", high="#009194") + 
  theme_light()
  


## ------------------------------------------------------------------------------------------------------------------------------
importance_mat <- xgb.importance(feature_names = colnames(trainset_mat), model = model)
xgb.plot.importance(importance_matrix = importance_mat)


## ------------------------------------------------------------------------------------------------------------------------------
saveRDS(model, "xgboost_model.rds")


## ------------------------------------------------------------------------------------------------------------------------------
sessionInfo()

