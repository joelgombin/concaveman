## mixtures data

library(jsonlite)
library(sf)

points <- fromJSON("./inst/extdata/points-1k.json")

means <- kmeans(points, centers = 10)

points <- tibble::tibble(x = points[,1], y = points[,2], k = means$cluster)

points <- st_as_sf(points, coords = c("x", "y"), crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

