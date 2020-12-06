## Storm Data Analysis
This is the final project that I've worked on for **Reproducible Research** course by **John Hopkins Univerity** in **[Coursera](https://www.coursera.org/learn/reproducible-research)** This study aims at analyzing the **Storm Data** which is maintained by U.S. **National Oceanic and Atmospheric Administration's (NOAA)**. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage. The documentation of this dataset is found [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf). The raw data is available [here](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2).

The aim of this project is to simply answer two questions.
1. *Across the United States, which types of events are most harmful with respect to population health?*
2. *Across the United States, which types of events have the greatest economic consequences?*

## storm_analysis.R Script
The data wrangling stage of this analysis heavily used the functions within the `storm_analysis.R`. This is to simply the complex coding the markdown report of the entire analysis paper. This script consists of 8 functions.

|Function                             |Argument                             |Return Value                             |Description                             |
|-------------------------------------|-------------------------------------|-----------------------------------------|----------------------------------------|
|`get_data()`                         |-                                    |`"tbl_df" "tbl" "data.frame"`            |Downloads (if unavailable), reads data  |
|`get_coverage()`                     |`x` = `"tbl_df" "tbl" "data.frame"`  |`"tbl_df" "tbl" "data.frame"`            |Get only 2000-2010 data from source     |
|`rem_excols()`                       |`x` = `"tbl_df" "tbl" "data.frame"`  |`"tbl_df" "tbl" "data.frame"`            |Removes extra columns                   |
|`na_rate()`                          |`x` = `list-like vector`             |`list-like vector`                       |Get rate of `NA`s                       |
|`clean_events()`                     |`x` = `list-like vector`             |`list-like vector`                       |Clean data based on event standard      |
|`get_exp_val()`                      |`x` = `list-like vector`             |`list-like vector`                       |Convert characters to multiplier        |
|`date_parse()`                       |`x` = `"tbl_df" "tbl" "data.frame"`  |`"tbl_df" "tbl" "data.frame"`            |Manipulates date and time columns       |
|`arr_cols()`                         |`x` = `"tbl_df" "tbl" "data.frame"`  |`"tbl_df" "tbl" "data.frame"`            |Arranges columns                        |

The analytic data or the data that's ready for analysis can be downloaded in my Kaggle [profile](https://www.kaggle.com/joshvaldeleon/storm-data-noaa-analytic).

## Storm Analysis.md
This markdown consists of the full analytics report for this project. The pre-processing, wrangling, and analysis were explained in this markdown.
