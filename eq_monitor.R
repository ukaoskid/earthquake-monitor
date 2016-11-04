## WEM World Earthquake Monitor
##
## Author:          Simone Di Cicco (simone.dicicco@gmail.com)
## Datasource:      INGV - Italian national institute for geophysics and volcanology (www.ingv.it)
## eq_filtered:     INGV filtered dataset
## eq_dataset_01:   first processed dataset

## Load earthquake data from INGV track
##
## date_start:  observation start time
## date_end:    observation end time
## geo_limits:  list of cities defining the observation area
load_data <- function(date_start, date_end, geo_limits) {
    
    # Check for installed packages
    list.of.packages <- c("lubridate", "RCurl", "ggmap", "dplyr", "rworldmap")
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
    if (length(new.packages)) {
        install.packages(new.packages)
    }
    
    library(lubridate)
    library(RCurl)
    library(ggmap)
    source("eq_process_ds.R")
    
    geo_limits <- geocode(geo_limits)
    eq_min_lat <- min(geo_limits[["lat"]])
    eq_max_lat <- max(geo_limits[["lat"]])
    eq_min_lon <- min(geo_limits[["lon"]])
    eq_max_lon <- max(geo_limits[["lon"]])
    
    print("Getting data...")
    eq_URL_1 <- "http://webservices.ingv.it/fdsnws/event/1/query?starttime="
    eq_URL_2 <- "T00%3A00%3A00&endtime="
    eq_URL_3 <- "T23%3A59%3A59&minmag=2&maxmag=10&mindepth=0&maxdepth=1000&"
    eq_URL_4 <- "minlat=-90&maxlat=90&minlon=-180&maxlon=180&minversion=100&orderby=time-asc&format=text&limit=10000"
    eq_URL <- paste(eq_URL_1, date_start, eq_URL_2, date_end, eq_URL_3, eq_URL_4, sep = "")
    
    eq_stream <- getURL(eq_URL)
    eq <- read.csv(textConnection(eq_stream), sep = "|")
    eq$Time <- ymd_hms(eq$Time)
    
    # Filtering the dataset
    eq_filtered <<- subset(
        eq,
        (Time >= as.Date(date_start) & Time <= as.Date(date_end)) &
            (Latitude >= eq_min_lat & Latitude <= eq_max_lat &
                 Longitude >= eq_min_lon & Longitude <= eq_max_lon)
    )
    
    if (is.null(eq_filtered) || nrow(eq_filtered) <= 0) {
        stop("Empty dataset")
    }
    
    return(eq_filtered)
}

## Plots the scatter graph for magnitude and depth
##
## date_start:  observation start time
## date_end:    observation end time
## geo_limits:  list of cities defining the observation area
plot_eq <- function(date_start, date_end, geo_limits) {
    
    library(dplyr)
    
    output_dest <- "earthquakes_outputs/"
    dir.create(output_dest)
    
    eq_filtered <- load_data(date_start, date_end, geo_limits)
    
    # Chart creation
    pdf("earthquakes_outputs/earthquake_chart.pdf", paper = "USr", width = 50, height = 30);
    
        plot(eq_filtered$Time,
             eq_filtered$Magnitude,
             ylim = c(2, 20),
             pch = 20,
             col = ifelse(eq_filtered$Magnitude >= 4, "red", "black"),
             xlab = "Time",
             ylab = "Magnitude / Depth (Km)"
        )
        axis(side = 2, at = seq(0, 20, by = 2))
        points(eq_filtered$Time[eq_filtered$Magnitude >= 4],
               eq_filtered$Depth.Km[eq_filtered$Magnitude >= 4],
               col = "green"
        )
        abline(lm(eq_filtered$Magnitude ~ eq_filtered$Time), col = "red")

    dev.off()
    
    # Dataset processing
    process_dataset(eq_filtered)
    
    write.csv(eq_dataset_01, file = "earthquakes_outputs/eq_observations_01.csv")
}

## Plots the map
##
## date_start:  observation start time
## date_end:    observation end time
## geo_limits:  list of cities defining the map box dimension
plot_eq_map <- function(date_start, date_end, geo_limits) {
    
    library(rworldmap)
    
    eq_filtered <- load_data(date_start, date_end, geo_limits)
    
    world_map <- getMap(resolution = "low")
    requested_limits <- geocode(geo_limits)
    
    pdf("earthquakes_outputs/earthquake_geomap.pdf");
    
        plot(world_map,
             xlim = range(requested_limits$lon),
             ylim = range(requested_limits$lat),
             asp = 1,
             main = paste(date_start, date_end, sep = " / ")
        )
        points(eq_filtered$Longitude, eq_filtered$Latitude, col = "red", cex = .4)
    
    dev.off()
}
