devtools::install_github('hadley/ggplot2')
pacman::p_load(plotly, dplyr)


# Load data#
data(txhousing)

# Select variables, subset by city, omit missing variables, convert to data frame
tx = txhousing %>%
        select(city, month, median, year) %>%
        filter(city %in% c('Galveston', 'Bay Area', 'Port Arthur', 'Austin')) %>% 
        group_by(city, year) %>% 
        summarise(avg = mean(median)) %>% 
        na.omit() %>% 
        data.frame() 

# Explore data
nrow(tx)
head(tx)


# Static ggplot of housing prices by month, stratified by city 
texas_plot = ggplot(tx, aes(x = year, y = avg, color = city), factor = city) + 
        geom_path() +
        labs(y = 'Average price ($USD)', 
             title = 'Texas housing prices 2000-2015, by month') + 
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
        scale_x_continuous(breaks = pretty(tx$year, n = 15))

texas_plot
ggsave(filename = "plots/ggplot_texas_plot.jpeg", texas_plot, "jpeg", width = 4, height = 6)
gg = ggplotly(texas_plot)


https://blogs.uoregon.edu/rclub/2015/02/17/interactive-embedded-plots-with-plotly-and-ggplot2/
# Figure this out for the markdown        
# Using plotly

pplot = plot_ly(data = tx, x = ~year, y = ~avg) %>% 
        add_lines(color = ~city) %>% 
        rangeslider() %>% 
        layout(xaxis = list(title = ""))
pplot


