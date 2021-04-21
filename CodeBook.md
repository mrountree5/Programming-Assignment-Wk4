Peer-graded Assignment: Getting and Cleaning Data Course Project Week 4
Requirement: CodeBook.md
by: Melissa Rountree

The purpose of this Code Book is to provide the user with a description of the run_analysis.R script, the data, and what the script does to clean, analyze, tidy the data in the output required for this project.

The run_analysis.R script imports the required data and performs the data preparation, cleaning, tidying, and analysis, as required in the programming assignment set of instructions. 
There are 5 requirements as described in the programming assignment instructions:
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The steps and instructions below are included in the R script and describes/outlines each requirement listed in the sequence above.

I like to clean the memory and environment prior to running scripts.
## Clean memory
2 lines of code that will clean the memory and environment, if you do not want to perform these functions comment lines of code out with ##

Install the necessary R packages:
## Install packages
list of package libraries required for script

Import the data:
## Import and extract the dataset
The dataset is downloaded from URL in zip file format and then extracted to a folder on the users local drive titled "UCI HAR Dataset".
Each data set is imported and assigned to data frames:
## Import test data and assign to data frames (From 'test' subfolder)
The README.txt file included with the data sets provide additional information about each text files and variables included.
test_data: X_test.txt; 2947 obs of 561 variables (test data set)
test_activities: y_test.txt; 2947 obs of 1 variable (test labels)
test_subjects: subject_test.txt; 2947 obs of 1 variable ("Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.")
## Import train data and assign to data frames (from 'train' subfolder)
train_data: X_train.txt; 7352 obs of 561 variables (training data set)
train_activities: y_train.txt; 7352 obs of 1 variable (training labels)
train_subjects: subject_train.txt; 7352 obs of 1 variable ("Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.")
## Import Features and Activities data and assign to data frames
features: features.txt; 561 obs of 2 variables (list of features from this database,
features_info.text provides additional info about the measures and variables included in the data set and states "The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.")
activities: activity_labels.txt; 6 obs of 2 variables (Lists of activities performed,
and provides labels for activities and assigned activity IDs)

## 1) Merges the training and the test sets to create one data set.
## Combine data frames together by binding rows to create one main data table
merge_data: 10299 obs of 561 variables; is created by merging train_data and test_data using rbind() function
merge_activities: 10299 obs of 1 variable; is created by merging train_activities and test_activities using rbind() function
merge_subjects: 10299 obs of 1 variable; is created by merging train_subjects and test_subjects using rbind() function
combined_data: 10299 obs of 563 variables; is created by merging merge_subjects, merge_data and merge_activities using cbind() function

## 2) Extracts only the measurements on the mean and standard deviation for 
## each measurement.
## Extracting to subset only the mean and standard deviation from
## activityid and subjectid
tidy_extract: 10299 obs of 88 vraiables; is created by subsetting combined_data, selecting only columns: subjectid, activityid and the measures of mean and standard deviation (std) for each measurement

## 3) Uses descriptive activity names to name the activities in the data set
## Subset of extract and naming activities
reaplces the column of numbers in the activityid in tidy_extract with the corresponding activity label from second column of the activities data table

## 4) Appropriately labels the data set with descriptive variable names.
## Create Descriptive names for variables 
activityid column in tidy_extract renamed into activities
All acc in column’s name replaced by accelerometer
All gyro in column’s name replaced by gyroscope
All bodybody in column’s name replaced by body
All mag in column’s name replaced by Magnitude
All start with character f in column’s name replaced by frequency
All start with character t in column’s name replaced by time
##Note: code written to ignore case

## 5) From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
## Create secondary tidy data set with average of each variable for each 
## activity and subjectid
tidy_dataset: 180 obs of 88 variables; is created by summarizing tidy_extract taking the mean of each variable for each activity and each subjectid, then group by subjectid and activity.

#Write final output file
Export tidy_dataset into tidy_dataset.txt file.