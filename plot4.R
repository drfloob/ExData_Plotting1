################################################################################
## plot4.R, by AJ Heller, April 2016
##
## This code generates a plot similar to plot shown in 
## figure/unnamed-chunk-5.png, and saves the plot in the file plot4.png. The 
## plot shows 4 graphs in a 2x2 arrangement. The left two are plot2 and plot3
## (top to bottom). The right two are line plots showing voltage over time and
## global average power over time.
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


plotFile <- "plot4.png"
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
par(mfcol=c(2,2))



# top-left, same as plot2.png
with(twoDayData, plot(DateD, Global_active_power
                      , type="n"
                      , xlab=""
                      , ylab="Global Active Power"))
with(twoDayData, lines(x = DateD, y = Global_active_power))



# bottom-left, same as plot3.png
with(twoDayData, plot(DateD, Sub_metering_1
                      , type="n"
                      , xlab=""
                      , ylab="Energy sub metering"))
with(twoDayData, lines(x = DateD, y = Sub_metering_1))
with(twoDayData, lines(x = DateD, y = Sub_metering_2, col="red"))
with(twoDayData, lines(x = DateD, y = Sub_metering_3, col="blue"))
legend("topright"
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , col = c("black", "red", "blue")
       , lwd = 1
       , box.lwd = 0)



# top-right
with(twoDayData, plot(DateD, Voltage
                      , type="n"
                      , xlab="datetime"))
with(twoDayData, lines(x=DateD, y=Voltage))



# bottom-right
with(twoDayData, plot(DateD, Global_reactive_power
                      , type="n"
                      , xlab="datetime"))
with(twoDayData, lines(x=DateD, y=Global_reactive_power))

dev.off()
