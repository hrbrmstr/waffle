
[![Build Status](https://travis-ci.org/hrbrmstr/waffle.svg)](https://travis-ci.org/hrbrmstr/waffle) [![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/0.1.0/active.svg)](http://www.repostatus.org/#active) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/waffle)](http://cran.r-project.org/web/packages/waffle) ![downloads](http://cranlogs.r-pkg.org/badges/grand-total/waffle)

waffle is a package to make waffle charts (square pie charts)

It uses ggplot2 and returns a ggplot2 object.

The following functions are implemented:

-   `waffle` : make a waffle chart ggplot2 object
-   `iron` : vertically stitch together multiple waffle plots, left-aligning edges (best if used with the `waffle` `pad` parameter)

### News

-   Version `0.6.0` - keep factor levels; improve default aesthetics
-   Version `0.5.1` released - even moar improved ggplot2 compatibility
-   Version `0.5` released - new & improved ggplot2 compatibility
-   Version `0.4` released - added `use_glyph` and `glpyh_size` to `waffle` so you can now make isotype pictograms
-   Version `0.3` released - added a `pad` parameter to `waffle` to make it easier to align plots; added `iron` to make it easier to do the alignment
-   Version `0.2.3` released - nulled many margins and made the use of `coord_equal` optional via the `equal` parameter
-   Version `0.2.1` released - added Travis tests to ensure independent package build confirmation
-   Version `0.2` released - added `as_rcdimple` thx to Kent Russell (only in non-CRAN version)
-   Version `0.1` released

### Installation

``` r
install.packages("hrbrmstr/waffle")
```

### Usage

``` r
library(waffle)

# current version
packageVersion("waffle")
```

    ## [1] '0.6.0.9000'

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
library(extrafont)
waffle(parts/10, rows=3, colors=c("#969696", "#1879bf", "#009bda"),
       use_glyph="medkit", size=8)
```

![](README_files/figure-markdown_github/ww2-1.png)

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

### Keeps factor levels now

``` r
gridExtra::grid.arrange(
  waffle(c(thing1=0, thing2=100), rows=5),  
  waffle(c(thing1=25, thing2=75), rows=5)
)
```

![](README_files/figure-markdown_github/fct-1.png)

**Professional Workforce Makeup**

![](README_files/figure-markdown_github/f5-1.png)

Iron example (left-align & padding for multiple plots)

``` r
pain.adult.1997 <- c( `YOY (406)`=406, `Adult (24)`=24)
A <- waffle(pain.adult.1997/2, rows=7, size=0.5, 
       colors=c("#c7d4b6", "#a3aabd"), 
       title="Paine Run Brook Trout Abundance (1997)", 
       xlab="1 square = 2 fish", pad=3)

pine.adult.1997 <- c( `YOY (221)`=221, `Adult (143)`=143)
B <- waffle(pine.adult.1997/2, rows=7, size=0.5, 
                             colors=c("#c7d4b6", "#a3aabd"), 
                             title="Piney River Brook Trout Abundance (1997)", 
                             xlab="1 square = 2 fish", pad=8)

stan.adult.1997 <- c( `YOY (270)`=270, `Adult (197)`=197)
C <- waffle(stan.adult.1997/2, rows=7, size=0.5, 
                             colors=c("#c7d4b6", "#a3aabd"), 
                             title="Staunton River Trout Abundance (1997)", 
                             xlab="1 square = 2 fish")


iron(A, B, C)
```

![](README_files/figure-markdown_github/f8-1.png)

### Test Results

``` r
library(waffle)
library(testthat)

date()
```

    ## [1] "Wed Apr 20 10:03:39 2016"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 1 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
