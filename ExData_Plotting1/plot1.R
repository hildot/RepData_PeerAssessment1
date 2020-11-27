## H. Dotson's code to produce plot1.png for Course Project 1
##        in Exploratory Data Analysis.
## Built in RStudio. Ran in R-Gui 64-bit for Windows. 

epcon <- read.table("./household_power_consumption.txt", 
                    header = TRUE, sep = ";", na.strings = "?",
                    stringsAsFactors = FALSE)

epconsub <- subset(epcon, Date == "1/2/2007" | 
                        Date == "2/2/2007", select = 1:9)

## To mirror posted image, changed plot background to "transparent"
##        rather than default "white". Increased font scaling to 1.2
##        to more closely replicate original image. 

par(bg = "transparent", cex = 1.2)
hist(epconsub$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()