# Waffles mappings from css names to unicode chars was out of date
# This variation updates it from the latests css from github
.fa_unicode_init <- function() {

  xdf <- readRDS(system.file("extdat/fadf.rds", package = "waffle"))
  xdf[xdf[["type"]] != "regular", ]

}

.fa_unicode <- .fa_unicode_init()

.display_fa <- function(fdf) {
  vb <- stringr::str_match(fdf[["glyph"]], '(viewBox="[^"]+")')[,2]
  stringr::str_replace(
    fdf[["glyph"]],
    vb,
    sprintf('%s width="24" height="24"', vb)
  ) -> fdf[["glyph"]]
  DT::datatable(fdf[,c("name", "type", "glyph")], escape = FALSE)
}

#' Search Font Awesome glyph names for a pattern
#'
#' @param pattern pattern to search for in the names of Font Awesome fonts
#' @export
fa_grep <- function(pattern) {
  res <- which(grepl(pattern, .fa_unicode[["name"]]))
  if (length(res)) {
    .display_fa(.fa_unicode[res, ])
  } else {
    message("No Font Awesome font found with that name pattern.")
  }
}

#' List all Font Awesome glyphs
#'
#' @export
fa_list <- function() {
  .display_fa(.fa_unicode)
}

#' Install Font Awesome 5 Fonts
#'
#' @export
install_fa_fonts <- function() {
  message(
    "The TTF font files for Font Awesome 5 fonts are in:\n\n",
    system.file("fonts", package = "waffle"),
    "\n\nPlease navigate to that directory and install them on ",
    "your system."
  )
}

#' Font Awesome 5 Solid
#'
#' @description `fa5_solid` is shorthand for "`FontAwesome5Free-Solid`"
#' @docType data
#' @export
fa5_solid <- "FontAwesome5Free-Solid"

#' Font Awesome 5 Brand
#'
#' @description `fa5_brand` is shorthand for "`FontAwesome5Brands-Regular`"
#' @docType data
#' @export
fa5_brand <- "FontAwesome5Brands-Regular"









