## Exploratory Data Analysis on the PM2.5 Emissions dataset
This repository contains all R scripts that I have written to analyze the PM2.5 emissions dataset as part of the last project for **Exploratory Data Analysis** by **John Hopkins University** in [Coursera](https://www.coursera.org/learn/exploratory-data-analysis).

### About the data
The data shows the PM2.5 emissions of different PM sources for the years 1999 to 2008 with 3-year interval. The source data of this project is available [here](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
This zipped folder contains two `Rds` files.
1. `Source_Classification_Code.rds`. This table provides a mapping from the `SCC` digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.
2. `summarySCC_PM25.rds`. This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year.

#### Variables
|Variable Name                      |Rds file                                   |Purpose                                                                  |
|-----------------------------------|-------------------------------------------|-------------------------------------------------------------------------|
|`fips`                             |summarySCC_PM25.rds                        |A five-digit number (represented as a string) indicating the U.S. county |
|`SCC`                              |Both Rds files                             |The name of the source as indicated by a digit string                    |
|`Pollutant`                        |summarySCC_PM25.rds                        |A string indicating the pollutant
|`Emissions`                        |summarySCC_PM25.rds                        |Amount of PM2.5 emitted, in tons
|`type`                             |summarySCC_PM25.rds                        |The type of source (point, non-point, on-road, or non-road)
|`year`                             |summarySCC_PM25.rds                        |The year of emissions recorded

### Background of the project
This project aims at answering just six questions.
1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?
3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?
4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?
