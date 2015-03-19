
rbind_gtable_max <- function(...){

  gtl <- list(...)
  stopifnot(all(sapply(gtl, is.gtable)))
  bind2 <- function (x, y)
  {
    stopifnot(ncol(x) == ncol(y))
    if (nrow(x) == 0)
      return(y)
    if (nrow(y) == 0)
      return(x)
    y$layout$t <- y$layout$t + nrow(x)
    y$layout$b <- y$layout$b + nrow(x)
    x$layout <- rbind(x$layout, y$layout)
    x$heights <- gtable:::insert.unit(x$heights, y$heights)
    x$rownames <- c(x$rownames, y$rownames)
    x$widths <- grid::unit.pmax(x$widths, y$widths)
    x$grobs <- append(x$grobs, y$grobs)
    x
  }

  Reduce(bind2, gtl)
}

cbind_gtable_max <- function(...){

  gtl <- list(...)
  stopifnot(all(sapply(gtl, is.gtable)))
  bind2 <- function (x, y)
  {
    stopifnot(nrow(x) == nrow(y))
    if (ncol(x) == 0)
      return(y)
    if (ncol(y) == 0)
      return(x)
    y$layout$l <- y$layout$l + ncol(x)
    y$layout$r <- y$layout$r + ncol(x)
    x$layout <- rbind(x$layout, y$layout)
    x$widths <- gtable:::insert.unit(x$widths, y$widths)
    x$colnames <- c(x$colnames, y$colnames)
    x$heights <- grid::unit.pmax(x$heights, y$heights)
    x$grobs <- append(x$grobs, y$grobs)
    x
  }
  Reduce(bind2, gtl)
}

#' Veritical, left-aligned layout for waffle plots
#'
#' Uses a technique provided in \url{http://stackoverflow.com/a/13295880/1457051}
#' to left-align the waffle plots by x-axis. Use the \code{pad} parameter in
#' \code{waffle} to pad each plot to the max width (num of squares), otherwise
#' the plots will be scaled.
#'
#' @param ... one or more waffle plots
#' @export
iron <- function(...) {
  grob_list <- list(...)
  grid.newpage()
  grid.draw(do.call("rbind_gtable_max", lapply(grob_list, ggplotGrob)))
}
