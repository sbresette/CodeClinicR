# Copyright Mark Niemann-Ross, 2018
# Author: Mark Niemann-Ross. mark.niemannross@gmail.com
# LinkedIn: https://www.linkedin.com/in/markniemannross/
# Github: https://github.com/mnr
# More Learning: http://niemannross.com/link/mnratlil
# Description: Code Clinic R: Solution 1. Weather

library(magrittr)
library(lubridate)

# Introduction
# This Code Clinic problem is about calculating statistics from a data set.
# It's easy stuff, but presents a good example of how different languages
# accomplish common tasks.


# Import the source data --------------------------------------------------
# The data set is weather data captured from Lake Pend O'Reille
# in Northern Idaho. We have almost 20 megabytes of data from the
# years 2012 thorugh 2015. That data is available in the folder with
# other exercise files. Each observation in the data includes several
# variables and the data is straightforward.

mytempfile <- tempfile()

readOneFile <- function(dataPath) {
  read.table(dataPath,
             header = TRUE,
             stringsAsFactors = FALSE)
}

for (dataYear in 2012:2015) {
  dataPath <-
    paste0(
      "https://raw.githubusercontent.com/lyndadotcom/LPO_weatherdata/master/Environmental_Data_Deep_Moor_",
      dataYear,
      ".txt"
    )
  
  if (exists("LPO_weather_data")) {
    mytempfile <- readOneFile(dataPath)
    LPO_weather_data <- rbind(LPO_weather_data, mytempfile)
  } else {
    LPO_weather_data <- readOneFile(dataPath)
  }
}

# confirm the results of the import
head(LPO_weather_data, n = 3)
tail(LPO_weather_data, n = 3)

print(paste("Number of rows imported: ", nrow(LPO_weather_data)))

# Description of the challenge --------------------------------------------
# The problem is simple: Write a function that accepts ...
# a beginning date and time
# ...and...
# an ending date and time...

startDateTime <- "2014-01-01 12:03:34"
endDateTime <- "2015-01-01 12:03:34"

# ...then...
# inclusive of those dates and times return the coefficient of the
# slope of barometric pressure.
calculateBaroPress <- function(startDateTime, endDateTime) {
  dateTimeInterval <- interval(ymd_hms(startDateTime),
                               ymd_hms(endDateTime))
  
  baroPress <- subset(
    LPO_weather_data,
    ymd_hms(paste(date, time)) %within% dateTimeInterval,
    select = c(Barometric_Press)
  )
  
  slope <- 1:nrow(baroPress)
  
  BP_linearModel <- lm(Barometric_Press ~ slope, data = baroPress)
  
  coef(BP_linearModel)
}

calculateBaroPress(startDateTime, endDateTime)

# A rising slope indicates an increasing barometric pressure,
# which typically means fair and sunny weather. A falling slope
# indicates a decreasing barometric pressure, which typically means
# stormy weather.

# We're only asking for the coefficient – but some may choose
# to generate a graph of the results as well.
plot(BP_linearModel)