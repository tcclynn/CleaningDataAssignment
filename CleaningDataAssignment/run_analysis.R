library(plyr)
library(dplyr)


subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- c("SubjectID")

#Read in activity labels
activity_label <- read.table("./UCI HAR Dataset//activity_labels.txt",
                             stringsAsFactor = FALSE)
colnames(activity_label) <- c("ActivityID","Activity Label")


#Read in features and extract the index for feature names that contain "mean" or "std"
features <- read.table("./UCI HAR Dataset//features.txt",
                       stringsAsFactor = FALSE)
MeanStd <- grep("mean|std",features[,2],ignore.case = TRUE)


X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
# Select measurements where columns have either mean or std 
X_test <- X_test[c(MeanStd)]
# Assign column names with their corresponding feature measurement description 
colnames(X_test) <- gsub("\\(|\\)|\\-","",features[MeanStd,2])


Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(Y_test) <- c("ActivityID")


# Look up acivity label for each row in Y_test
# and return the activity label only
ActivityDesc <- join(Y_test,activity_label, by = "ActivityID")[,2]

test <- cbind(subject_test, ActivityDesc, X_test)


subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- c("SubjectID")


X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
# Select measurements where columns have either mean or std 
X_train <- X_train[c(MeanStd)]
# Assign column names with their corresponding feature measurement description 
colnames(X_train) <- gsub("\\(|\\)|\\-","",features[MeanStd,2])


Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(Y_train) <- c("ActivityID")


# Look up acivity label for each row in Y_test
# and return the activity label only
ActivityDesc <- join(Y_train,activity_label, by = "ActivityID")[,2]


train <- cbind(subject_train, ActivityDesc, X_train)


# First tidy data. Merges the training and test data sets 
Experiments <- rbind(train,test)
AverageColNames <- paste0("Average",names(X_train))
names(Experiments) <- c("SubjectID","ActivityDesc",AverageColNames)

# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject. Write the summary tidy data to file
SummaryExperiments <- Experiments %>%
                        group_by(SubjectID,ActivityDesc) %>%
                        summarise_each(funs(mean))
write.table(SummaryExperiments, "./TidyDataAverage.txt", row.names = FALSE)

