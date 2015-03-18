#' @export
waffle <- function(parts, rows=10, xlab=NULL, title=NULL, colors=NA, size=2, flip=FALSE, reverse=FALSE) {

  require(ggplot2)
  require(RColorBrewer)

  part_names <- names(parts)
  if (length(part_names) < length(parts)) {
    part_names <- c(part_names, LETTERS[1:length(parts)-length(part_names)])
  }

  if (all(is.na(colors))) {
    colors <- brewer.pal(length(parts), "Set2")
  }

  parts_vec <- unlist(sapply(1:length(parts), function(i) {
    rep(LETTERS[i+1], parts[i])
  }))

  if (reverse) { parts_vec <- rev(parts_vec) }

  dat <- expand.grid(y=1:rows, x=seq_len(ceiling(sum(parts) / rows)))

  dat$value <- c(parts_vec, rep(NA, nrow(dat)-length(parts_vec)))

  if (flip) {
    gg <- ggplot(dat, aes(x=y, y=x, fill=value))
  } else {
    gg <- ggplot(dat, aes(x=x, y=y, fill=value))
  }

  gg <- gg + geom_tile(color="white", size=size)
  gg <- gg + coord_equal()
  gg <- gg + labs(x=xlab, y=NULL, title=title)
  gg <- gg + scale_x_continuous(expand=c(0, 0))
  gg <- gg + scale_y_continuous(expand=c(0, 0))
  gg <- gg + scale_fill_manual(name="",
                               values=colors,
                               labels=part_names)
  gg <- gg + guides(fill=guide_legend(override.aes=list(colour=NULL)))
  gg <- gg + coord_equal()
  gg <- gg + theme_bw()
  gg <- gg + theme(panel.grid=element_blank())
  gg <- gg + theme(panel.border=element_blank())
  gg <- gg + theme(axis.text=element_blank())
  gg <- gg + theme(axis.title.x=element_text(size=10))
  gg <- gg + theme(axis.ticks=element_blank())
  gg <- gg + theme(plot.title=element_text(size=18))

  gg

}