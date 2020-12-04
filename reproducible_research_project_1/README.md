## Reproducible Research course Project 1
This sub-repository presents the quick and not to complicated study on the recorded number of steps taken per 5-minute interval which covers **October** and **November** of **2012**.
The data is available in this same repository, which is named **activity.csv**.

The study just focused on answering the following questions.
1. *What is mean total number of steps taken per day?*
2. *What is the average daily activity pattern?*
3. *What will be the effects of filling in data for NA values?*
4. *Are there differences in activity patterns between weekdays and weekends?*

These, of course, aren't just close-ended question. There are some plots and slight interpretations.

The full report is found on the **markdown** file in this repository, named, **Summary_Report.md**

### How the code works?
Apart from the images and report, this repository also contains the R script (`project1_solutions.R`) which will answer all of the questions above. This script has five functions. The first one is named,
`get_data()`, which downloads the source data and returns a *tibble* of that data. The four other functions starts with `question_` and followed by the number that 
corresponds to the question it answers. In other words, those functions are named `question_one`, `question_two`, `question_three`, and `question_four`. These function take a data frame
or a tibble which corresponds to our dataset. These returns a list with various lengths to provide the answer to above questions. See summary below.

|Function Name                        |Arguments                        |Return Value                     |   
|-------------------------------------|---------------------------------|---------------------------------|
|`get_data()`                         |no arguments                     |tibble, dataframe                |
|`question_one()`                     |tibble, dataframe                |list with 4 named items          |
|`question_two()`                     |tibble, dataframe                |list with 2 named items          |
|`question_three()`                   |tibble, dataframe                |list with 6 named items          |
|`question_four()`                    |tibble, dataframe                |list with 2 named items          |

Simply source `project1_solutions.R`, store return value o `get_data()` function in a variable, and use this variable as input to the following functions.
