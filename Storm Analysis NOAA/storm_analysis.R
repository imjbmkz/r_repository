library(lubridate)
library(dplyr)
library(ggplot2)
library(feather)

get_data <- function() {
  if (!file.exists('stormdata.bz2')) {
    download.file('https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2',
                  destfile = 'stormdata.bz2')
  } 
  
  if (!file.exists('stormdata.feather')) {
    temp_data <- read.csv('stormdata.bz2')
    write_feather(temp_data, 'stormdata.feather')
  }
  
  temp_data <- read_feather('stormdata.feather')
  temp_data
}

get_coverage <- function(x) {
  temp_data <- x %>% mutate(
    BGN_DATE = as.Date(BGN_DATE, '%m/%d/%Y'),
    BGN_YEAR = year(BGN_DATE)) %>% 
    filter(BGN_YEAR >= 2000 & BGN_YEAR <= 2010)
  
  temp_data
}

rem_excols <- function(x) {
  temp_data <- x %>% select(
    -c(STATE__, COUNTY, WFO, STATEOFFIC, ZONENAMES, REMARKS, REFNUM, COUNTY_END, 
       COUNTYENDN, BGN_RANGE, BGN_AZI, END_RANGE, END_AZI, BGN_LOCATI, END_LOCATI, 
       LATITUDE_E, LONGITUDE_, LENGTH, WIDTH, MAG, F, TIME_ZONE))
  temp_data
}

na_rate <- function(x) {
  mean(is.na(x))
}

clean_events <- function(x) {
  x[grepl('(WARM)(?:.+)(WET)|(OTHER)|(DROWNING)|(NORTHERN LIGHTS)|(RED FLAG)', x)] <- 'Unsure'
  x[grepl('FIRE', x)] <- 'Wildfire'
  x[grepl('(^MARINE )+(TSTM|THUNDER)', x)] <- 'Marine Thunderstorm Wind'
  x[grepl('MARINE STRONG WIND', x)] <- 'Marine Strong Wind'
  x[grepl('MARINE HIGH WIND', x)] <- 'Marine High Wind'
  x[grepl('MARINE HAIL', x)] <- 'Marine Hail'
  x[grepl('(ABNORM|EXTREM|UNUSUA|EXCESS|UNSEASO|VERY|PROLO|RECORD)(?:.+)(WARM|HOT|HEAT^DROUGHT)', x)] <- 'Heat'
  x[grepl('WARM WEATHER|HEAT', x)] <- 'Heat'
  x[grepl('MICRO|THUNDERSTORM WIND|THUNDERSTORM|TSTM WIND', x)] <- 'Thunderstorm Wind'
  x[grepl('DRY|DROUGHT', x)] <- 'Drought'
  x[grepl('^(UNSEASONA|EXTREME|UNUSUA)(?:.+)(COLD|COOL|LOW TEMP|WINDCHILL)', x)] <- 'Extreme Cold/Wind Chill'
  x[grepl('WIND CHILL|WND|COOL|COLD|PRECIPITATION', x)] <- 'Cold/Wind Chill'
  x[grepl('VOLCAN|MUD', x)] <- 'Volcanic Ash'
  x[grepl('SURGE', x)] <- 'Storm Surge/Tide'
  x[grepl('TORNADO|WHIRLWIND', x)] <- 'Tornado'
  x[grepl('TROPICAL STORM', x)] <- 'Tropical Storm'
  x[grepl('TROPICAL DEPRESSION|GRADIENT', x)] <- 'Tropical Depression'
  x[grepl('ROGUE WAVE|TSUNAMI', x)] <- 'Tsunami'
  x[grepl('FLASH FLOOD|HIGH WATER|DAM BREAK', x)] <- 'Flash Flood'
  x[grepl('(C.*L) +(FLOOD)', x)] <- 'Coastal Flood'
  x[grepl('LAKESHORE FLOOD', x)] <- 'Lakeshore Flood'
  x[grepl('RIP', x)] <- 'Rip Current'
  x[grepl('FLOOD', x)] <- 'Flood'
  x[grepl('FREEZING RAIN|WINTER STORM', x)] <- 'Winter Storm'
  x[grepl('LAKE.*SNOW', x)] <- 'Lake-Effect Snow'
  x[grepl('SLEET', x)] <- 'Sleet'
  x[grepl('RAIN|URBAN/SML STREAM FLD', x)] <- 'Heavy Rain'
  x[grepl('STRONG|WIND', x)] <- 'Strong Wind'
  x[grepl('GUST|HIGH WIND', x)] <- 'High Wind'
  x[grepl('WINTER WEATHER|FREEZING DRIZZLE|WINTRY', x)] <- 'Winter Weather'
  x[grepl('HURRI', x)] <- 'Hurricane/Typhoon'
  x[grepl('BLIZ|ACCUMU', x)] <- 'Blizzard'
  x[grepl('HAIL', x)] <- 'Hail'
  x[grepl('ICE|ICY', x)] <- 'Ice Storm'
  x[grepl('SNOW', x)] <- 'Heavy Storm'
  x[grepl('AVAL', x)] <- 'Avalanche'
  x[grepl('FREEZING FOG|GLAZE', x)] <- 'Freezing Fog'
  x[grepl('FROST|FREEZE', x)] <- 'Frost/Freeze'
  x[grepl('WATERSPROUT|SPOUT', x)] <- 'Watersprout'
  x[grepl('SURF|SEAS|WET|HIGH TIDE|EROSION', x)] <- 'High Surf'
  x[grepl('FOG', x)] <- 'Fog'
  x[grepl('DUST DEV|WALL', x)] <- 'Dust Devil'
  x[grepl('DUST', x)] <- 'Dust Storm'
  x[grepl('SMOKE', x)] <- 'Dense Smoke'
  x[grepl('SEICHE', x)] <- 'Seiche'
  x[grepl('FUNNEL', x)] <- 'Funnel Cloud'
  x[grepl('ASTRONOMICAL', x)] <- 'Astronomical Low Tide'
  x[grepl('LAND', x)] <- 'Debris Flow'
  x[grepl('LIGHTNING', x)] <- 'Lightning'
  x
}

