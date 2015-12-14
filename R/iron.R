# VIA: http://stackoverflow.com/q/13294952/1457051

rbind_gtable_max <- function(...) {

  gtl <- list(...)
  stopifnot(all(sapply(gtl, is.gtable)))
  bind2 <- function (x, y) {
    stopifnot(ncol(x) == ncol(y))
    if (nrow(x) == 0)
      return(y)
    if (nrow(y) == 0)
      return(x)
    y$layout$t <- y$layout$t + nrow(x)
    y$layout$b <- y$layout$b + nrow(x)
    x$layout <- rbind(x$layout, y$layout)
    x$heights <- insert_unit(x$heights, y$heights)
    x$rownames <- c(x$rownames, y$rownames)
    x$widths <- unit.pmax(x$widths, y$widths)
    x$grobs <- append(x$grobs, y$grobs)
    x
  }
  Reduce(bind2, gtl)

}

cbind_gtable_max <- function(...) {

  gtl <- list(...)
  stopifnot(all(sapply(gtl, is.gtable)))
  bind2 <- function (x, y) {
    stopifnot(nrow(x) == nrow(y))
    if (ncol(x) == 0)
      return(y)
    if (ncol(y) == 0)
      return(x)
    y$layout$l <- y$layout$l + ncol(x)
    y$layout$r <- y$layout$r + ncol(x)
    x$layout <- rbind(x$layout, y$layout)
    x$widths <- insert_unit(x$widths, y$widths)
    x$colnames <- c(x$colnames, y$colnames)
    x$heights <- unit.pmax(x$heights, y$heights)
    x$grobs <- append(x$grobs, y$grobs)
    x
  }
  Reduce(bind2, gtl)

}

insert_unit <- function (x, values, after = length(x)) {
    lengx <- length(x)
    if (lengx == 0)
        return(values)
    if (length(values) == 0)
        return(x)
    if (after <= 0) {
        unit.c(values, x)
    }
    else if (after >= lengx) {
        unit.c(x, values)
    }
    else {
        unit.c(x[1L:after], values, x[(after + 1L):lengx])
    }
}

#' Veritical, left-aligned layout for waffle plots
#'
#' Left-align the waffle plots by x-axis. Use the \code{pad} parameter in
#' \code{waffle} to pad each plot to the max width (num of squares), otherwise
#' the plots will be scaled.
#'
#' @param ... one or more waffle plots
#' @export
#' @examples
#' parts <- c(80, 30, 20, 10)
#' w1 <- waffle(parts, rows=8)
#' w2 <- waffle(parts, rows=8)
#' w3 <- waffle(parts, rows=8)
#' chart <- iron(w1, w2, w3)
#' # print chart
iron <- function(...) {
  grob_list <- list(...)
  grid.newpage()
  grid.draw(do.call("rbind_gtable_max", lapply(grob_list, ggplotGrob)))
}
