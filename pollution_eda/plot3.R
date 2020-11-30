## Get libraries needed
library(dplyr)
library(ggplot2)

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

## Question 3
## Of the four types of sources indicated by the type 
## (point, nonpoint, onroad, nonroad) variable, which of these four sources 
## have seen decreases in emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008? Use the ggplot2 
## plotting system to make a plot answer this question.

## Get only Baltimore data and group it by type
balti_type <- pm25 %>% filter(fips == '24510') %>% group_by(type, year) %>% summarise(total_pm25 = sum(Emissions))

## Create PNG device
png('plot3.png', width = 800, height = 480)

## Create barplots for each type of sources
## Create barplots for each type of sources
ggplot(data = balti_type, aes(x = year, y = total_pm25)) + geom_bar(stat = 'identity') + facet_grid(.~type) + labs(title = '10 year trend of PM2.5 emissions per type') + xlab('Year') + ylab('PM2.5 Emissions')

## Close PNG device
dev.off()
