

#' A faster unique() function
#'
#' Similar to \code{\link[base]{unique}}, only optimized for working with
#' date-time and some list columns.
#'
#' @param x Input data. If x is not a data frame or date-time object, then it is
#' simply passed to \code{\link[base]{unique}}
#' @return The unique values of x.
#' @examples
#'
#' ## create data set with date-time columns
#' d <- datasets::mtcars
#' d$dttm <- Sys.time() + runif(nrow(d), -1000, 1000)
#'
#' ## create multiple data frames with duplicate rows
#' d <- lapply(1:50, function(.) rbind(d, d[sample(seq_len(nrow(d)), 20), ]))
#'
#' ## merge into single data frame
#' d <- do.call("rbind", d)
#'
#' ## speed test
#' library(microbenchmark)
#' (mn <- microbenchmark(unique(d), funique(d)))
#'
#' ## check output
#' identical(unique(d), funique(d))
#'
#' @export
funique <- function(x) UseMethod("funique")


#' @export
funique.data.frame <- function(x) {
  fc <- vapply(x, function(.) is.integer(.) | is.factor(.),
    FUN.VALUE = logical(1), USE.NAMES = FALSE)
  if (any(fc)) {
    x <- x[!fduplicated(x[fc]), ]
    x <- x[!fduplicated(x), ]
  }
  psx <- vapply(x, inherits, "POSIXct", FUN.VALUE = logical(1), USE.NAMES = FALSE)
  p <- x[psx]
  x[psx] <- lapply(x[psx], as.integer)
  kp <- !fduplicated(x)
  x <- x[kp, ]
  x[psx] <- lapply(p, function(.) .[kp])
  x
}

fduplicated <- function(x) {
  if (length(x) != 1L)
    duplicated(do.call(Map, c(list, x)), fromLast = FALSE)
  else duplicated(x[[1L]], fromLast = FALSE)
}


#' @export
funique.default <- function(x) {
  unique(x)
}


#' @export
funique.POSIXt <- function(x) {
  x[!duplicated(as.integer(x))]
}
