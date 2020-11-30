## Get libraries needed
library(dplyr)

## Set directory
if (!file.exists('final_project_eda/')) {
  dir.create('final_project_eda/')
}
setwd('final_project_eda/')

## Data extract
if (!file.exists('epa.zip')) {
  download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip', 'epa.zip')
  unzip('epa.zip')
} else if (!file.exists('/epa')) {
  unzip('epa.zip')
}

## Load the data
pm25 <- readRDS('summarySCC_PM25.rds')
source_class <- readRDS('Source_Classification_Code.rds')

## Question 1
## Have total emissions from PM2.5 decreased in the United States 
## from 1999 to 2008? Using the base plotting system, make a plot 
## showing the total PM2.5 emission from all sources for each of the 
## years 1999, 2002, 2005, and 2008.

## Create annual_pm25 variable for total pm25 emissions per year
annual_pm25 <- pm25 %>% group_by(year) %>% summarise(total_pm25 = sum(Emissions)) %>% mutate(pm25_round = total_pm25 / 1000000)

## Create PNG device
png('plot1.png', width = 480, height = 480)

## Create the bar plot for annual_pm25
barplot(height = annual_pm25$pm25_round, names.arg = annual_pm25$year, main = 'PM2.5 emissions are generally decreasing during 1999-2008', col = c(rep('grey80', 3), 'tan2'), xlab = 'Years', ylab = 'in millions')

## Close png device
dev.off()
