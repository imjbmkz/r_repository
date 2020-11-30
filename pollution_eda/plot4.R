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

## Question 4
## Across the United States, how have emissions from coal combustion-related sources 
## changed from 1999-2008?

## Add EI.Sector column on pm25
pm25$EI.Sector <- source_class$EI.Sector[match(pm25$SCC, source_class$SCC)]

## Get only data on coal combustion-related sources
coal <- pm25 %>% filter(grepl(pattern = '[Cc]oal', x = EI.Sector)) %>% group_by(year) %>% summarise(total_pm25 = sum(Emissions)) %>% mutate(pm25_round = total_pm25 / 100000)

## Create PNG device
png('plot4.png', width = 480, height = 480)

## Create barplot for total PM2.5 emissions of coal combution sources
ggplot(coal, aes(x = year, y = pm25_round)) + geom_bar(stat = 'identity') + labs(x = 'Year', y = 'PM2.5 Emissions (in hundred thousands)', title = 'PM2.5 Emissions of Coal Combustion-Related Sources')

## Close PNG device
dev.off()
