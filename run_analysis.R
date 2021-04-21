#' Peer-graded Assignment: Getting and Cleaning Data Course Project Week 4
#' By: Melissa Rountree
#' There are 5 programming assignments requirements as described in the course
#' project’s instructions:
#' 1) Merges the training and the test sets to create one data set.
#' 2) Extracts only the measurements on the mean and standard deviation for 
#' each measurement.
#' 3) Uses descriptive activity names to name the activities in the data set
#' 4) Appropriately labels the data set with descriptive variable names.
#' 5) From the data set in step 4, creates a second, independent tidy data set 
#' with the average of each variable for each activity and each subject.
--------------------------------------------------------------------------------
## Clean memory
gc()
rm(list = ls())

## Package library
library(dplyr)

## Import and extract the dataset
## Data URL
url <- paste0(
  "https://d396qusza40orc.cloudfront.net/",
  "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
)

## Data Location
dest_loc <- paste0(
  "/Users/mrountree5/Desktop/Coursera/Getting and Cleaning Data/",
  "Programming Assignment Wk4/Data/UCI HAR Dataset/"
)

## Data set Name
dest_name <- "/dataset.zip"

## Checking if location of the files and folder exists
if (!file.exists(dest_loc)){
  if (!file.exists(dest_name)) { 
  download.file(url, dest_name, method = "curl")
}  

## Unzip/extract files
  unzip(dest_name) 
}

## Import test data and assign to data frames
test_data <- read.table(file.path(dest_loc, 'test', 'X_test.txt'), 
                        header = FALSE)
test_activities <- read.table(file.path(dest_loc, 'test', 'y_test.txt'), 
                              header = FALSE)
test_subjects <- read.table(file.path(dest_loc, 'test', 'subject_test.txt'), 
                            header = FALSE)
## Import train data and assign to data frames
train_data <- read.table(file.path(dest_loc, 'train', 'X_train.txt'), 
                         header = FALSE)
train_activities <- read.table(file.path(dest_loc, 'train', 'y_train.txt'), 
                               header = FALSE)
train_subjects <- read.table(file.path(dest_loc, 'train', 'subject_train.txt'), 
                             header = FALSE)
## Import Features and Activities data and assign to data frames
features <- read.table(file.path(dest_loc,'features.txt'), header = FALSE)
activities <- read.table(file.path(dest_loc, 'activity_labels.txt'), 
                         header = FALSE)

## Assign Column Names to Variables in each data frame
colnames(features) = c("n", "functions")
colnames(activities) <- c("activityid", "activity")
colnames(test_data) = features$functions
colnames(test_activities) = "activityid"
colnames(test_subjects) = "subjectid"
colnames(train_data) = features$functions
colnames(train_activities) = "activityid"
colnames(train_subjects) = "subjectid"

## Merge data by binding columns together to create new data frames
merge_data <- rbind(test_data, train_data)
merge_activities <- rbind(test_activities, train_activities)
merge_subjects <- rbind(test_subjects, train_subjects)

## 1) Merges the training and the test sets to create one data set.
## Combine data frames together by binding rows to create one main data table
combined_data <- cbind(merge_data, merge_activities, merge_subjects)

## 2) Extracts only the measurements on the mean and standard deviation for 
## each measurement.
## Extracting to subset only the mean and standard deviation from
## activityid and subjectid
tidy_extract <- combined_data %>% 
  select(subjectid, activityid, contains("mean"), contains("std"))

## 3) Uses descriptive activity names to name the activities in the data set
## Subset of extract and naming activities
tidy_extract$activityid <- activities[tidy_extract$activityid, 2]

## 4) Appropriately labels the data set with descriptive variable names.
## Create Descriptive names for variables 
names(tidy_extract)[2] = "activity"
names(tidy_extract) <- gsub("acc", "accelerometer", names(tidy_extract))
names(tidy_extract) <- gsub("gyro", "gyroscope", names(tidy_extract))
names(tidy_extract) <- gsub("bodybody", "body", names(tidy_extract))
names(tidy_extract) <- gsub("mag", "magnitude", names(tidy_extract))
names(tidy_extract) <- gsub("^t", "time", names(tidy_extract))
names(tidy_extract) <- gsub("^f", "frequency", names(tidy_extract))
names(tidy_extract) <- gsub("tBody", "time_body", names(tidy_extract))
names(tidy_extract) <- gsub("-mean()", "mean", names(tidy_extract), 
                            ignore.case = TRUE)
names(tidy_extract) <- gsub("-std()", "standard deviation", names(tidy_extract),
                            ignore.case = TRUE)
names(tidy_extract) <- gsub("-freq()", "frequency", names(tidy_extract), 
                            ignore.case = TRUE)
names(tidy_extract) <- gsub("angle", "angle", names(tidy_extract))
names(tidy_extract) <- gsub("gravity", "gravity", names(tidy_extract))

## 5) From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
## Create secondary tidy data set with average of each variable for each 
## activity and subjectid
tidy_dataset <- tidy_extract%>% arrange(subjectid, activity) %>% 
  group_by(subjectid, activity) %>% summarize_all(mean)

#Write final output file
write.table(tidy_dataset, "tidy_dataset.txt", row.name = FALSE)
