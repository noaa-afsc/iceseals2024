library(dplyr)
library(sf)
library(here)

cruise_bbox <- st_bbox(c(xmin = -166.5, 
                         xmax = -179.9, 
                         ymax = 63, 
                         ymin = 53.9), 
                       crs = st_crs(4326)) |> 
  st_as_sfc()


ship_track_pts <- sf::st_read(here::here('data/iceseals_2024_logbook.kml')) |> 
  sf::st_filter(cruise_bbox)
  

ship_track <- ship_track_pts |> 
  summarise(do_union = FALSE) |> 
  st_cast("LINESTRING")

readr::write_rds(ship_track,here::here('data/ship_track.rds'))
