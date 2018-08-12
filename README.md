
<!-- README.md is generated from README.Rmd. Please edit that file -->

# funique <img src="man/figures/logo.png" width="160px" align="right" />

[![Travis build
status](https://travis-ci.org/mkearney/funique.svg?branch=master)](https://travis-ci.org/mkearney/funique)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

> ⌚️ A faster `unique()` function

## Installation

You can install the released version of funique from Github with:

``` r
## install remotes pkg if not already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## install funique from github
remotes::install_github("mkearney/funique")
```

## Usage

There’s one function `funique()`, which is the same as `base::unique()`
only optimized to be faster when data contain date-time variables.

## Speed test: `funique()` vs. `base::unique()`

The code below creates a data frame with several duplicate rows and then
compares performance (in time) of `funique()` versus `base::unique()`.

``` r
## set seed
set.seed(20180812)

## generate data
d <- data.frame(
  x = rnorm(1000),
  y = seq.POSIXt(as.POSIXct("2018-01-01"),
    as.POSIXct("2018-12-31"), length.out = 10))

## create data frame with duplicate rows
d <- d[c(1:1000, sample(1:1000, 500, replace = TRUE)), ]
row.names(d) <- NULL

## check the output against base::unique
identical(unique(d), funique(d))

## bench mark
(m <- microbenchmark::microbenchmark(unique(d), funique(d), 
  times = 200, unit = "relative"))

## plot
plot(drop_hl(m, n = 4)) + 
  ggplot2::ggsave("man/figures/r1.png", width = 8, height = 4.5, units = "in")
```

<p align="center">

<img src="man/figures/r1.png">

Here’s another test this time using duplicate-infested Twitter data.

``` r
## search for data on 100 tweets
rt <- rtweet::search_tweets("lang:en", verbose = FALSE)

## create duplicates
rt2 <- rt[sample(1:nrow(rt), 1000, replace = TRUE), ]

## benchmarks
(mb <- microbenchmark::microbenchmark(
  unique(rt2), funique(rt2), unit = "relative"))

## make sure the output is the same
identical(unique(rt2), funique(rt2))

## plot
plot(drop_hl(mb, n = 4)) + 
  ggplot2::ggsave("man/figures/r2.png", width = 8, height = 4.5, units = "in")
```

<p align="center">

<img src="man/figures/r2.png">
