# Set working directory for course project
setwd("/Users/smilingtaki/Desktop/Coursera/D3-Getting and Cleaning Data/Weeek 4-Course Project/UCI HAR Dataset2")

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")

# Unzip downloaded dataset to data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Load required packages
library(dplyr)
library(data.table)
library(tidyr)

# Merging the trainning and the test sets to create one dataset
# 2.1- Read files
# 2.1.1-Read the training tables
datapath <- ("/Users/smilingtaki/Desktop/Coursera/D3-Getting and Cleaning Data/Weeek 4-Course Project/UCI HAR Dataset")
x_train <- read.table(file.path(datapath, "train", "x_train.txt"))
y_train <- read.table(file.path(datapath, "train", "y_train.txt"))
subject_train <- read.table(file.path(datapath, "train", "subject_train.txt"))

# 2.1.2-Read testing tables
x_test <- read.table(file.path(datapath, "test", "x_test.txt"))
y_test <- read.table(file.path(datapath, "test", "y_test.txt"))
subject_test <- read.table(file.path(datapath, "test", "subject_test.txt"))

# 2.1.3-Read the features
features <- read.table(file.path(datapath, "features.txt"))

# 2.1.4-Read activity labels
activityLabels = read.table(file.path(datapath, "activity_labels.txt"))

# 2.2-Rename columns names
colnames(x_train) <- features[,2]
colnames(y_train) <- "ActivityID"
colnames(subject_train) <- "SubjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "ActivityID"
colnames(subject_test) <- "SubjectID"

colnames(activityLabels) <- c("ActivityID","ActivityType")

# 2.3- Merge data into one dataset
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
mergeAll <- rbind(merge_train, merge_test)

# 3-Extracts only the measurements on the mean and standard deviation for each measurement
# 3.1-Read column names
colNames <- colnames(mergeAll)

# 3.2- Rename dataset into required ID, mean and std
MeanStd <- (grepl("ActivityID", colNames)|
            grepl("SubjectID", colNames)|
            grepl("mean..", colNames)|
            grepl("std..", colNames)
            )

# 3.3- Create subset from MergeAll
subset_MeanStd <- mergeAll[, MeanStd == TRUE]

# 4-Use variable means sorted by subject and activity to create datatable 
subset_ActivityNames <- merge(subset_MeanStd, activityLabels, by= "ActivityID", all.x=TRUE)

head(str(subset_ActivityNames),2)

# 5 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# 5.1-Create second tify dataset
AggreTidyData <- aggregate(. ~SubjectID + ActivityID, subset_ActivityNames, mean)
TidyData <- AggreTidyData[order(AggreTidyData$SubjectID, AggreTidyData$ActivityID),]

# Write and save clear and tidy data into TidyData.txt and save it in working directory
write.table(TidyData, "TidyData.txt", row.names = FALSE)
