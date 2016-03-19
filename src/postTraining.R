# Post prediction testing and debugging
################# Model Selection ##################


################# Learning Curves  #################
mlimit=100
trainingError=rep(0,mlimit)
validationError=rep(0,mlimit)

for (m in 1:mlimit){
   trainingSubset<-trainingSet[1:m,]
   model <- randomForest(trainingSubset[,3:34], trainingSubset$Hazard, ntree=10, imp=TRUE, sampsize=m, do.trace=FALSE)
   trainingPredict<-predict(model,testSet[,3:34])
   validationPredict<-predict(model,cvSet[,3:34])
   
   trainingError[m]<-meanSqError(trainingPredict,trainingSubset$Hazard)#training error on subset
   validationError[m]<-meanSqError(validationPredict,cvSet$Hazard)#validation error on entire cvSet
}
plot(x=1:mlimit,y=trainingError,ylim=c(-.01,.01),type="o")
lines(x=1:mlimit,y=validationError)
