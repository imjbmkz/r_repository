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

## Change Date and Time to actual dates and time. Create Date_time variable.
housepower <- housepower %>% mutate(Date = dmy(Date), 
                                    Time = hms(Time), Date_time = Date + Time)

## Create a PNG device.
png(filename = 'plot4.png', width = 480, height = 480)

## Create four plots
par(mfrow = c(2,2))
with(housepower, plot(x = Date_time, y = Global_active_power, xlab = '', ylab = 'Global Active Power', type = 'l'))
with(housepower, plot(x = Date_time, y = Voltage, xlab = 'datetime', ylab = 'Voltage', type = 'l'))
with(housepower, plot(x = Date_time, y = Sub_metering_1, xlab = '', ylab = 'Energy sub metering', type = 'n'))
with(housepower, lines(x = Date_time, y = Sub_metering_1, type = 'l', col = 'black'))
with(housepower, lines(x = Date_time, y = Sub_metering_2, type = 'l', col = 'red'))
with(housepower, lines(x = Date_time, y = Sub_metering_3, type = 'l', col = 'blue'))
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2','Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1, bty = 'n')
with(housepower, plot(x = Date_time, y = Global_reactive_power, type = 'l', xlab = 'datetime'))

## Close PNG device and check current device.
dev.off()
