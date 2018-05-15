

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
#' ## create data set with date-time and list columns
#' d <- datasets::mtcars
#' d$dttm <- Sys.time() + runif(nrow(d), -1000, 1000)
#' d$list <- lapply(seq_len(nrow(d)), function(.) letters)
#' ## create multiple data frames with duplicate rows
#' d <- lapply(1:50, function(.) rbind(d, d[sample(seq_len(nrow(d)), 20), ]))
#' ## merge into single data frame
#' d <- do.call("rbind", d)
#'
#' ##
#' library(microbenchmark)
#'
#' microbenchmark(
#'   funique(d), unique(d)
#' )
#'
#' funique(d) %>% nrow()
#' unique(d) %>% nrow()
#'
#' @export
funique <- function(x) UseMethod("funique")


#' @export
funique.data.frame <- function(x) {
  psx <- vapply(x, inherits, "POSIXct", FUN.VALUE = logical(1), USE.NAMES = FALSE)
  tzs <- vapply(x[psx], function(.)
    format(na.omit(.)[1], "%Z"), FUN.VALUE = character(1), USE.NAMES = FALSE)
  p <- x[psx]
  x[psx] <- lapply(x[psx], as.integer)
  kp <- !duplicated(x)
  x <- x[kp, ]
  x[psx] <- lapply(p, function(.) .[kp])
  x
}

#' @export
funique.default <- function(x) {
  unique(x)
}


#' @export
funique.POSIXt <- function(x) {
  x[!duplicated(as.integer(x))]
}
