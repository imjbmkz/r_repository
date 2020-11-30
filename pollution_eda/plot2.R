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

## Question 2
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (fips == "24510") from 1999 to 2008? Use the base plotting 
## system to make a plot answering this question.

## Get summary of Baltimore data from pm25
baltimore <- pm25 %>% filter(fips == '24510') %>% group_by(year) %>% summarise(total_pm25 = sum(Emissions))

## Create PNG device
png('plot2.png', width = 480, height = 480)

## Create the bar plot for baltimore
barplot(height = baltimore$total_pm25, names.arg = baltimore$year, main = 'Baltimore PM2.5 emissions are inconsistent.', col = '#69b3a2', xlab = 'Years')

## Close png device
dev.off()
