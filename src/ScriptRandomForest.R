rm(list = ls())
###################### setup #########################
library(ggplot2)
library(randomForest)
library(readr)
library(DAAG)

setwd("C:/Users/rawalc/Documents/Kaggle/Kaggle_LibertyMutual")
source("./src/helperFunctions.R")
source("./src/dataPrep.R")


############### Training ##############
 
  cat("Training model\n")
  set.seed(2)
  rf <- randomForest(trainingSet[,3:34], trainingSet$Hazard, 
                     ntree=50, imp=TRUE, sampsize=1000)
  plot(rf)
  ############## Predictions and Errors #############
  cat("Making predictions for training and test sets")
  trainingSetPredict<-predict(rf,trainingSet[,3:34])
  testSetPredict<-predict(rf,testSet[,3:34])

  # Convert predictions to numeric
  # trainingPredict<-as.numeric(levels(trainingPredict))[trainingPredict]
  # testPredict<-as.numeric(levels(testPredict))[testPredict]
  # trainingSet$Hazard<-as.numeric(levels(trainingSet$Hazard))[trainingSet$Hazard]
  # testSet$Hazard<-as.numeric(levels(testSet$Hazard))[testSet$Hazard]
  
  trainingError = meanSqError(trainingSetPredict,trainingSet$Hazard)
  testError = meanSqError(testSetPredict,testSet$Hazard)
cat(" Training Error: ", trainingError, "\n", "Test Error: ", testError)
# plot(x=1:nrow(trainingSet),y=trainingPredict-trainingSet$Hazard) #residuals plot


cat("\n Making predictions for unlabelled data\n")
submission <- data.frame(Id=unknownData$Id)
submission$Hazard <- predict(rf, unknownData[,2:33])
write_csv(submission, "submission4.csv")

# cat("Plotting variable importance\n")
# imp <- importance(rf, type=1)
# featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])
varImpPlot(rf)

######################## Save Workspace #######################
save.image()