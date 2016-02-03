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


# Read the files and store them into data frame objects. It takes a while!!!
NEI <- readRDS("./data/exdata_data_NEI_data/summarySCC_PM25.rds")
# > dim(NEI)
# [1] 6497651       6
SCC <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
# > dim(SCC)
# [1] 11717    15


# Subset all rows containing [C-c]oal in Short.Name column from SCC data frame
coalRelated <- SCC[grep("coal", SCC$Short.Name, ignore.case = T), ]
# Subset all rows from NEI with same SCC as in coalRelated
NEI_coalRelated <- NEI[NEI$SCC %in% coalRelated$SCC, ]
# Split the data into subsets getting proper column names
coalEmissions <- aggregate(list(Emissions = NEI_coalRelated$Emissions), 
                           list(year = NEI_coalRelated$year),
                           sum)


# Open PNG graphics device with transparent background
png("plot1.png", width = 480, height = 480, bg = "transparent")


# Plot Graph 4
myBarplot <- barplot(coalEmissions$Emissions/10^3, 
                     names.arg = coalEmissions$year,
                     xlab="Year",
                     ylab="Total PM2.5 Emissions, kt",
                     main="Total PM2.5 Emissions from Coal Combustion-related Sources")

# Add lines and points to barplot graphs 
# As explained here: http://www.r-bloggers.com/adding-lines-or-points-to-an-existing-barplot/
lines(myBarplot, coalEmissions$Emissions/10^3/2)
points(myBarplot, coalEmissions$Emissions/10^3/2)


# Close graphics device
dev.off()
