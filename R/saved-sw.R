# # @rdname geom_waffle
# # @export
# stat_waffle<- function(mapping = NULL, data = NULL,
#                        n_rows = 10, make_proportional = FALSE,
#                        na.rm = NA, show.legend = NA,
#                        inherit.aes = TRUE, ...) {
#
#   layer(
#     stat = StatWaffle,
#     data = data,
#     mapping = mapping,
#     geom = "waffle",
#     position = "identity",
#     show.legend = show.legend,
#     inherit.aes = inherit.aes,
#     params = list(
#       na.rm = na.rm,
#       n_rows = n_rows,
#       make_proportional = make_proportional,
#       ...
#     )
#   )
# }
#
# # @rdname geom_waffle
# # @export
# StatWaffle <- ggplot2::ggproto(
#   `_class` = "StatWaffle",
#   `_inherit` = ggplot2::Stat,
#
#   required_aes = c("fill", "values"),
#
#   compute_layer = function(self, data, params, panels) {
#
#     if (inherits(data[["fill"]], "factor")) {
#       flvls <- levels(data[["fill"]])
#     } else {
#       flvls <- levels(factor(data[["fill"]]))
#     }
#
#     p <- split(data, data$PANEL)
#
#     lapply(p, function(.x) {
#
#       parts_vec <- unlist(sapply(1:length(.x[["fill"]]), function(i) {
#         rep(as.character(.x[["fill"]][i]), .x[["values"]][i])
#       }))
#
#       pgrp_vec <- unlist(sapply(1:length(.x[["fill"]]), function(i) {
#         rep(.x$group, .x[["values"]][i])
#       }))
#
#       expand.grid(
#         y = 1:params$n_rows,
#         x = seq_len((ceiling(sum(.x[["values"]]) / params$n_rows)))#,
#         # stringsAsFactors = FALSE
#       ) -> tdf
#
#       parts_vec <- c(parts_vec, rep(NA, nrow(tdf)-length(parts_vec)))
#
#       # tdf$parts <- parts_vec
#       tdf[["values"]] <- NA
#       tdf[["fill"]] <- parts_vec
#       tdf[["PANEL"]] <- .x[["PANEL"]][1]
#       tdf[["group"]] <- 1:nrow(tdf)
#
#       tdf <- tdf[sapply(tdf[["fill"]], function(x) !is.na(x)),]
#
#     }) -> p
#
#     p <- plyr::rbind.fill(p)
#     p[["fill"]] <- factor(p[["fill"]], levels=flvls)
#
#     # print(str(p))
#
#     p
#
#   },
#
#   compute_panel = function(self, data, scales, na.rm = FALSE,
#                            n_rows = 10, make_proportional = FALSE) {
#
#     # message("Called STAT compute_panel()")
#
#     ggproto_parent(Stat, self)$compute_panel(data, scales,
#                                              n_rows = 10,
#                                              make_proportional = FALSE)
#
#   }
#
# )
