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


# Read the files and store them into data frame objects. It takes a while!!!
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


# Open PNG graphics device
png("plot3.png", width = 800, height = 500)


# Plot Graph 3 
g <- ggplot(NEI_Baltimore, aes(factor(year), Emissions, fill = year))
# stat="identity" for heights of the bars to represent values in the data 
g + geom_bar(stat = "identity", width = .7, alpha = .7) + 
        # Remove the legend
        guides(fill = FALSE) +
        # classic dark-on-light ggplot2 theme
        theme_bw(base_size = 15) +
        # grid with 4 types side by side
        facet_grid(~ type) +
        labs(x = "Year", y = "PM2.5 Emissions, t") +
        labs(title = "Total PM2.5 Emissions in Baltimore City by Source Type")


# Close graphics device
dev.off()
