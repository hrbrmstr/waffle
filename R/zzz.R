load_fontawesome <- function() {
  suppressWarnings(
    suppressMessages(
      extrafont::font_import(
        paths = system.file("fonts", package = "waffle"),
        recursive = FALSE,
        prompt = FALSE
      )
    )
  )
}