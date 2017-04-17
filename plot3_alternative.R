by_year_type_BC_total <- (NEI %>% group_by(year)
                          %>% group_by(type, add=TRUE)
                          %>% filter(fips == 24510)
                          %>% summarize(sum(Emissions)))

names(by_year_type_BC_total) <- c("Year", "Type", "Total_Emissions")

g5 <- (ggplot(by_year_type_BC_total, aes(Year, Total_Emissions))
       + facet_grid(.~Type)
#       + facet_wrap( ~ Type, ncol=2)
       + geom_point(size = 4, color = "#F8766D")
       + geom_line(color = "#F8766D")
       + labs(y = "Emissions (thousands of tons)")
       + ggtitle("Emissions in Baltimore City by Type (All Sources)"))
g5