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

#' Used with geom_pictogram() to map Font Awesome fonts to labels
#'
#' @param ... dots
#' @param values values
#' @param aesthetics aesthetics
#' @export
scale_label_pictogram <- function(..., values, aesthetics = "label") {
  picto_scale(aesthetics, values, ...)
}

#' Legend builder for pictograms
#'
#' @param data,params,size legend key things
#' @keywords internal
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

#' Pictogram Geom
#'
#' There are two special/critical `aes()` mappings:
#' - `label` (so the geom knows which column to map the glyphs to)
#' - `values` (which column you're mapping the filling for the squares with)
#'
#' @md
#' @param mapping Set of aesthetic mappings created by `aes()` or
#'   `aes_()`. If specified and `inherit.aes = TRUE` (the
#'   default), it is combined with the default mapping at the top level of the
#'   plot. You must supply `mapping` if there is no plot mapping.
#' @param n_rows how many rows should there be in the waffle chart? default is 10
#' @param flip If `TRUE`, flip x and y coords. n_rows then becomes n_cols.
#'     Useful to achieve waffle column chart effect. Defaults is `FALSE`.
#' @param make_proportional compute proportions from the raw values? (i.e. each
#'        value `n` will be replaced with `n`/`sum(n)`); default is `FALSE`.
#' @param data The data to be displayed in this layer. There are three
#'    options:
#'
#'    If `NULL`, the default, the data is inherited from the plot
#'    data as specified in the call to `ggplot()`.
#'
#'    A `data.frame`, or other object, will override the plot
#'    data. All objects will be fortified to produce a data frame. See
#'    `fortify()` for which variables will be created.
#'
#'    A `function` will be called with a single argument,
#'    the plot data. The return value must be a `data.frame.`, and
#'    will be used as the layer data.
#' @param na.rm If `FALSE`, the default, missing values are removed with
#'   a warning. If `TRUE`, missing values are silently removed.
#' @param show.legend logical. Should this layer be included in the legends?
#'   `NA`, the default, includes if any aesthetics are mapped.
#'   `FALSE` never includes, and `TRUE` always includes.
#'   It can also be a named logical vector to finely select the aesthetics to
#'   display.
#' @param inherit.aes If `FALSE`, overrides the default aesthetics,
#'   rather than combining with them. This is most useful for helper functions
#'   that define both data and aesthetics and shouldn't inherit behaviour from
#'   the default plot specification, e.g. `borders()`.
#' @param ... other arguments passed on to `layer()`. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `color = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
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

#' @rdname geom_pictogram
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
