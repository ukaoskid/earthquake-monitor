# WEM World Earthquake Monitor
R written application to get data about earthquakes in a defined geographical area.
Consider this work still in progress, but usable.

## Datasource information
All the data are took from INGV (Istituto Nazionale di Geofisica e Vulcanologia), the Italian National Institute for Geophysics and Volcanology.
- http://www.ingv.it (official web site)
- http://cnt.rm.ingv.it (datasource webservices)

## What is the application output?
- Charts (representing the eartquakes trend)
- Maps (representing the geolocation of earthquakes)
- CSV (filtered datasets and post-processed datasets)

## How to run?
### Requirements
R is needed to run this application. If you don't have R installed you should download it from
- https://www.r-project.org/
- Once R is installed just download this repository in your R working directory. If you don't know where is located just open R and type the command `getwd()`

### Running
- Open R console
- Load the main R file `source("eq_monitor.R")`
- Run one of the two functions
  1. `plot_eq(date_start, date_end, geo_limits)`
  2. `plot_eq_map(date_start, date_end, geo_limits)`
- The application may ask you to install R packages
