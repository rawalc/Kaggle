# Kaggle_LibertyMutual


- Folder /src contains the code
  Change the working directory within the Random Forest script and run it to obtain results
  The random forest script calls helperFunctions.R and dataPrep.R files. So look at them first to understand all functions and data preparation

- folder /data contains the training set and test set needed for prediction. 

Task: We need to predict unknown "Hazards" in the test set based on a model trained with training set - these are 2 separate .csv files we have
  The training set contains a "Hazard column"
  The test set is not provided with "Hazard" column" - we need to predict these correctly
  More details are here: https://www.kaggle.com/c/liberty-mutual-group-property-inspection-prediction
  
The greater the hazard, the more Liberty Mutual wants to charge clients. 
Features: No context is given on the features. Therefore make the best judgement on feature selection based on data.

