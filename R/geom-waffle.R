# #' Waffle (Square pie chart) Geom
# #'
# #' There are two special/critical `aes()` mappings:
# #' - `fill` (so the geom knows which column to map the country names/abbrevs to)
# #' - `values` (which column you're mapping the filling for the squares with)
# #'
# #' @md
# #' @param mapping Set of aesthetic mappings created by `aes()` or
# #'   `aes_()`. If specified and `inherit.aes = TRUE` (the
# #'   default), it is combined with the default mapping at the top level of the
# #'   plot. You must supply `mapping` if there is no plot mapping.
# #' @param n_rows how many rows should there be in the waffle chart? default is 10
# #' @param flip If `TRUE`, flip x and y coords. n_rows then becomes n_cols.
# #'     Useful to achieve waffle column chart effect. Defaults is `FALSE`.
# #' @param make_proportional compute proportions from the raw values? (i.e. each
# #'        value `n` will be replaced with `n`/`sum(n)`); default is `FALSE`.
# #' @param data The data to be displayed in this layer. There are three
# #'    options:
# #'
# #'    If `NULL`, the default, the data is inherited from the plot
# #'    data as specified in the call to `ggplot()`.
# #'
# #'    A `data.frame`, or other object, will override the plot
# #'    data. All objects will be fortified to produce a data frame. See
# #'    `fortify()` for which variables will be created.
# #'
# #'    A `function` will be called with a single argument,
# #'    the plot data. The return value must be a `data.frame.`, and
# #'    will be used as the layer data.
# #' @param na.rm If `FALSE`, the default, missing values are removed with
# #'   a warning. If `TRUE`, missing values are silently removed.
# #' @param show.legend logical. Should this layer be included in the legends?
# #'   `NA`, the default, includes if any aesthetics are mapped.
# #'   `FALSE` never includes, and `TRUE` always includes.
# #'   It can also be a named logical vector to finely select the aesthetics to
# #'   display.
# #' @param inherit.aes If `FALSE`, overrides the default aesthetics,
# #'   rather than combining with them. This is most useful for helper functions
# #'   that define both data and aesthetics and shouldn't inherit behaviour from
# #'   the default plot specification, e.g. `borders()`.
# #' @param ... other arguments passed on to `layer()`. These are
# #'   often aesthetics, used to set an aesthetic to a fixed value, like
# #'   `color = "red"` or `size = 3`. They may also be parameters
# #'   to the paired geom/stat.
# #' @export
# #' @examples
# #' data.frame(
# #'   parts = factor(rep(month.abb[1:3], 3), levels=month.abb[1:3]),
# #'   values = c(10, 20, 30, 6, 14, 40, 30, 20, 10),
# #'   fct = c(rep("Thing 1", 3), rep("Thing 2", 3), rep("Thing 3", 3))
# #' ) -> xdf
# #'
# #' ggplot(xdf, aes(fill = parts, values = values)) +
# #'   geom_waffle() +
# #'   facet_wrap(~fct) +
# #'   coord_equal()
# geom_waffle <- function(
#   mapping = NULL, data = NULL,
#   n_rows = 10, flip = FALSE, make_proportional = FALSE,
#   na.rm = TRUE, show.legend = NA, inherit.aes = TRUE, ...) {
#
#   ggplot2::layer(
#     data = data,
#     mapping = mapping,
#     stat = "waffle",
#     geom = GeomWaffle,
#     position = "identity",
#     show.legend = show.legend,
#     inherit.aes = inherit.aes,
#     params = list(
#       na.rm = TRUE,
#       n_rows = n_rows,
#       flip = flip,
#       make_proportional = make_proportional,
#       use = "fill",
#       ...
#     )
#   )
#
# }
#
# #' @rdname geom_waffle
# #' @export
# GeomWaffle <- ggplot2::ggproto(
#   `_class` = "GeomWaffle",
#   `_inherit` = ggplot2::Geom,
#
#   default_aes = ggplot2::aes(
#     values = "values",
#     fill = NA, colour = "#b2b2b2", alpha = NA,
#     size = 0.125, linetype = 1, width = NA, height = NA
#   ),
#
#   required_aes = c("x", "y"),
#
#   extra_params = c("na.rm", "width", "height", "flip", "use"),
#
#   setup_data = function(data, params) {
#
#     # message("Called GEOM setup_data()")
#
#     waf.dat <- data #data.frame(data)#, stringsAsFactors=FALSE)
#
#     # swap x and y values if flip is TRUE
#     if (params$flip) {
#       waf.dat$x_temp <- waf.dat$x
#       waf.dat$x <- waf.dat$y
#       waf.dat$y <- waf.dat$x_temp
#       waf.dat$x_temp <- NULL
#     }
#
#     # reduce all values by 0.5
#     # this allows for axis ticks to align _between_ square rows/cols
#     # rather than in the middle of a row/col
#     waf.dat$x <- waf.dat$x - .5
#     waf.dat$y <- waf.dat$y - .5
#
#     waf.dat$width <- waf.dat$width %||% params$width %||% ggplot2::resolution(waf.dat$x, FALSE)
#     waf.dat$height <- waf.dat$height %||% params$height %||% ggplot2::resolution(waf.dat$y, FALSE)
#
#     transform(
#       waf.dat,
#       xmin = x - width / 2,  xmax = x + width / 2,  width = NULL,
#       ymin = y - height / 2, ymax = y + height / 2, height = NULL
#     ) -> xdat
#
#     xdat
#
#   },
#
#   draw_group = function(self, data, panel_params, coord,
#                         n_rows = 10, make_proportional = FALSE) {
#
#     # message("Called GEOM draw_group()")
#
#     tile_data <- data
#     # tile_data$size <- border_size
#     # tile_data$colour <- border_col
#
#     coord <- ggplot2::coord_equal()
#
#     grid::gList(
#       GeomTile$draw_panel(tile_data, panel_params, coord)
#     ) -> grobs
#
#     ggname("geom_waffle", grid::grobTree(children = grobs))
#
#   },
#
#   draw_key = ggplot2::draw_key_polygon
#
# )


