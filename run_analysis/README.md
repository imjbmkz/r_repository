## Getting and Cleaning Data Course Project
This is my final work for the course project of Getting and Cleaning Data with R. This repository consists of the following.
- **README.md** - This file
- **CodeBook.md** - Markdown file that explains how the `run_analysis` R script works, the data used, and variables within `run_analysis`.
- **run_analysis.R** - R script that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- **combined_train_test_dataset.txt** - .txt file containing the final data product of the the combined train and test UCI HAR Dataset.
- **summary_combined_train_test_dataset.txt** - .txt file containing the data product of the `combined_train_test_dataset` which was grouped and had the mean of the 66 features per subject and per group.

The dataset used in this project was downloaded from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The original dataset can be acquired from the archive page of UCI Machine Learning Repository. See this [link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).
