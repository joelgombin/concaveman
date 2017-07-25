library(concaveman)
library(sf)
library(sp)
data(points)
context("main tests")

test_that("input and output formats works correctly", {
  expect_is(concaveman(sf::st_coordinates(points)), "matrix")
  expect_s4_class(concaveman(as(points, "Spatial")), "Spatial")
  expect_s3_class(concaveman(points), "sf")
  # input from classes that don't inherit from matrix, sf or SpatialPoints should throw an error
  expect_error(concaveman(array()))
})

