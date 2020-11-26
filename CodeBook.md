## Code Book
This code book describes how `run_analysis` script works. Below are the contents of this code book.

**Table of contents**

[About the data](#data)

[Stages of the code](#stages)

[Data wrangling](#wrangle)

[Variables used](#var)

<a name="data"></a>
### About the data
The source data for this project is the experiment on Human Activity Recognition (HAR) using smartphones. It was an experiment on 30 individuals to capture 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. In other words, this data has some measures to identify what an individual is doing. In the dataset, we have six activities which are as follows.

|Activity Code      |Activity Description
|-------------------|---------------------
|1                  |WALKING
|2                  |WALKING_UPSTAIRS
|3                  |WALKING_DOWNSTAIRS
|4                  |SITTING
|5                  |STANDING
|6                  |LAYING

The data consists of 561 variables. But in this project, we only captured 66 of them, which are the mean and standard deviation of the following[<sup>[1]</sup>](#super_one).

1. tBodyAcc-XYZ
2. tGravityAcc-XYZ
3. tBodyAccJerk-XYZ
4. tBodyGyro-XYZ
5. tBodyGyroJerk-XYZ
6. tBodyAccMag
7. tGravityAccMag
8. tBodyAccJerkMag
9. tBodyGyroMag
10. tBodyGyroJerkMag
11. fBodyAcc-XYZ
12. fBodyAccJerk-XYZ
13. fBodyGyro-XYZ
14. fBodyAccMag
15. fBodyBodyAccJerkMag
16. fBodyBodyGyroMag
17. fBodyBodyGyroJerkMag

<a name="stages"></a>
### Stages of the code
The below are the "*stages*" of the code which do a specific task to arrive at two **tidy** data. These stages are also included in the script in the form of code comments. The table pretty much sums up the steps taken by `run_analysis` script.
|Stages     |Line       |Description
|-----------|-----------|---------
|Libraries  |8-10       |This loads the needed libraries for this script.
|Directory  |12-14      |This checks if `capstone project` directory exists, and creates it if not yet available. This would also be used as the directory.
|Data Source|16-22      |This downloads the data from the link specified if it's not downloaded yet. Extracts the download zipped folder, and creates the `date_downloaded` variable to get the date when it was downloaded.
|Labels     |24-26      |This loads the `activity_labels.txt` as a dataframe and `features.txt` as a character vector. This will be used to append the following data with appropriate labels.
|Test Data  |28-33      |This loads the necessary files from the test data and combines these as one dataframe. The labels loaded in "Labels stage" will be used as labels.
|Train Data |35-40      |This loads the necessary files from the training data and combines these as one dataframe. The labels loaded in "Labels stage" will be used as labels.
|Combine    |42-44      |This combines the final test and train data accomplished in "Test Data" and "Train Data" stages to form a one tidy data. The end product will be stored in `complete_data` variable.
|Summary    |46-47      |This creates a tidy data of the average of all the variables of `complete_data` and groups it by `subject` and `activity_description`. The end produt will be stored in `complete_data_summary` variable.
|Save Data  |49-51      |This saves `complete_data` and `complete_data_summary` into `.txt` files.

<a name="wrangle"></a>
### Data wrangling
The following describes the data manipulation that was conducted to arrive at the two final datasets.

**1. Fetch Activity Labels and Variable Descriptions.** In the compressed folder of the UCI HAR dataset, there are `.txt` files for the `activity_labels` and `features` of the data. I loaded them to use these for updating the actual dataset.

**2. Get the training and test data.** There are two subfolders in the directory of the UCI HAR Dataset which are for the **test** (30% of the overall data) and **training** (70% of the overall data) datasets. Each folder contains `subject***.txt` file that contains the subject ID, `X***.txt` file which is the 561 features with the measures captured from the experiment, and `y***.txt` that contains all activity codes for a specific observation. These files were loaded and will later on be cleaned and prepared for merging.

**3. Clean the files and prepare for merging.** The files that were acquired were then cleaned and prepared for merging. `X***` and `y***` are the only datasets that need to be cleaned-up. The activity codes was merged with `activity_labels` dataset which was loaded in step 1 to created a dataframe with two vectors representing activity codes and activity labels. The `features` was used as column names of the dataframe `X***`. Using `grepl()` with a regex pattern, only the mean and standard deviation measures were taken. After these data wrangling step, `subject***`, new `y***` dataframe with labels, and the filtered `X***` datasets were then combined into one tidy dataframe called `complete_data`.

**4. Create a new tidy data for the means of all measures.** After getting the above dataset, we use it to create a new one called `complete_data_summary` which groups the data by `subject` and `activity_labels`, then takes the mean of all variables. This was done using `dplyr` commands `group_by`, `summarise`, and `across`.

**5. Save the datasets as .txt files.** Finally, the `complete_data` and `complete_data_summary` dataframes are saved as `.txt` files named `combined_train_test_dataset.txt` and `summary_combined_train_test_dataset.txt` respectively.

The `complete_data` dataframe contains 69 columns. The first column is `subject` which is the number given to each subject. It was followed by `activity_code` and `activity_description`. Then the rest of the 66 columns are the ones that are described in [About data](#data) section of this markdown file. 

The `complete_data_summary` also contains 69 columns. The only difference is with the number of observations since it only took the grouped `complete_data`. The 66 features are now the mean of each subject and each activity.

<a name="var"></a>
### Variables used
|Variable                   |class                                          |Description
|---------------------------|-----------------------------------------------|---------------------------------------------
|`date_downloaded`          |"data.frame"                                   |Stores the date and time when the UCI HAR Dataset was downloaded.
|`act_labels`               |"POSIXct" "POSIXt"                             |Reads the `activity_labels.txt` file.
|`features`                 |"character"                                    |Stores the 561 feature labels of the dataset.
|`test_subject`             |"data.frame"                                   |Reads the `subject_test.txt` file.
|`test_activity`            |"data.frame"                                   |Reads the `y_test.txt` file.
|`test_data`                |"data.frame"                                   |Reads the `X_test.txt` file.
|`filtered_test_data`       |"data.frame"                                   |Filtered `test_data` that only contains mean and standard deviation measures.
|`complete_test_dataset`    |"data.frame"                                   |The dataset combining `test_subject`, `test_activity` with labels, and `filtered_test_data`.
|`train_subject`            |"data.frame"                                   |Reads the `subject_train.txt` file.
|`train_activity`           |"data.frame"                                   |Reads the `y_train.txt` file.
|`train_data`               |"data.frame"                                   |Reads the `X_train.txt` file.
|`filtered_train_data`      |"data.frame"                                   |Filtered `train_data` that only contains mean and standard deviation measures.
|`complete_train_dataset`   |"data.frame"                                   |The dataset combining `train_subject`, `train_activity` with labels, and `filtered_train_data`.
|`complete_data`            |"data.frame"                                   |The dataset combining `complete_test_dataset` and `complete_train_dataset`.
|`complete_data_summary`    |"grouped_df", "tbl_df", "tbl", "data.frame"    |The dataset grouping the `complete_data` by `subject` and `activity_label`, then, summarized by the mean of each feature.

<sup><a name="super_one"></a>[1] There are a total of 17 variables with mean and standard deviation measures. 8 of them end with `XYZ` which is used to denote 3-axial signals in the X, Y and Z directions. 8 multiplied by 3 (for triaxial signals) multiplied by 2 (for mean and standard deviation measures) is equal to 48. 9 (with no triaxial measures) * 2 (for mean and standard deviation measures) is equal to 66. In the column labels, the measures mean and standdard deviation are denoted by `mean()` and `std()` respectively.</sup>
