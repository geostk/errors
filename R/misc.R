#' Extract or Replace Parts of an Object
#'
#' S3 operators to extract or replace parts of \code{errors} objects.
#'
#' @inheritParams base::Extract
#' @param ... additional arguments to be passed to base methods
#' (see \code{\link[base]{Extract}}).
#' @name Extract.errors
#'
#' @examples
#' x <- set_errors(1:3, 0.1)
#' y <- set_errors(4:6, 0.2)
#' (z <- rbind(x, y))
#' z[2, 2]
#' z[2, 2] <- -1
#' errors(z[[1, 2]]) <- 0.8
#' z[, 2]
#'
#' @export
`[.errors` <- function(x, ...) {
  e <- errors(x)
  dim(e) <- dim(x)
  e <- as.numeric(e[...])
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' @rdname Extract.errors
#' @export
`[[.errors` <- function(x, ...) {
  e <- errors(x)
  dim(e) <- dim(x)
  e <- as.numeric(e[...])
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' @rdname Extract.errors
#' @export
`[<-.errors` <- function(x, ..., value) {
  e <- errors(x)
  dim(e) <- dim(x)
  e[...] <- errors(value)
  e <- as.numeric(e)
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' @rdname Extract.errors
#' @export
`[[<-.errors` <- function(x, ..., value) {
  e <- errors(x)
  dim(e) <- dim(x)
  e[[...]] <- errors(value)
  e <- as.numeric(e)
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' Replicate Elements of Vectors and Lists
#'
#' S3 method for \code{errors} objects (see \code{\link{rep}}).
#'
#' @inheritParams base::rep
#'
#' @examples
#' rep(set_errors(1, 0.1), 4)
#'
#' @export
rep.errors <- function(x, ...) {
  e <- rep(errors(x), ...)
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' Combine Values into a Vector or List
#'
#' S3 method for \code{errors} objects (see \code{\link{c}}).
#'
#' @inheritParams base::c
#'
#' @examples
#' c(set_errors(1, 0.2), set_errors(7:9, 0.1), 3)
#'
#' @export
c.errors <- function(...) {
  e <- c(unlist(sapply(list(...), errors)))
  structure(NextMethod(), "errors" = e, class = "errors")
}

#' Lagged Differences
#'
#' S3 method for \code{errors} objects (see \code{\link{diff}}).
#'
#' @inheritParams base::diff
#'
#' @examples
#' diff(set_errors(1:10, 0.1), 2)
#' diff(set_errors(1:10, 0.1), 2, 2)
#' x <- cumsum(cumsum(set_errors(1:10, 0.1)))
#' diff(x, lag = 2)
#' diff(x, differences = 2)
#'
#' @export
diff.errors <- function(x, lag = 1L, differences = 1L, ...) {
  ismat <- is.matrix(x)
  xlen <- if (ismat)
    dim(x)[1L]
  else length(x)
  if (length(lag) != 1L || length(differences) > 1L || lag < 1L || differences < 1L)
    stop("'lag' and 'differences' must be integers >= 1")
  if (lag * differences >= xlen)
    return(x[0L])
  r <- x
  i1 <- -seq_len(lag)
  if (ismat)
    for (i in seq_len(differences))
      r <- r[i1, , drop = FALSE] - r[-nrow(r):-(nrow(r) - lag + 1L), , drop = FALSE]
  else for (i in seq_len(differences))
    r <- r[i1] - r[-length(r):-(length(r) - lag + 1L)]
  r
}

#' Coerce to a Data Frame
#'
#' S3 method for \code{errors} objects (see \code{\link{as.data.frame}}).
#'
#' @inheritParams base::as.data.frame
#'
#' @examples
#' x <- set_errors(1:3, 0.1)
#' y <- set_errors(4:6, 0.2)
#' (z <- cbind(x, y))
#' as.data.frame(z)
#'
#' @export
as.data.frame.errors <- function(x, row.names = NULL, optional = FALSE, ...) {
  e <- errors(x)
  dim(e) <- dim(x)
  e <- as.data.frame(e)
  value <- as.data.frame(unclass(x), row.names, optional, ...)
  if (!optional && ncol(value) == 1)
    colnames(value) <- deparse(substitute(x))
  for (i in seq_len(ncol(value)))
    errors(value[[i]]) <- e[[i]]
  value
}

#' \code{type_sum} for Tidy \code{tibble} Printing
#'
#' S3 method for \code{errors} objects.
#'
#' @param x object of class errors
#' @param ... ignored
#'
#' @export type_sum.errors
type_sum.errors <- function(x, ...) "errors"

#' Coerce to a Matrix
#'
#' S3 method for \code{errors} objects (see \code{\link{as.matrix}}).
#'
#' @inheritParams base::matrix
#'
#' @examples
#' as.matrix(set_errors(1:3, 0.1))
#'
#' @export
as.matrix.errors <- function(x, ...)
  structure(NextMethod(), "errors" = errors(x), class = "errors")

#' Matrix Transpose
#'
#' S3 method for \code{errors} objects (see \code{\link{t}}).
#'
#' @inheritParams base::t
#'
#' @examples
#' a <- matrix(1:30, 5, 6)
#' errors(a) <- 1:30
#' t(a)
#'
#' @export
t.errors <- function(x) {
  e <- errors(x)
  dim(e) <- dim(x)
  structure(NextMethod(), "errors" = as.numeric(t(e)), class = "errors")
}

#' Combine R Objects by Rows or Columns
#'
#' S3 methods for \code{errors} objects (see \code{\link[base]{cbind}}).
#'
#' @inheritParams base::cbind
#' @name cbind.errors
#'
#' @seealso \code{\link{c.errors}}
#'
#' @examples
#' x <- set_errors(1, 0.1)
#' y <- set_errors(1:3, 0.2)
#' (m <- cbind(x, y)) # the '1' (= shorter vector) is recycled
#' (m <- cbind(m, 8:10)[, c(1, 3, 2)]) # insert a column
#' cbind(y, diag(3)) # vector is subset -> warning
#' cbind(0, rbind(x, y))
#'
#' @export
cbind.errors <- function(..., deparse.level = 1) {
  call <- as.character(match.call()[[1]])
  allargs <- lapply(list(...), unclass)
  names(allargs) <- sapply(substitute(list(...))[-1], deparse)
  allerrs <- lapply(list(...), function(x) {
    e <- errors(x)
    dim(e) <- dim(x)
    e
  })
  structure(
    do.call(call, c(allargs, deparse.level=deparse.level)),
    errors = as.numeric(do.call(call, allerrs)),
    class = "errors"
  )
}

#' @rdname cbind.errors
#' @export
rbind.errors <- cbind.errors
