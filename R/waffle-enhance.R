#' Waffle chart theme cruft remover that can be used with any other theme
#'
#' Removes:
#'
#' - panel grid
#' - all axis text
#' - all axis ticks
#' - all axis titles
#'
#' @md
#' @export
theme_enhance_waffle<- function() {

  ret <- theme(panel.grid = element_blank())
  ret <- ret + theme(axis.text = element_blank())
  ret <- ret + theme(axis.text.x = element_blank())
  ret <- ret + theme(axis.text.y = element_blank())
  ret <- ret + theme(axis.title = element_blank())
  ret <- ret + theme(axis.title.x = element_blank())
  ret <- ret + theme(axis.title.x.top = element_blank())
  ret <- ret + theme(axis.title.x.bottom = element_blank())
  ret <- ret + theme(axis.title.y = element_blank())
  ret <- ret + theme(axis.title.y.left = element_blank())
  ret <- ret + theme(axis.title.y.right = element_blank())

  ret

}