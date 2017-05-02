#' A very fast 2D concave hull algorithm
#'
#' The `concaveman` function ports the [concaveman](https://github.com/mapbox/concaveman) library from mapbox. It computes the concave polygon(s) for one or several set of points.
#'
#' For details regarding the implementation, please see the original javascript library [github page](https://github.com/mapbox/concaveman). This is just a thin wrapper, via [`V8`](https://cran.r-project.org/web/packages/V8/). I only have introduced some sort of vectorisation: using the `by` argument, you can compute the polygons for a number of subsets of points.
#'
#' @param points an object of class `sf` containing points
#' @param by the (unquoted, tidyverse-style) name of the variable defining the subsets of points for which concave hull polygons should be computed. If `NULL` (the default), only one polygon is computed for the whole set of points.
#' @param concavity a relative measure of concavity. 1 results in a relatively detailed shape, Infinity results in a convex hull. You can use values lower than 1, but they can produce pretty crazy shapes.
#' @param length_threshold when a segment length is under this threshold, it stops being considered for further detalization. Higher values result in simpler shapes.
#'
#' @return an `sf` object holding the polygon(s) and, if there is one, the `by` column.
#' @examples
#' library(tmap)
#' data(points)
#' polygons <- concaveman(points, k)
#' tm_shape(points) +
#'  tm_dots(col = "k", size = 0.1, legend.show = FALSE) +
#' tm_shape(polygons) +
#'  tm_fill(col = "k", alpha = 0.5, legend.show = FALSE)
#'
#' @export
#' @import sf
#' @importFrom magrittr "%>%"



concaveman <- function(points, by = NULL, concavity = 2, length_threshold = 0) {

  by <- rlang::enquo(by)
  # points has to be an sf

  if (!inherits(points, "sf")) {
    stop("points needs to be an object of class sf.")
  }

  ctx <- V8::v8()
  ctx$source(system.file("js", "concaveman-bundle.js", package = "concaveman")) # mettre version locale
  workhorse <- function(points, concavity, length_threshold) {
    jscode <- sprintf(
      "var points = %s; var polygon = concaveman(points, concavity = %s, lengthThreshold = %s);",
      jsonlite::toJSON(sf::st_coordinates(points), dataframe = 'values'),
      concavity,
      length_threshold
    )
    ctx$eval(jscode)
    df <- as.data.frame(ctx$get('polygon'))
    out_polygon <- sf::st_polygon(list(as.matrix(df)))
    out_polygon <- sf::st_sfc(out_polygon, crs = sf::st_crs(points))
  }

  if (!is.null(rlang::quo_expr(by))) {
    points %>%
      dplyr::group_by(rlang::UQ(by)) %>%
      dplyr::summarise(polygons = workhorse(geometry, concavity, length_threshold))
  } else {
    points %>%
      dplyr::summarise(polygons = workhorse(., concavity, length_threshold))
  }
}
