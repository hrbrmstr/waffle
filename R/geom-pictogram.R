picto_scale <- function(aesthetic, values = NULL, ...) {

  values <- if (is_missing(values)) "circle" else force(values)

  pal <- function(n) {
    vapply(
      if (n > length(values)) rep(values[[1]], n) else values,
      function(.x) .fa_unicode[.fa_unicode[["name"]] == .x, "unicode"],
      character(1),
      USE.NAMES = FALSE
    )
  }

  discrete_scale(aesthetic, "manual", pal, ...)
}

#' @export
scale_label_pictogram <- function(..., values, aesthetics = "label") {
  picto_scale(aesthetics, values, ...)
}

#' @export
draw_key_pictogram <- function(data, params, size) {

  # msg("==> draw_key_pictogram()")
  #
  # print(str(data, 1))
  # print(str(params, 1))

  if (is.null(data$label)) data$label <- "a"

  textGrob(
    label = data$label,
    x = 0.5, y = 0.5,
    rot = data$angle %||% 0,
    hjust = data$hjust %||% 0,
    vjust = data$vjust %||% 0.5,
    gp = gpar(
      col = alpha(data$colour %||% data$fill %||% "black", data$alpha),
      fontfamily = data$family %||% "",
      fontface = data$fontface %||% 1,
      fontsize = (data$size %||% 3.88) * .pt,
      lineheight = 1.5
    )
  )
}

#' @export
geom_pictogram <- function(mapping = NULL, data = NULL,
                           n_rows = 10, make_proportional = FALSE, flip = FALSE,
                           ..., na.rm = FALSE, show.legend = NA, inherit.aes = TRUE) {

  layer(
    data = data,
    mapping = mapping,
    stat = "waffle",
    geom = "pictogram",
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      n_rows = n_rows,
      make_proportional = make_proportional,
      flip = flip,
      ...
    )
  )
}

#' @export
GeomPictogram <- ggplot2::ggproto(
  `_class` = "GeomPictogram",
  `_inherit` = GeomText,

  #  required_aes = c("x", "y", "label", "colour"),

  default_aes = aes(
    fill = NA, alpha = NA, colour = "black",
    size = 9, angle = 0, hjust = 0.5, vjust = 0.5,
    family = "FontAwesome5Free-Solid", fontface = 1, lineheight = 1
  ),


  draw_group = function(self, data, panel_params, coord,
                        n_rows = 10, make_proportional = FALSE, flip = FALSE,
                        radius = grid::unit(0, "npc")) {

    # msg("Called => GeomPictogram::draw_group()")

    coord <- ggplot2::coord_equal()
    grobs <- GeomText$draw_panel(data, panel_params, coord, parse = FALSE, check_overlap = FALSE)

    # msg("Done With => GeomPictogram::draw_group()")

    ggname("geom_pictogram", grid::grobTree(children = grobs))

  },


  draw_panel = function(self, data, panel_params, coord,
                        n_rows = 10, make_proportional = FALSE, flip = FALSE, ...) {

    # msg("Called => GeomPictogram::draw_panel()")
    # print(str(data, 1))

    coord <- ggplot2::coord_equal()
    grobs <- GeomText$draw_panel(data, panel_params, coord, parse = FALSE, check_overlap = FALSE)

    # msg("Done With => GeomPictogram::draw_panel()")

    ggname("geom_pictogram", grid::grobTree(children = grobs))

  },

  draw_key = draw_key_pictogram

)
