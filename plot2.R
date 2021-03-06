# Preliminaries:
# Load the needed packages
packages <- c("")
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
# SCC <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
# > dim(SCC)
# [1] 11717    15


# Subset the data frame for Baltimore City (fips == "24510")
NEI_Baltimore <- subset(NEI, fips == "24510")


# Split the data into subsets getting proper column names
PM2p5_Baltimore <- aggregate(list(Emissions = NEI_Baltimore$Emissions), 
                             list(year = NEI_Baltimore$year), 
                             sum)
# Alterhative way using a formula x~y
# PM2p5 <- aggregate(Emissions ~ year, NEI, sum)


# Open PNG graphics device with transparent background
png("plot2.png", width = 480, height = 480, bg = "transparent")


# Plot Graph 2
myBarplot <- barplot(PM2p5_Baltimore$Emissions/10^3, 
                     names.arg = PM2p5_Baltimore$year,
                     xlab="Year",
                     ylab="PM2.5 Emissions, kt",
                     main="Total PM2.5 Emissions in Baltimore City")

# Add lines and points to barplot graphs 
# As explained here: http://www.r-bloggers.com/adding-lines-or-points-to-an-existing-barplot/
lines(myBarplot, PM2p5_Baltimore$Emissions/10^3/2)
points(myBarplot, PM2p5_Baltimore$Emissions/10^3/2)


# Close graphics device
dev.off()
