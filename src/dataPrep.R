library(readr)
#################### Read Data ###################
cat("Reading data\n")
train <- read_csv("./data/train.csv")
unknownData <- read_csv("./data/test.csv")

train<-extractFactors(train,num2categoricalFlag=0) #extractFactors is in helperFuncitons.R
unknownData<-extractFactors(unknownData,num2categoricalFlag=0)
# sapply(sapply(train,levels),length) #returns number of levels in each cat array

#Balance out data by removing some rows with Hazard==1
# sampleofOnes = train[train$Hazard==1,]
# train = train[train$Hazard>1,]#dataframe "train" only contains rows in which Hazard>1
# train<-rbind(train,sampleofOnes[1:5000,])
# rm(sampleofOnes)

#Remove outliers. Anything with value greater than 30
train <- train[train$Hazard<30,]
#convert response variable to categorical variable
# train$Hazard<-as.factor(train$Hazard)
# train <- train[sample(nrow(train)),]

#split data into training, cross-validation and test sets
newData <- splitData(train)
trainingSet<-newData[[1]]
cvSet<-newData[[2]]
testSet<-newData[[3]]
rm(newData)