rm(list = ls())
###################### setup #########################
require(xgboost)
require(Matrix)
require(data.table)

library(ggplot2)
library(randomForest)
library(DAAG)

setwd("C:/Users/rawalc/Documents/Kaggle/Kaggle_LibertyMutual")
source("./src/helperFunctions.R")
source("./src/dataPrep.R")

############### Training ##############

labels<-trainingSet$Hazard
features<-sparse.model.matrix(~.-1 ,data=trainingSet[,3:34])
testSetFeatures<-sparse.model.matrix(~.-1,testSet[,3:34])
testSetLabels<-testSet$Hazard

cat("Training model\n")
# Basic way to run xgBoost
# set.seed(2)
# model<-xgboost(data=features,label=labels,max.depth=5,eta=1,
#                nthread=2,nround=5,objective="reg:linear",verbose=1)

######## Advanced way to run xgBoost ###########
detailedTrain<-xgb.DMatrix(data=features,label=labels)
detailedTestSet<-xgb.DMatrix(data=testSetFeatures,label=testSetLabels)
watchlist <- list(train=detailedTrain, test=detailedTestSet)

set.seed(2)
params <- list(eta=0.01, max.depth=7, min_child_weight = 6,
               subsample=0.8, 
               objective = "reg:linear", nthread = 4, verbose=1)

model<-xgb.train(data=detailedTrain,nrounds=2000, params=params,watchlist=watchlist)
#               eta=0.1, nthread=4,nround=50,objective="reg:linear", verbose=1)

############ Trying a different objective function ############
# ## Copied from https://github.com/dmlc/xgboost/blob/master/R-package/demo/custom_objective.R
# 
# logregobjective <- function(preds, dtrain) {
#   labels <- getinfo(dtrain, "label")
#   preds <- 1/(1 + exp(-preds))
#   grad <- preds - labels
#   hess <- preds * (1 - preds)
#   return(list(grad = grad, hess = hess))
# }
# 
# params=list(booster="gbtree",objective=logregobjective)
# 
# model<-xgb.train(data=detailedTrain,max.depth=5,eta=0.1,
#                  nthread=4,nround=150,
#                  watchlist=watchlist, params=params, verbose=1)

  ############## Predictions #############

cat("Making predictions for unlabelled data\n")
unknownDataFeatures<-sparse.model.matrix(~.-1,unknownData[,2:33])
submission <- data.frame(Id=unknownData$Id)
submission$Hazard <- predict(model, unknownDataFeatures)
write_csv(submission, "submission8.csv")

# cat("Plotting variable importance\n")
# imp <- importance(rf, type=1)
# featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])
# varImpPlot(rf)

######################## Feature Importance #######################
importance_matrix <- xgb.importance(features@Dimnames[[2]], model = model)
xgb.plot.importance(importance_matrix)
# save.image()