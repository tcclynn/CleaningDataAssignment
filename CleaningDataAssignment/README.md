---
title: "README.md"
author: "Ching Ching Tan"
date: "Thursday, April 23, 2015"
output: html_document
---

**Summary:** The source data sets contain experiments that have been carried out on 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The assignment is to merge a training and a test data set then using the merged data set to create an independent tidy data set with the average of each variable for each activity and each subject is tabulated and saved to TidyDataAverage.txt.

**To run the script:** On the R console type *"source("run_analysis.R")"*

**Pre-requisites:** The Samsung data is in the working directory

**This report describes how the run_analysis script works:**

Firstly, it reads the "activity labels.txt"" and features.txt.

The activity label is required to convert activity codes in the raw data file to descriptive activity names 

```{r}
> activity_label
  ActivityID    Acitivity Label
1          1            WALKING
2          2   WALKING_UPSTAIRS
3          3 WALKING_DOWNSTAIRS
4          4            SITTING
5          5           STANDING
6          6             LAYING
```

The assignment is asking for the measurements on the mean and standard deviation for each measurement. The return result is the index for measurements that will be extracted later for test and training

```{r}
features <- read.table("./UCI HAR Dataset//features.txt",
                       stringsAsFactor = FALSE)
MeanStd <- grep("mean|std",features[,2],ignore.case = TRUE)
```

To prepare the tidy data set for test and training:

1. Read in the data files:subject, X(experiments/features) and y(activity labels)

2. Select columns from x for the measurements on mean and standard deviation
```{r}
# Select measurements where columns have either mean or std 
X_test <- X_test[c(MeanStd)]
```

3. Look up and return the activity description for each activity label  
```{r}
  ActivityDesc <- join(Y_test,activity_label, by = "ActivityID")[,2]
```
  
4. Join the desired columns from the source data files and processed data using cbind
```{r}
test <- cbind(subject_test, ActivityDesc, X_test)
```

Repeat the same steps for training data set

Combine the tidy data set for test and training
```{r}
Experiments <- rbind(train,test)
```

Format and assign descriptive variable names i.e. Append "Average" 
and remove special characters: "(,),-"
```{r}
AverageColNames <- paste0("Average",names(X_train))
names(Experiments) <- c("SubjectID","ActivityDesc",AverageColNames)
```

Create a second, independent tidy data set with the average of each variable 
for each activity and each subject. Write the summary tidy data to file
```{r}
SummaryExperiments <- Experiments %>%
                        group_by(SubjectID,ActivityDesc) %>%
                        summarise_each(funs(mean))
write.table(SummaryExperiments, "./TidyDataAverage.txt", row.names = FALSE)
```