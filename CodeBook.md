## Code Book
This code book describes how `run_analysis` script works. Below are the contents of this code book.

**Table of contents**

[Stages of the code](#stages)

[About the data](#data)

[Data wrangling](#wrangle)

[Variables used](#var)

<a name="stages"></a>
### Stages of the code
The below are the "*stages*" of the code which do a specific task to arrive at two **tidy** data. These stages are also included in the script in the form of code comments. The table pretty much sums up the steps taken by `run_analysis` script.
|Stages     |Line           |Description
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

<a name="data"></a>
<a name="wrangle"></a>
<a name="var"></a>
