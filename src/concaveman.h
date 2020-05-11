#pragma once

#include "Rcpp.h"

Rcpp::DataFrame rcpp_concaveman (Rcpp::DataFrame xy, Rcpp::IntegerVector hull_in,
        const double concavity, const double length_threshold);
