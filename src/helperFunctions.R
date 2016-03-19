extractFactors <- function(data,num2categoricalFlag=0) {
  # convert all the characters to factors
  character_cols <- names(Filter(function(x) x=="character", sapply(data, class)))
  for (col in character_cols) {
    data[,col] <- as.factor(data[,col])
  }
  
  # Also convert all numeric variables with whole numbers into categorical arrays
    if (num2categoricalFlag==1) {
    for (col2 in names(data)) {
      if (is.numeric(data[,col2]) 
          && all(data[,col2]%%1 == 0) 
          && length(levels(as.factor(data[,col2])))<=10) { #convert only if less than 10 levels
        data[,col2] <- as.factor(data[,col2])
      }
    }
  }
  return(data)
}

################################################################

# split data into cross-validation, test sets
splitData <- function(data) {
#   cvCount = floor(nrow(data)*0.2);
  cvCount=1 #no cross Validation set
  testCount = floor(nrow(data)*0.1);
  
#   dataSample <- sample(data, size=nrow(data), replace=FALSE)
  cvSet <- data[1:cvCount,]
  testSet<- data[(cvCount+1):(cvCount+testCount),]
  trainingSet<- data[(cvCount+testCount+1):nrow(data),]
  list(trainingSet,cvSet,testSet)
  
}

################################################################

meanSqError <-function(prediction,actualResponse) {
  mse = sum((prediction-actualResponse)^2)/(length(prediction))
}

################################################################
# 
# learningCurves <- function(errorCV, errorTrain, sampleSize) {
#   
#   ylimits = c(min(errorCV,errorTrain)-1,max(errorCV,errorTrain)+1)
#   plot(y=errorCV,x=sampleSize,type="l",ylim=1:ylimits)
#   lines(y=errorTrain,x=1:sampleSize)
# }