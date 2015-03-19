[![Build Status](https://travis-ci.org/hrbrmstr/waffle.svg)](https://travis-ci.org/hrbrmstr/waffle)

waffle is a package to make waffle charts (square pie charts)

It uses ggplot2 and returns a ggplot2 object.

The following functions are implemented:

-   `waffle` : make a waffle chart ggplot2 object
-   `as_rcdimple` : turn a waffle chart into a dimple.js htmlwidget

### News

-   Version `0.1` released
-   Version `0.2` released - added `as_rcdimple` thx to Kent Russell
-   Version `0.2.1` released - added Travis tests to ensure independent package build confirmation
-   Version `0.2.3` released - nulled many margins and made the use of `coord_equal` optional via the `equal` parameter

### Installation

``` r
devtools::install_github("timelyportfolio/rcdimple") # only for htmlwidget functionality
devtools::install_github("hrbrmstr/waffle")
```

### Usage

``` r
library(waffle)
```

    ## Loading required package: ggplot2

``` r
# current verison
packageVersion("waffle")
```

    ## [1] '0.2.3'

``` r
# basic example
parts <- c(80, 30, 20, 10)
```

``` r
waffle(parts, rows=8)
```

![](README_files/figure-markdown_github/fig1-1.png)

``` r
# slightly more complex example
parts <- c(`Un-breached\nUS Population`=(318-11-79), `Premera`=11, `Anthem`=79)
```

``` r
waffle(parts, rows=8, size=1, colors=c("#969696", "#1879bf", "#009bda"))
```

**Health records breaches as fraction of US Population** ![](README_files/figure-markdown_github/fig2-1.png)

<smaller>One square == 1m ppl</smaller>

``` r
waffle(parts/10, rows=3, colors=c("#969696", "#1879bf", "#009bda")) 
```

**Health records breaches as fraction of US Population** ![](README_files/figure-markdown_github/fig3-1.png)

<smaller>(One square == 10m ppl)</smaller>

``` r
# replicating an old favourite

# http://graphics8.nytimes.com/images/2008/07/20/business/20debtgraphic.jpg
# http://www.nytimes.com/2008/07/20/business/20debt.html
savings <- c(`Mortgage ($84,911)`=84911, `Auto and\ntuition loans ($14,414)`=14414, 
              `Home equity loans ($10,062)`=10062, `Credit Cards ($8,565)`=8565)
```

``` r
waffle(savings/392, rows=7, size=0.5, 
       colors=c("#c7d4b6", "#a3aabd", "#a0d0de", "#97b5cf"))
```

\*Average Household Savings Each Year\*\* ![](README_files/figure-markdown_github/fig4a-1.png)

<smaller> (1 square == $392)</smaller>

``` r
# similar to but not exact

# https://eagereyes.org/techniques/square-pie-charts
professional <- c(`Male`=44, `Female (56%)`=56)
```

``` r
waffle(professional, rows=10, size=0.5, colors=c("#af9139", "#544616"))
```

**Professional Workforce Makeup**

![](README_files/figure-markdown_github/f5-1.png)

### Test Results

``` r
library(waffle)
library(testthat)

date()
```

    ## [1] "Thu Mar 19 11:44:29 2015"

``` r
test_dir("tests/")
```

    ## basic functionality : .
