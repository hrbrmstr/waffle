# Waffles mappings from css names to unicode chars was out of date
# This variation updates it from the latests css from github
.fa_unicode_init <- function() {

  fa_lib <- readLines(system.file("css", "fontawesome.css", package="waffle"))

  #Extract from CSS
  strings <- stringr::str_extract(fa_lib, ("(?<=fa-)(.*)(?=:before \\{)"))
  unicode <- stringr::str_extract(fa_lib, stringr::regex("(?<=content: \")(.*)(?=\")"))
  unicode <- stringr::str_replace(unicode, "\\\\", "")

  #remove NA lines
  strings <- strings[!is.na(strings)]
  unicode <- unicode[!is.na(unicode)]

  #Convert to unicdoe
  unicode <- as.character(parse(text=shQuote(stringr::str_c('\\u',unicode))))

  fa_unicode <- structure(unicode, .Names = strings)

  return(fa_unicode)

}

.fa_unicode <- .fa_unicode_init()

#' Search FontAwesome names for a pattern
#'
#' @param pattern pattern to search for in the names of FontAwesome fonts
#' @export
fa_grep <- function(pattern) { grep(pattern, names(.fa_unicode), value=TRUE) }

#' List all FontAwesome names
#'
#' @export
fa_list <- function() { print(names(.fa_unicode)) }
