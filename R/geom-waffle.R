draw_key_waffle <- function(data, params, size, ...) { # nocov start

  # msg("Called => draw_key_waffle()")
  #
  # print(str(data, 1))
  # print(str(params, 1))
  # print(str(size, 1))
  # print(str(list(...), 1))

  grid::roundrectGrob(
    r = min(params$radius, unit(3, "pt")),
    default.units = "native",
    width = 0.9, height = 0.9,
    name = "lkey",
    gp = grid::gpar(
      col = params[["color"]][[1]] %l0% params[["colour"]][1] %l0% data[["colour"]][[1]] %l0% "#00000000",
      fill = alpha(data$fill %||% data$colour %||% "grey20", data$alpha),
      lty = data$linetype %||% 1
    )
  )
} # nocov end

#' Waffle (Square pie chart) Geom
#'
#' There are two special/critical `aes()` mappings:
#' - `fill` (so the geom knows which column to map the fills to)
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
#' @param radius radius for round squares
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
#' @param geom geom to use (default is "waffle")
#' @param ... other arguments passed on to `layer()`. These are
#'   often aesthetics, used to set an aesthetic to a fixed value, like
#'   `color = "red"` or `size = 3`. They may also be parameters
#'   to the paired geom/stat.
#' @export
#' @examples
#' data.frame(
#'   parts = factor(rep(month.abb[1:3], 3), levels=month.abb[1:3]),
#'   vals = c(10, 20, 30, 6, 14, 40, 30, 20, 10),
#'   fct = c(rep("Thing 1", 3), rep("Thing 2", 3), rep("Thing 3", 3))
#' ) -> xdf
#'
#' ggplot(xdf, aes(fill = parts, values = vals)) +
#'   geom_waffle() +
#'   facet_wrap(~fct)
geom_waffle <- function(mapping = NULL, data = NULL,
                        n_rows = 10, make_proportional = FALSE, flip = FALSE,
                        na.rm = NA, show.legend = NA,
                        radius = grid::unit(0, "npc"),
                        inherit.aes = TRUE, ...) {

  # msg("Called => geom_waffle::geom_waffle()")
  # msg("Done With => geom_waffle::geom_waffle()")

  layer(
    stat = StatWaffle,
    data = data,
    mapping = mapping,
    geom = GeomWaffle,
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    check.param = FALSE,
    params = list(
      na.rm = na.rm,
      n_rows = n_rows,
      make_proportional = make_proportional,
      flip = flip,
      radius = radius,
      ...
    )
  )
}

#' @rdname geom_waffle
#' @export
GeomWaffle <- ggplot2::ggproto(
  `_class` = "GeomWaffle",
  `_inherit` = GeomRtile,

  default_aes = ggplot2::aes(
    fill = NA, alpha = NA, colour = NA,
    size = 0.125, linetype = 1, width = NA, height = NA
  ),

  draw_group = function(self, data, panel_params, coord,
                        n_rows = 10, make_proportional = FALSE, flip = FALSE,
                        radius = grid::unit(0, "npc")) {

    # msg("Called => GeomWaffle::draw_group()")

    coord <- ggplot2::coord_equal()
    grobs <- GeomRtile$draw_panel(data, panel_params, coord, radius)

    # msg("Done With => GeomWaffle::draw_group()")

    ggname("geom_waffle", grid::grobTree(children = grobs))

  },


  draw_panel = function(self, data, panel_params, coord,
                        n_rows = 10, make_proportional = FALSE, flip = FALSE,
                        radius = grid::unit(0, "npc")) {

    # msg("Called => GeomWaffle::draw_panel()")

    coord <- ggplot2::coord_equal()

    # grid::gList(
    grobs <- GeomRtile$draw_panel(data, panel_params, coord, radius)
    # ) -> grobs

    # msg("Done With => GeomWaffle::draw_panel()")

    ggname("geom_waffle", grid::grobTree(children = grobs))

  },

  draw_key = draw_key_waffle

)
