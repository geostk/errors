#' \pkg{errors}: Error Propagation for R Vectors
#'
#' Support for painless automatic error propagation in numerical operations.
#' Errors are automatically propagated when you operate with \code{errors}
#' objects, or with \code{errors} and numeric objects (then numeric values are
#' automatically coerced to errors with zero error).
#' \cr\cr This package treats errors as coming from Gaussian, linear and independent
#' sources, and propagates them using the first-order Taylor series method for
#' propagation of uncertainty. Although the above assumptions are valid in a wide
#' range of applications in science and engineering, the practitioner should
#' evaluate whether they apply for each particular case.
#'
#' @author Iñaki Ucar
#'
#' @details \code{errors} returns a vector of errors. \code{errors_max}
#' (\code{errors_min}) returns the values plus (minus) the errors.
#'
#' \code{`errors<-`} sets the error values (and converts \code{x} into an object
#' of class \code{errors}). \code{set_errors} is a pipe-friendly version of
#' \code{`errors<-`} and returns an object of class \code{errors}. \code{as.errors}
#' is an alias for \code{set_errors}.
#'
#' @seealso
#' \code{\link{groupGeneric.errors}}, \code{\link{mean.errors}}.
#' \code{\link{Extract.errors}}, \code{\link{c}}, \code{\link{rep}}, \code{\link{cbind.errors}}.
#' \code{\link{format.errors}}, \code{\link{print.errors}}, \code{\link{plot.errors}}.
#' \code{\link{as.data.frame.errors}}, \code{\link{as.matrix.errors}}, \code{\link{t}}.
#'
#' @examples
#' x = 1:3
#' class(x)
#' x
#' errors(x) <- 0.1
#' class(x)
#' x
#'
#' (x <- set_errors(x, seq(0.1, 0.3, 0.1)))
#' errors_max(x)
#' errors_min(x)
#'
#' @docType package
#' @import stats
#' @name errors
NULL

#' @param x a numeric object, or object of class \code{errors}.
#' @export
errors <- function(x) UseMethod("errors")

#' @export
errors.numeric <- function(x) rep(0, length(x))

#' @export
errors.errors <- function(x) {
  attr(x, "errors")
}

#' @name errors
#' @export
errors_max <- function(x) UseMethod("errors_max")

#' @export
errors_max.numeric <- function(x) {
  y <- unclass(x)
  attr(y, "errors") <- NULL
  y + errors(x)
}

#' @export
errors_max.errors <- errors_max.numeric

#' @name errors
#' @export
errors_min <- function(x) UseMethod("errors_min")

#' @export
errors_min.numeric <- function(x) {
  y <- unclass(x)
  attr(y, "errors") <- NULL
  y - errors(x)
}

#' @export
errors_min.errors <- errors_min.numeric

#' @name errors
#' @param value a numeric vector of length 1 or the same length as \code{x}.
#' @export
`errors<-` <- function(x, value) UseMethod("errors<-")

#' @export
`errors<-.numeric` <- function(x, value) {
  stopifnot(is.numeric(value))
  stopifnot(length(value) == length(x) || length(value) == 1L)

  if (length(value) == 1)
    value <- rep(value, length(x))
  value[!is.finite(x)] <- x[!is.finite(x)]
  attr(x, "errors") <- abs(value)
  class(x) <- "errors"
  x
}

#' @export
`errors<-.errors` <- `errors<-.numeric`

#' @name errors
#' @export
set_errors <- function(x, value=0) UseMethod("set_errors")

#' @export
set_errors.numeric <- function(x, value=0) {
  errors(x) <- value
  x
}

#' @export
set_errors.errors <- set_errors.numeric

#' @name errors
#' @export
as.errors <- function(x, value = 0) UseMethod("as.errors")

#' @export
as.errors.default <- function(x, value = 0) set_errors(x, value)
