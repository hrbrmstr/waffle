# Waffles mappings from css names to unicode chars was out of date
# This variation updates it from the latests css from github
.fa_unicode_init <- function() {

  # fa_lib <- readLines(system.file("css", "fontawesome.css", package="waffle"))

  # fa_json <- jsonlite::fromJSON(system.file("json", "icons.json", package="waffle"))
  #
  # data.frame(
  #   name = names(fa_json),
  #   type = vapply(fa_json, function(.x, wat) .x[[wat]][[1]],
  #                 character(1), "free", USE.NAMES = FALSE),
  #   unicode = vapply(fa_json, function(.x, wat) .x[[wat]][[1]],
  #                    character(1), "unicode", USE.NAMES = FALSE),
  #   stringsAsFactors = FALSE
  # ) -> fa_df
  #
  # vapply(
  #   seq_along(fa_df[["name"]]),
  #   function(.i) {
  #     # name <- fa_df[.i, "name"]
  #     type <- fa_df[.i, "type"]
  #     fa_json[[.i]][["svg"]][[type]][["raw"]]
  #   },
  #   character(1), USE.NAMES = FALSE
  # ) -> fa_df[["glyph"]]
  #
  # fa_df[["unicode"]] <- as.character(
  #   parse(text = shQuote(stringr::str_c('\\u', fa_df[["unicode"]])))
  # )
  #
  # fa_df <- fa_df[complete.cases(fa_df),]
  #
  # return(fa_df)
  #

  return(readRDS(system.file("extdat/fadf.rds", package = "waffle")))

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
