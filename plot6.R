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


# Subset all rows containing [V-v]ehicle in SCC.Level.Two column from SCC data frame
vehicles <- SCC[grep("vehicle", SCC$SCC.Level.Two, ignore.case = T), ]
# Subset all rows from NEI with same SCC as in vehicles
NEI_vehicles <- NEI[NEI$SCC %in% vehicles$SCC, ]
# Subset the data frame for Baltimore City (fips == "24510") and for Los Angeles 
# City (fips == 06037)
NEI_Baltimore_vehicles <- subset(NEI_vehicles, fips == "24510")
NEI_LosAngeles_vehicles <- subset(NEI_vehicles, fips == "06037")
# Split the data into subsets getting proper column names
NEI_Baltimore_vehicles <- aggregate(list(Emissions = NEI_Baltimore_vehicles$Emissions), 
                                    list(year = NEI_Baltimore_vehicles$year),
                                    sum)
NEI_LosAngeles_vehicles <- aggregate(list(Emissions = NEI_LosAngeles_vehicles$Emissions), 
                                    list(year = NEI_LosAngeles_vehicles$year),
                                    sum)
# Add new column with city name for splitting
NEI_Baltimore_vehicles$city <- "Baltimore City"
NEI_LosAngeles_vehicles$city <- "Los Angeles City"
# Combine the data sets
vehiclesBoth <- rbind(NEI_Baltimore_vehicles, NEI_LosAngeles_vehicles)


# Open PNG graphics device with transparent background
png("plot6.png", width = 480, height = 480, bg = "transparent")


# Plot Graph 6
g <- ggplot(vehiclesBoth, aes(factor(year), Emissions, fill = year))
# stat="identity" for heights of the bars to represent values in the data 
g + geom_bar(stat = "identity", width = .7, alpha = .7) + 
        # Remove the legend
        guides(fill = FALSE) +
        # classic dark-on-light ggplot2 theme
        theme_bw(base_size = 15) +
        # grid with 4 types side by side
        facet_grid(~ city) +
        labs(x = "Year", y = "PM2.5 Emissions, t") +
        labs(title = "Total PM2.5 Emissions from Motor Vehicles Sources\n (Baltimore City vs. Los Angeles City)")


# Close graphics device
dev.off()