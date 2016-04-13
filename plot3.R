################################################################################
## plot3.R, by AJ Heller, April 2016
##
## This code generates a plot similar to plot shown in 
## figure/unnamed-chunk-4.png, and saves the plot in the file plot3.png. The 
## plot shows overlapping black, red, and blue line charts of sub-metered power
## use (in kilowatts) over time. The sub-metering groups are:
## 
##  1) kitchen
##  2) laundry room
##  3) water heater and air conditioner
##
## Note: the data file "data/household_power_consumption.txt" is not committed as
## part of this repo. If you'd like to run the code yourself, please download UCI
## Machine Learning Repository's data file from 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
##
################################################################################

#-------------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------------

# A helper function to reset all graphical parameters. Borrowed from: 
# http://stackoverflow.com/a/5790430/10161
resetEnvironment <- function() {
    dev.new()
    op <- par(no.readonly = TRUE)
    dev.off()
    par(op)
    rm(list=ls(environment()))
}

#-------------------------------------------------------------------------------
# setup
#-------------------------------------------------------------------------------

resetEnvironment()
library("data.table")


plotFile <- "plot3.png"
dateFormat <- "%d/%m/%Y %H:%M:%S"
minDay <- strptime("1/2/2007 00:00:00", dateFormat)
maxDay <- strptime("2/2/2007 23:59:59", dateFormat)


#-------------------------------------------------------------------------------
# data gathering and manipulation
#-------------------------------------------------------------------------------

# read in all data
powerData <- fread("data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = c("?"))

# pre-filter by date two the 2-day-range we want to work with
powerData <- powerData[powerData$Date %in% c("1/2/2007", "2/2/2007"),]

# convert date and time strings to dates
powerData$DateD <- as.POSIXct(strptime(paste(powerData$Date, powerData$Time), dateFormat))

#-------------------------------------------------------------------------------
# plotting
#-------------------------------------------------------------------------------

png(plotFile, width=480, height=480)

with(twoDayData, plot(DateD, Sub_metering_1
                      , type="n"
                      , xlab=""
                      , ylab="Energy sub metering"))

# plot lines for all 3 sub-meters
with(twoDayData, lines(x = DateD, y = Sub_metering_1))
with(twoDayData, lines(x = DateD, y = Sub_metering_2, col="red"))
with(twoDayData, lines(x = DateD, y = Sub_metering_3, col="blue"))

# add legend
legend("topright"
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , col = c("black", "red", "blue")
       , lwd = 1)
dev.off()
