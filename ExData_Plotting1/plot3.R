## H. Dotson's code to produce plot3.png for Course Project 1
##        in Exploratory Data Analysis.
## Built in RStudio. Ran in R-Gui 64-bit for Windows. 

epcon <- read.table("./household_power_consumption.txt", 
                    header = TRUE, sep = ";", na.strings = "?",
                    stringsAsFactors = FALSE)

epconsub <- subset(epcon, Date == "1/2/2007" | 
                        Date == "2/2/2007", select = 1:9)


## I used R-package 'lubridate' to create datetime variable. 
##        If you need to install 'lubridate' to check code: 
##        install.packages("lubridate")

library(lubridate)
epconsub$datetime <- dmy_hms(paste(epconsub$Date, epconsub$Time))

png("plot3.png", width = 480, height = 480)

## To mirror posted image, changed plot background to "transparent"
##        rather than default "white".

par(bg = "transparent")
plot(epconsub$Sub_metering_1, type = "l", col = "black",
     ylab = "Energy sub metering", xlab = "", xaxt="n", ylim = c(0, 38))
par(new = TRUE)
plot(epconsub$Sub_metering_2, type = "l", col = "red",
     ylab = "", xlab = "", xaxt="n", yaxt = "n", ylim = c(0, 38))
par(new = TRUE)
plot(epconsub$Sub_metering_3, type = "l", col = "blue",
     ylab = "", xlab = "", xaxt="n", yaxt = "n", ylim = c(0,38))
axis(1, at = c(1, 1441, 2881), labels = c("Thu", "Fri", "Sat"))
legend(x = "topright", lty = "solid", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"))

dev.off()