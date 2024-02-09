## Clear global environment
rm(list=ls())

## Set data.dir
## simple paste widows copied link into r"( )"
data.dir <- r"(C:\Users\JFBERTRA\Documents\R\Coursera_Rprogramming\data\)"
data.dir <- gsub("\\\\", "/", data.dir)

## set file name to use with folder
file <- paste0(data.dir,"household_power_consumption.txt")

## Set results.dir
## simple paste widows copied link into r"( )"
results.dir <- r"(C:\Users\JFBERTRA\Documents\R\Coursera_Rprogramming\results\)"
results.dir <- gsub("\\\\", "/", results.dir)

## library to use
library(dplyr)
library(data.table)
library(ggplot2)
library(lubridate)

## Reading the data (skipping fist line - has names) and assigning names using first line info
electric_power <- read.table(file,skip=1,sep=";")
names(electric_power) <- unlist(strsplit(readLines(file, 1),";",fixed=TRUE))

## keeping only relevant data - saving RAM
electric_power <- electric_power %>% filter(Date == "1/2/2007" | Date == "2/2/2007") 

## converting dates to the good format (and other vars to numeric)
electric_power$Date <- dmy(electric_power$Date)
electric_power$Time <- hms(electric_power$Time)
electric_power <- electric_power %>% mutate_if(is.character,as.numeric)

## adding day and time together into new var
electric_power <- electric_power %>% mutate(Date.Time = Date + Time)
## creating day for label - failed to make it work with labels
## electric_power <- electric_power %>% mutate(Date.Day = wday(Date.Time, label = TRUE))

## plot with 1 row and 1 col
par(mfrow=c(1,1))

## graph 3
png(paste0(results.dir,"plot3.png"))
plot(electric_power$Date.Time,electric_power$Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")
with(electric_power,lines(Date.Time, Sub_metering_1))
with(electric_power,lines(Date.Time, Sub_metering_2, col="red"))
with(electric_power,lines(Date.Time, Sub_metering_3, col="blue"))
# adding legend
legend("topright", lty=1, col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
# adding title to graph
title(main="Energy sub-metering")
dev.off()
