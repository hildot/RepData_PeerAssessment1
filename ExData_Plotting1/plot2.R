## H. Dotson's code to produce plot2.png for Course Project 1
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

## To mirror posted image, changed plot background to "transparent"
##        rather than default "white". Increased font scale by 10%
##        to more closely replicate original image. 

png("plot2.png", width = 480, height = 480)
par(bg = "transparent", cex = 1.1)
plot(epconsub$Global_active_power, type = "l", 
     ylab = "Global Active Power (kilowatts)", xlab = "", xaxt="n")
axis(1, at = c(1, 1441, 2881), labels = c("Thu", "Fri", "Sat"))
dev.off()