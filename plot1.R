# Preliminaries:
# Load the needed packages
packages <- c("ggplot2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)


# Get the data from the source:
# A `data` folder will be created and the zip file will be saved
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = "./data/exdata_data_NEI_data.zip")


# Unzip the files:
# A new directory named `exdata_data_NEI_data` will be created in your working directory 
# when the file is unzipped. 
unzip("./data/exdata_data_NEI_data.zip")


# Read the files and store them into data frame objects
NEI <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")
# > dim(NEI)
# [1] 6497651       6
SCC <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
# > dim(SCC)
# [1] 11717    15


# Split the data into subsets getting proper column names
PM2p5 <- aggregate(Emissions ~ year, NEI, sum)


# Open PNG graphics device
png(file = "plot1.png", width = 480, height = 480)


# Set transparent background and plot Graph 1
par(bg = NA)
df.bar <- barplot(PM2p5$Emissions/10^6, names.arg = PM2p5$year,
                  xlab="Year",
                  ylab="PM2.5 Emissions, Mill. Tons",
                  main="Total PM2.5 Emissions From All US Sources")
# Add lines and points to barplot graphs 
# As explained here: http://www.r-bloggers.com/adding-lines-or-points-to-an-existing-barplot/
lines(x = df.bar, y = PM2p5$Emissions/10^6/2)
points(x = df.bar, y = PM2p5$Emissions/10^6/2)


# Close graphics device
dev.off()
