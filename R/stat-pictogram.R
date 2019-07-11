#' @rdname geom_pictogram
#' @export
stat_pictogram <- function(mapping = NULL, data = NULL,
                       n_rows = 10, make_proportional = FALSE,
                       na.rm = NA, show.legend = NA,
                       inherit.aes = TRUE, ...) {

  layer(
    stat = StatPictogram,
    data = data,
    mapping = mapping,
    geom = "pictogram",
    position = "identity",
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      n_rows = n_rows,
      make_proportional = make_proportional,
      ...
    )
  )
}

#' @rdname geom_pictogram
#' @export
StatPictogram <- ggplot2::ggproto(
  `_class` = "StatPictogram",
  `_inherit` = ggplot2::Stat,

  required_aes = c("colour", "values", "fa_type", "fa_glyph"),
  extra_params = c("na.rm", "width", "height", "flip", "use"),

  setup_params = function(data, params) {
    # message("Called StatPictogram::setup_params()")
    params
  },

  setup_data = function(data, params) {
    # message("Called StatPictogram::setup_data()")
    # print(str(data, 1))
    data
  },

  compute_layer = function(self, data, params, panels) {

    # message("Called StatPictogram::compute_layer()")
    # print(str(data, 1))

    use <- params[["use"]]

    if (inherits(data[[use]], "factor")) {
      flvls <- levels(data[[use]])
    } else {
      flvls <- levels(factor(data[[use]]))
    }

    tr1 <- data[c(use, "fa_glyph", "fa_type")]
    tr1 <- tr1[!duplicated(tr1), ]

    gtrans <- tr1[, "fa_glyph"]
    names(gtrans) <- tr1[, use]

    ttrans <- tr1[, "fa_type"]
    names(ttrans) <- tr1[, use]

    # print(str(tr1, 1))

    p <- split(data, data$PANEL)

    lapply(p, function(.x) {

      parts_vec <- unlist(sapply(1:length(.x[[use]]), function(i) {
        rep(as.character(.x[[use]][i]), .x[["values"]][i])
      }))

      pgrp_vec <- unlist(sapply(1:length(.x[[use]]), function(i) {
        rep(.x$group, .x[[use]][i])
      }))

      expand.grid(
        y = 1:params$n_rows,
        x = seq_len((ceiling(sum(.x[["values"]]) / params$n_rows)))#,
        # stringsAsFactors = FALSE
      ) -> tdf

      parts_vec <- c(parts_vec, rep(NA, nrow(tdf) - length(parts_vec)))

      # tdf$parts <- parts_vec
      tdf[["values"]] <- parts_vec
      tdf[[use]] <- parts_vec

      tdf[["fa_glyph"]] <- gtrans[tdf[[use]]]
      tdf[["fa_type"]] <- ttrans[tdf[[use]]]

      tdf[["PANEL"]] <- .x[["PANEL"]][1]
      tdf[["group"]] <- 1:nrow(tdf)

      tdf <- tdf[sapply(tdf[[use]], function(x) !is.na(x)),]

      tdf

    }) -> p

    p <- plyr::rbind.fill(p)
    p[[use]] <- factor(p[[use]], levels=flvls)

    # print(str(p, 1))

    p

  },

  finish_layer = function(self, data, params) {
    # message("Called StatPictogram::finish_layer()")
    self$default_aes[["fa_glyph"]] <- "square"
    # print(str(data,1))
    # print(str(params, 1))
    data
  },

  compute_panel = function(self, data, scales, na.rm = FALSE,
                           n_rows = 10, make_proportional = FALSE) {

    # message("Called StatPictogram::compute_panel()")

    ggproto_parent(Stat, self)$compute_panel(
      data, scales,
      n_rows = n_rows,
      make_proportional = make_proportional,
      na.rm = na.rm
    )

  },

  aesthetics = function(self) {
    # message("Called StatPictogram::aesthetics()")
    c(union(self$required_aes, names(self$default_aes)), "group")
  }


)
