

#' A faster unique function
#'
#' Similar to \code{\link[base]{unique}}, only optimized for working with
#' date-time columns.
#'
#' @param x Input data. If x is not a data frame or date-time object, then it is
#'   simply passed to \code{\link[base]{unique}}
#' @return The unique rows/values of x.
#' @examples
#'
#' ## create example data set
#' d <- data.frame(
#'   x = rnorm(1000),
#'   y = seq.POSIXt(as.POSIXct("2018-01-01"),
#'     as.POSIXct("2018-12-31"), length.out = 10)
#' )
#'
#' ## sample to create version with duplicates
#' dd <- d[c(1:1000, sample(1:1000, 500, replace = TRUE)), ]
#'
#' ## get only unique rows
#' head(funique(dd))
#'
#' ## check output
#' identical(unique(dd), funique(dd))
#'
#' @export
funique <- function(x) UseMethod("funique")


#' @export
funique.data.frame <- function(x) {
  psx <- vapply(x, inherits, c("POSIXct", "Date"),
    FUN.VALUE = logical(1), USE.NAMES = FALSE)
  p <- x[psx]
  x[psx] <- lapply(x[psx], as.integer)
  kp <- !fduplicated(x)
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
  x[!fduplicated(as.integer(x))]
}


fduplicated <- function(x) {
  if (length(x) != 1L)
    duplicated(do.call(Map, c(list, x)), fromLast = FALSE)
  else duplicated(x[[1L]], fromLast = FALSE)
}
