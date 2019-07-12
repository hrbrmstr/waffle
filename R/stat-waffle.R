#' @rdname geom_waffle
#' @export
stat_waffle <- function(mapping = NULL, data = NULL, geom = "waffle",
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

  required_aes = c("fill", "values", "colour", "label"),

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

    use <- if ("label" %in% names(data)) "label" else "fill"

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
      if ("colour" %in% names(params)) {
        data[["colour"]] <- params[["colour"]]
      } else {
        data[["colour"]] <- "white"
      }
      clvls <- levels(factor(data[["colour"]]))
    } else {
      if (any(is.na(as.character(data[["colour"]])))) {
        data[["colour"]] <- "white"
        clvls <- levels(factor(data[["colour"]]))
      } else {
        data[["colour"]] <- as.character(data[["colour"]])
      }
    }

    # msg("       => StatWaffle::setup_data() : colour")
    # print(str(data, 1))

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
        rep(.x[["group"]], .x[["values"]][i])
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
