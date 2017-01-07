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
#' # print chart
#' ## iron(w1, w2, w3)
iron <- function(...) {
  grob_list <- list(...)
  grid.newpage()
  grid.draw(do.call("rbind_gtable_max", lapply(grob_list, ggplotGrob)))
}
