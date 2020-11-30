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

## Question 6
## Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, 
## California (fips == "06037"). Which city has seen greater changes 
## over time in motor vehicle emissions?

## Get only Baltimore, MA and Los Angeles, CA data
motor <- pm25 %>% filter(fips == '24510' | fips == '06037') %>% 
  mutate(EI.Sector = source_class$EI.Sector[match(SCC, source_class$SCC)]) %>% 
  filter(grepl(pattern = 'On-Road', x = EI.Sector)) %>% group_by(fips, year) %>%
  summarise(total_pm25 = sum(Emissions)) %>% mutate(fips = ifelse(fips == '24510', 'Baltimore, MD', 'Los Angeles, CA'))

## Create PNG device
png('plot6.png', width = 800, height = 480)

## Create barplot showing the trend of PM2.5 emissions of motor vehicle-related sources in Baltimore and Los Angeles
ggplot(data = motor, aes(x = year, y = total_pm25)) + geom_bar(stat = 'Identity') + facet_grid(.~fips) + labs(x = 'Year', y = 'PM2.5 Emissions', title = 'PM2.5 Emissions of Motor Vehicle-related Sources in Baltimore, MD and Los Angeles, CA')

## Close PNG device
dev.off()
