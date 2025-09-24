#' A very fast 2D concave hull algorithm
#'
#' The `concaveman` function ports the [concaveman](https://github.com/mapbox/concaveman) library from mapbox. It computes the concave polygon for one set of points.
#'
#' For details regarding the implementation, please see the original javascript library [github page](https://github.com/mapbox/concaveman). This is just a thin wrapper, via [`V8`](https://cran.r-project.org/package=V8).
#'
#' @param points the points for which the concave hull must be computed. Can be represented as a matrix of coordinates or an `sf` object.
#' @param concavity a relative measure of concavity. 1 results in a relatively detailed shape, Infinity results in a convex hull. You can use values lower than 1, but they can produce pretty crazy shapes.
#' @param length_threshold when a segment length is under this threshold, it stops being considered for further detalization. Higher values result in simpler shapes.
#'
#' @return an object of the same class as `points`: a matrix of coordinates or an `sf` object.
#' @examples
#' data(points)
#' polygons <- concaveman(points)
#' plot(points)
#' plot(polygons, add = TRUE)
#'
#' @export


concaveman <- function(points, concavity, length_threshold) UseMethod("concaveman", points)

#' @export
#' @rdname concaveman
concaveman.matrix <- function(points, concavity = 2, length_threshold = 0) {
  ctx <- V8::v8()
  ctx$source(system.file("js", "concaveman-bundle.js", package = "concaveman")) # local version
  workhorse <- function(points, concavity, length_threshold) {
    jscode <- sprintf(
      "var points = %s; var polygon = concaveman(points, concavity = %s, lengthThreshold = %s);",
      jsonlite::toJSON(points, dataframe = 'values'),
      concavity,
      length_threshold
    )
    ctx$eval(jscode)
    df <- as.matrix(as.data.frame(ctx$get('polygon')))
    df
  }
  workhorse(points, concavity, length_threshold)

}

#' @export
#' @rdname concaveman
concaveman.sf <- function(points, concavity = 2, length_threshold = 0) {

  crs <- sf::st_crs(points)
  coords <- sf::st_coordinates(points)
  res <- sf::st_cast(
    sf::st_linestring(
      concaveman(coords, concavity, length_threshold)
      ),
    "POLYGON"
    )

  res <- sf::st_as_sf(sf::st_sfc(res), crs = crs)
  # to be backward compatible with previous tidyverse implementation
  sf::st_geometry(res) <- "polygons"
  return(res)
}

#' @export
#' @rdname concaveman
concaveman.sfc <- function(points, concavity = 2, length_threshold = 0) {

  crs <- sf::st_crs(points)
  coords <- sf::st_coordinates(points)
  res <- sf::st_cast(
    sf::st_linestring(
      concaveman(coords, concavity, length_threshold)
    ),
    "POLYGON"
  )

  sf::st_sfc(res, crs = crs)
}

