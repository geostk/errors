% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/math.R, R/ops.R, R/summary.R
\name{groupGeneric.errors}
\alias{groupGeneric.errors}
\alias{Math.errors}
\alias{Ops.errors}
\alias{Summary.errors}
\title{S3 Group Generic Functions}
\usage{
\method{Math}{errors}(x, ...)

\method{Ops}{errors}(e1, e2)

\method{Summary}{errors}(..., na.rm = FALSE)
}
\arguments{
\item{x}{objects.}

\item{...}{further arguments passed to methods.}

\item{e1}{objects.}

\item{e2}{objects.}

\item{na.rm}{logical: should missing values be removed?}
}
\description{
\code{Math}, \code{Ops} and \code{Summary} group generic methods for
\code{errors} objects with support for automatic error propagation (see
\code{\link[base]{groupGeneric}} for a comprehensive list of available methods).
}
\details{
\subsection{\code{Math}}{
The \code{sign} method returns a numeric value without error. \code{floor},
\code{ceiling}, \code{trunc}, \code{round} and \code{signif} add the rounding
error to the original error. \code{lgamma}, \code{gamma}, \code{digamma} and
\code{trigamma} are not implemented. The rest of the methods propagate the
error as expected from the first-order Taylor series method.}

\subsection{\code{Ops}}{
Boolean operators drop the errors (showing a warning once) and operate on the
numeric values. The rest of the operators propagate the error as expected from
the first-order Taylor series method. Any numeric operand is automatically
coerced to \code{errors} (showing a warning once) with zero error.}

\subsection{\code{Summary}}{
The methods \code{all} and \code{any} are not supported for \code{errors}
objects and fail with an informative message. \code{min}, \code{max} (and
\code{range}) return the minimum or (and) maximum value minus/plus its error.
\code{sum} and \code{prod} propagate the error as expected from the first-order
Taylor series method.}
}
\examples{
x <- set_errors(1:3, 0.1)
exp(x)
log(x)
cumsum(x)
cumprod(x)

y <- set_errors(4:6, 0.2)
x / sqrt(y) + y * sin(x)

# numeric values are automatically coerced to errors
x^2

# boolean operators drop errors
y > x

c(min(x), max(x))
range(x)
sum(y)
prod(y)

}
