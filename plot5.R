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
SCC <- readRDS("./data/exdata_data_NEI_data/Source_Classification_Code.rds")
# > dim(SCC)
# [1] 11717    15


# Subset all rows containing [V-v]ehicle in SCC.Level.Two column from SCC data frame
vehicles <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case = T), ]
# Subset all rows from NEI with same SCC as in vehicles
NEI_vehicles <- NEI[NEI$SCC %in% vehicles$SCC, ]
# Subset the data frame for Baltimore City (fips == "24510")
NEI_Baltimore_vehicles <- subset(NEI_vehicles, fips == "24510")
# Split the data into subsets getting proper column names
NEI_Baltimore_vehicles <- aggregate(list(Emissions = NEI_Baltimore_vehicles$Emissions), 
                           list(year = NEI_Baltimore_vehicles$year),
                           sum)


# Open PNG graphics device
png("plot5.png", width = 480, height = 480)


# Set transparent background and plot Graph 5
par(bg = NA)
myBarplot <- barplot(NEI_Baltimore_vehicles$Emissions, 
                     names.arg = NEI_Baltimore_vehicles$year,
                     xlab="Year",
                     ylab="Total PM2.5 Emissions, t",
                     main="Total PM2.5 Emissions from Motor Vehicles Sources\n in Baltimore City")

# Add lines and points to barplot graphs 
# As explained here: http://www.r-bloggers.com/adding-lines-or-points-to-an-existing-barplot/
lines(myBarplot, NEI_Baltimore_vehicles$Emissions/2)
points(myBarplot, NEI_Baltimore_vehicles$Emissions/2)


# Close graphics device
dev.off()