get_exp_val <- function(x) {
    x <- gsub('[Bb]', 1000000000, x)
    x <- gsub('[Mm]', 1000000, x)
    x <- gsub('[Kk]', 1000, x)
    x <- gsub('[Hh]', 100, x)
    x <- gsub('^$', 0, x)
    x <- as.numeric(x)
}

date_parse <- function(x) {
  temp_data <- x %>% mutate(
    BGN_DATE_TIME = as.POSIXct(paste(BGN_DATE, BGN_TIME)),
    END_DATE_TIME = as.POSIXct(paste(as.Date(END_DATE, '%m/%d/%Y'), END_TIME)),
    BGN_MNTH = months(BGN_DATE_TIME, abbreviate=FALSE),
    END_MNTH = months(END_DATE_TIME, abbreviate=FALSE),
    END_YEAR = as.integer(year(END_DATE_TIME)),
    EV_LENGTH = END_DATE_TIME - BGN_DATE_TIME) %>%
  select(-c(BGN_DATE, BGN_TIME, END_DATE, END_TIME))
  temp_data
}

arr_cols <- function(x) {
  temp_data <- x %>% select(
    EVTYPE, STATE, COUNTYNAME, LATITUDE, LONGITUDE, BGN_DATE_TIME, BGN_YEAR, BGN_MNTH,
    END_DATE_TIME, END_YEAR, END_MNTH, EV_LENGTH, FATALITIES, INJURIES, PROPDMG, CROPDMG) %>%
    arrange(BGN_DATE_TIME, EVTYPE)
  temp_data
}