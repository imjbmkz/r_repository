## Instructions:
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement.
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names.
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## 1. Install necessary libraries.
library(dplyr)
library(lubridate)

## 2. Check if 'capstone project' directory exists. Use that as working directory.
if (!file.exists('capstone project')) {dir.create('./capstone project')}
setwd('capstone project')

## 3.Check if UCI HAR Dataset is available. If not, download and extract it.
if (!file.exists('uci_har_dataset.zip')) {
  uci_har_link <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url = uci_har_link, destfile = 'uci_har_dataset.zip')
  date_downloaded <- now()
  unzip('uci_har_dataset.zip')
}

## 4. Open `activity_labels.txt` and `features.txt` for merging.
act_labels <- read.table('./UCI HAR Dataset/activity_labels.txt', col.names = c('activity_code', 'activity_description'))
features <- read.table('./UCI HAR Dataset/features.txt')[, 2]

## 5. Get the files for the test data. Merge the files into one dataset.
test_subject <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names = 'subject')
test_activity <- read.table('./UCI HAR Dataset/test/y_test.txt', col.names = 'activity_code')
test_data <- read.table('./UCI HAR Dataset/test/X_test.txt', col.names = features)
filtered_test_data <- test_data[, grepl(pattern = '(mean|std)([^a-zA-Z])', x = names(test_data))]
complete_test_dataset <- cbind(test_subject, merge(test_activity, act_labels), filtered_test_data)

## 6. Get the files for the training data. Merge the files into one dataset.
train_subject <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names = 'subject')
train_activity <- read.table('./UCI HAR Dataset/train/y_train.txt', col.names = 'activity_code')
train_data <- read.table('./UCI HAR Dataset/train/X_train.txt', col.names = features)
filtered_train_data <- train_data[, grepl(pattern = '(mean|std)([^a-zA-Z])', x = names(train_data))]
complete_train_dataset <- cbind(train_subject, merge(train_activity, act_labels), filtered_train_data)

## 7. Combine train and test datasets and arrange it by subject.
complete_data <- rbind(complete_test_dataset, complete_train_dataset)
complete_data <- arrange(complete_data, subject)

## 8. Create another table that groups the data above by subject and activity description, and get the mean of each variable.
complete_data_summary <- complete_data %>% group_by(subject, activity_description) %>% summarise(across(.fns = mean))

## 9. Save the above two final datasets as .txt files.
write.table(x = complete_data, file = './combined_train_test_dataset.txt')
write.table(x = complete_data_summary, file = './summary_combined_train_test_dataset.txt')
