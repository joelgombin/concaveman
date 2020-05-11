#include "concaveman-src.h"
#include "concaveman.h"
#include "concaveman/api.hpp"

//' rcpp_concaveman_mat
//' @noRd 
// [[Rcpp::export]]
Rcpp::DataFrame rcpp_concaveman_mat (Rcpp::NumericMatrix xy, Rcpp::IntegerVector hull_in,
        const double concavity, const double length_threshold)
{
    return api::rcpp_concaveman_mat (xy, hull_in, concavity, length_threshold);
}

