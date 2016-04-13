################################################################################
##plot1.R, by AJ Heller, April 2016
##
## This code generates a plot similar to plot shown in 
## figure/unnamed-chunk-2.png, and saves the plot in the file plot1.png. The 
## plot is a histogram that shows the frequency of Global Active Power use (in
## kilowatts) allocated approximately into 0.5kW-width buckets.
##
## Note: the data file "data/household_power_consumption.txt" is not committed as
## part of this repo. If you'd like to run the code yourself, please download UCI
## Machine Learning Repository's data file from 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
##
################################################################################

library("data.table")



dateFormat <- "%d/%m/%Y"
minDay <- as.Date("1/2/2007", dateFormat)
maxDay <- as.Date("2/2/2007", dateFormat)


#-------------------------------------------------------------------------------
# data gathering and manipulation
#-------------------------------------------------------------------------------

# read in all data
powerData <- fread("data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = c("?"))

# convert date strings to dates
powerData$DateD <- as.Date(powerData$Date, dateFormat)

# filter the data down to the dates under consideration
twoDayData <- powerData[powerData$DateD %in% c(minDay, maxDay),]


#-------------------------------------------------------------------------------
# plotting
#-------------------------------------------------------------------------------

par(resetPar())
png("plot1.png", width=480, height=480)

with(twoDayData, hist(x = Global_active_power
                      , col="red"
                      , breaks = 12
                      , ylim = c(0,1200)
                      , main="Global Active Power"
                      , xlab = "Global Active Power (kilowatts)"
                      , ylab="Frequency"))

dev.off()


#-------------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------------

# A helper function to reset all graphical parameters. Borrowed from: 
# http://stackoverflow.com/a/5790430/10161
resetPar <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    op
}


