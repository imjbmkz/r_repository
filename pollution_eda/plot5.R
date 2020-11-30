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

## Question 5
## How have emissions from motor vehicle sources changed from 1999-2008 
## in Baltimore City?

## Get only Baltimore data, add EI.Sector, filter only those with 'On-Road' in its name. Finally, group it.
balti_motor <- pm25 %>% filter(fips == '24510') %>% mutate(EI.Sector = source_class$EI.Sector[match(SCC, source_class$SCC)]) %>% filter(grepl(pattern = 'On-Road', x = EI.Sector)) %>% group_by(year) %>% summarise(total_pm25 = sum(Emissions))

## Create PNG device
png('plot5.png', width = 480, height = 480)

## Create barplot showing the trend of PM2.5 emissions of motor vehicle sources
ggplot(balti_motor, aes(x = year, y = total_pm25)) + geom_bar(stat = 'Identity') + labs(x = 'Year', y = 'PM2.5 Emissions', title = 'PM2.5 Emissions of Motor Vehicle-related Sources in Baltimore')

## Close PNG device
dev.off()
