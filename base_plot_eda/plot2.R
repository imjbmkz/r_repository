## Install necessary libraries
library(dplyr) # for data manipulation
library(lubridate) # for working with dates and times

## Check directory availability. Creates and sets it as working directory if not in yet.
if (!file.exists('eda_r_first_project')) {dir.create('./eda_r_first_project')}
setwd('./eda_r_first_project')

## Check files availability. Downloads it if not in the directory.
if (!file.exists('electric_power_consumption.zip')) {
  download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                destfile = 'electric_power_consumption.zip')
  unzip('electric_power_consumption.zip')
} else if (!file.exists('household_power_consumption.txt')) {
  unzip('electric_power_consumption.zip')
}

## Reads the txt file and selects only the data covering September 1-2, 2007.
housepower <- read.delim('household_power_consumption.txt', sep = ';', na.strings = '?') %>% 
  filter(Date == '1/2/2007' | Date == '2/2/2007')

## Convert the Date variable into actual dates and create Date_time.
housepower <- housepower %>% mutate(Date = dmy(Date), Time = hms(Time), Date_time = Date + Time)

## Create a PNG device.
png(filename = 'plot2.png', width = 480, height = 480)

## Create a line chart on the PNG device.
with(housepower, plot(y = Global_active_power, x = Date_time, type = 'l', 
                      xlab = '', ylab = 'Global Active Power (kilowatts)'))

## Close PNG device and check current device.
dev.off()