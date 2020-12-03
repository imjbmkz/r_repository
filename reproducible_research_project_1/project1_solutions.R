library(tidyverse)

## This function downloads the source data and returns a tibble of that data.
get_data <- function() {
        temp <- tempfile()
        download.file('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip',
                      destfile = temp)
        activity <- read_csv(unzip(temp, 'activity.csv'))
        unlink(temp)
        activity
}

## Function for question number 1.
## This function removes the NAs in the data. It is then, grouped by date, and
## summarized. It calculated the mean and median steps taken daily.
## It will return a list containing the data, the calculated  mean and median, 
## and ggplot object containing the histogram of total steps taken.
question_one <- function(data) {
        temp_data <- data %>% filter(!is.na(steps)) %>% group_by(date) %>% 
                summarise(total_steps = sum(steps))
        temp_hist <- temp_data %>% ggplot(aes(x = total_steps)) + 
                geom_histogram(bins = 20) + 
                labs(x = 'Steps taken', y = 'Frequency', title = 'Histogram of total steps taken')
        temp_mean <- mean(temp_data$total_steps)
        temp_median <- median(temp_data$total_steps)
        temp_list <- list(my_data = temp_data, 
                          my_mean = temp_mean, 
                          my_median = temp_median,
                          my_hist = temp_hist)
}

## Function for question number 2.
## This function removes the NAs in the data. It is then, grouped by interval, and
## summarized. It returns a list containing the line chart showing the mean steps
## taken per interval, and a tibble that shows the interval with the highest mean steps.
question_two <- function(data) {
        temp_data <- data %>% filter(!is.na(steps)) %>% group_by(interval) %>% 
                summarise(mean_steps = mean(steps))
        temp_line <- temp_data %>% ggplot(aes(x = interval, y = mean_steps)) + 
                geom_line(lwd = 2, col = 'steelblue') + 
                labs(x = 'Interval', y = 'Steps Taken', title = 'Mean Steps per interval')
        temp_max <- temp_data %>% filter(mean_steps == max(mean_steps))
        temp_list <- list(my_line = temp_line, my_max = temp_max)
}

## Function for question number 3.
## This function creates two additional columns. First is a column that replaces NAs with median
## then the other replaces the same with mean. The data is then grouped by date and
## summarized to display total number of steps per day. It'll return a list that
## contains the end data, mean and median of median_filled variable, mean and median
## of mean_filled variable, NA rates per column of the original data, and the 
## ggplot object that would display the histogram of two new variables.
question_three <- function(data) {
        temp_data <- data %>% mutate(
                median_filled = if_else(is.na(steps), median(steps, na.rm = TRUE), steps),
                mean_filled = if_else(is.na(steps),mean(steps, na.rm = TRUE), steps)) %>% 
                group_by(date) %>% summarise(mean_filled = sum(mean_filled),
                                             median_filled = sum(median_filled))
        
        na_rate <- function(x) {mean(is.na(x))}
        temp_na <- sapply(data, na_rate)
        median_filled_mean <- mean(temp_data$median_filled)
        median_filled_median <- median(temp_data$median_filled)
        mean_filled_mean <- mean(temp_data$mean_filled)
        mean_filled_median <- median(temp_data$mean_filled)
        temp_hist_median <- temp_data %>% ggplot(aes(median_filled)) + 
                geom_histogram(bins = 20) + 
                labs(x='Steps taken', y='Frequency', title='Histogram of Total Steps taken with median replacement')
        temp_hist_mean <- temp_data %>% ggplot(aes(mean_filled)) + 
                geom_histogram(bins = 20) +
                labs(x='Steps taken', y='Frequency', title='Histogram of Total Steps taken with mean replacement')
        
        temp_list <- list(data = temp_data,
                          na_prop = temp_na,
                          median_filled = data.frame(mean = median_filled_mean, median = median_filled_median),
                          mean_filled = data.frame(mean = mean_filled_mean, median = mean_filled_median),
                          median_filled_hist = temp_hist_median,
                          mean_filled_hist = temp_hist_mean)
        
        temp_list
}

## Function for question number 4.
## The missing values in the original data is replaced with the mean steps.
## New column was added to categorize date if it is a weekend or a weekday.
## Data was then grouped and summarized by taking the average steps.
## Function will return a list of the final data and the ggplot object for the line chart.
question_four <- function(data) {
        temp_data <- data %>% mutate(
                steps = if_else(is.na(steps), mean(steps, na.rm = TRUE), steps),
                day_category = as.factor(if_else(weekdays(date) == 'Saturday' | weekdays(date) == 'Sunday',
                                       'weekend', 'weekday'))) %>% 
                group_by(day_category, interval) %>% 
                summarise(mean_steps = mean(steps))
        
        temp_line <- temp_data %>% ggplot(aes(x = interval, y = mean_steps)) + 
                geom_line(lwd=1.30, col='steelblue') + facet_grid(day_category~.) + 
                labs(x = 'Interval', y = 'Mean Steps taken', title = 'Line chart comparison')
        
        temp_list <- list(my_data = temp_data,
                          my_line = temp_line)
        
        temp_list
}
