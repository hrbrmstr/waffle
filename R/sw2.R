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
#' - `fill` (so the geom knows which column to map the country names/abbrevs to)
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
#' @param radius radius
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
                        n_rows = 10, make_proportional = FALSE,
                        na.rm = NA, show.legend = NA, flip = FALSE,
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

#' @rdname geom_waffle
#' @export
stat_waffle <- function(mapping = NULL, data = NULL, geom = "blank",
                        n_rows = 10, make_proportional = FALSE, flip = FALSE,
                        radius = grid::unit(0, "npc"),
                        na.rm = NA, show.legend = NA,
                        inherit.aes = TRUE, ...) {

  # msg("Called => stat_waffle::stat_waffle()")
  # msg("Done With => stat_waffle::stat_waffle()")

  layer(
    stat = StatWaffle,
    data = data,
    mapping = mapping,
    geom = geom,
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
StatWaffle <- ggplot2::ggproto(

  `_class` = "StatWaffle",
  `_inherit` = ggplot2::Stat,

  extra_params = c("na.rm", "n_rows", "make_proportional", "flip", "radius"),

  required_aes = c("fill", "values", "colour"),

  setup_params = function(data, params) {
    # msg("Called => StatWaffle::setup_params()")
    # msg("Done With => StatWaffle::setup_params()")
    params
  },

  setup_data = function(data, params) {

    # msg("Called => StatWaffle::setup_data()")
    #
    # print(str(data, 1))
    # print(str(params, 1))

    use <- "fill"

    if (inherits(data[[use]], "factor")) {
      flvls <- levels(data[[use]])
    } else {
      flvls <- levels(factor(data[[use]]))
    }

    if (inherits(data[["colour"]], "factor")) {
      clvls <- levels(data[["colour"]])
    } else {
      clvls <- levels(factor(data[["colour"]]))
    }

    if (!("colour" %in% names(data))) {
      data[["colour"]] <- "white"
    } else {
      if (any(is.na(as.character(data[["colour"]])))) {
        data[["colour"]] <- "white"
      } else {
        data[["colour"]] <- as.character(data[["colour"]])
      }
    }

    p <- split(data, data$PANEL)

    lapply(p, function(.x) {

      if (params[["make_proportional"]]) {
        .x[["values"]] <- .x[["values"]] / sum(.x[["values"]])
        .x[["values"]] <- round_preserve_sum(.x[["values"]], digits = 2)
        .x[["values"]] <- as.integer(.x[["values"]] * 100)
      }

      parts_vec <- unlist(sapply(1:length(.x[[use]]), function(i) {
        rep(as.character(.x[[use]][i]), .x[["values"]][i])
      }))

      pgrp_vec <- unlist(sapply(1:length(.x[[use]]), function(i) {
        rep(.x$group, .x[["values"]][i])
      }))

      # print(str(.x, 1))

      colour_vec <- unlist(sapply(1:length(.x[[use]]), function(i) {
        rep(.x[["colour"]][i], .x[["values"]][i])
      }))

      expand.grid(
        y = 1:params$n_rows,
        x = seq_len((ceiling(sum(.x[["values"]]) / params$n_rows)))#,
        # stringsAsFactors = FALSE
      ) -> tdf

      parts_vec <- c(parts_vec, rep(NA, nrow(tdf)-length(parts_vec)))
      colour_vec <- c(colour_vec, rep(NA, nrow(tdf)-length(colour_vec)))

      # tdf$parts <- parts_vec
      tdf[["values"]] <- NA
      tdf[["colour"]] <- colour_vec
      tdf[[use]] <- parts_vec
      tdf[["PANEL"]] <- .x[["PANEL"]][1]
      tdf[["group"]] <- 1:nrow(tdf)

      tdf <- tdf[sapply(tdf[[use]], function(x) !is.na(x)),]

    }) -> p

    p <- plyr::rbind.fill(p)
    p[[use]] <- factor(p[[use]], levels=flvls)
    p[["colour"]] <- factor(p[["colour"]], levels = clvls)

    # print(str(p, 1))
    #
    # msg("Done With => StatWaffle::setup_data()")
    # data

    wdat <- p

    if (params$flip) {
      x_temp <- wdat$x
      wdat$x <- wdat$y
      wdat$y <- x_temp
      x_temp <- NULL
    }

    wdat$width <- wdat$width %||% params$width %||% ggplot2::resolution(wdat$x, FALSE)
    wdat$height <- wdat$height %||% params$height %||% ggplot2::resolution(wdat$y, FALSE)

    transform(
      wdat,
      xmin = x - width / 2,
      xmax = x + width / 2,
      width = NULL,
      ymin = y - height / 2,
      ymax = y + height / 2,
      height = NULL
    ) -> p

    p

  },

  compute_layer = function(self, data, params, layout) {
    # msg("Called => StatWaffle::compute_layer()")
    # print(str(data, 1))
    # print(str(params, 1))
    # msg("Done With => StatWaffle::compute_layer()")
    data
  },

  finish_layer = function(self, data, params) {
    # msg("Called => StatWaffle::finish_layer()")
    # msg("Done With => StatWaffle::finish_layer()")
    data
  },

  compute_panel = function(self, data, scales, ...) {
    # msg("Called => StatWaffle::compute_panel()")
    # msg("Done With => StatWaffle::compute_panel()")
    data
  }

)




















