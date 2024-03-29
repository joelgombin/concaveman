% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/concaveman-pkg.R, R/concaveman.R
\docType{package}
\name{concaveman}
\alias{concaveman}
\alias{concaveman.matrix}
\alias{concaveman.sf}
\alias{concaveman.sfc}
\title{concaveman: A very fast 2D concave hull algorithm.}
\usage{
concaveman(points, concavity, length_threshold)

\method{concaveman}{matrix}(points, concavity = 2, length_threshold = 0)

\method{concaveman}{sf}(points, concavity = 2, length_threshold = 0)

\method{concaveman}{sfc}(points, concavity = 2, length_threshold = 0)
}
\arguments{
\item{points}{the points for which the concave hull must be computed. Can be represented as a matrix of coordinates or an \code{sf} object.}

\item{concavity}{a relative measure of concavity. 1 results in a relatively detailed shape, Infinity results in a convex hull. You can use values lower than 1, but they can produce pretty crazy shapes.}

\item{length_threshold}{when a segment length is under this threshold, it stops being considered for further detalization. Higher values result in simpler shapes.}
}
\value{
an object of the same class as \code{points}: a matrix of coordinates or an \code{sf} object.
}
\description{
This package is a simple R port (through \href{https://github.com/jeroen/v8}{\code{V8}}) of a \href{https://github.com/mapbox/concaveman}{JavaScript library by Vladimir Agafonkin}.

The \code{concaveman} function ports the \href{https://github.com/mapbox/concaveman}{concaveman} library from mapbox. It computes the concave polygon for one set of points.
}
\details{
For details regarding the implementation, please see the original javascript library \href{https://github.com/mapbox/concaveman}{github page}. This is just a thin wrapper, via \href{https://cran.r-project.org/package=V8}{\code{V8}}.
}
\examples{
data(points)
polygons <- concaveman(points)
plot(points)
plot(polygons, add = TRUE)

}
