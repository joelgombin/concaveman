## mixtures data

library(rjson)
library(sp)
library(sf)
library(purrr)
library(tidyverse)

points <- fromJSON(file = "./inst/extdata/points-1k.json")

points <- map_df(points, ~ data_frame(x = .[1], y = .[2]))

means <- kmeans(points, centers = 10)
points <- cbind(points, k = means$cluster)

coordinates(points) <- c("x", "y")
proj4string(points) <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

points <- st_as_sf(points, crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

