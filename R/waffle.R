#' Make waffle (square pie) charts
#'
#' Given a named vector or a data frame, this function will return a ggplot object that
#' represents a waffle chart of the values. The individual values will be
#' summed up and each that will be the total number of squares in the grid.
#' You can perform appropriate value transformation ahead of time to get the
#' desired waffle layout/effect.
#'
#' If a data frame is used, the first two columns should contain the desired names
#' and the values, respectively.
#'
#' If the vector is not named or only partially named, capital letters will be
#' used instead.
#'
#' It is highly suggested that you limit the number of elements
#' to plot, just like you should if you ever got wasted and decided that a
#' regular pie chart was a good thing to create and then decide to be totally
#' evil and make one to pollute this beautiful world of ours.
#'
#' Chart title and x-axis labels are optional, especially if you'll just be
#' exporting to another program for use/display.
#'
#' If you specify a string (vs `FALSE`) to `use_glyph` the function
#' will map the input to a Font Awesome glyph name and use that glyph for the
#' tile instead of a block (making it more like an isotype pictogram than a
#' waffle chart). You'll need to install Font Awesome 5 and use
#' the [`extrafont` package](`https://github.com/wch/extrafont`) to
#' be able to use Font Awesome 5 glyphs. Sizing is also up to the user since
#' fonts do not automatically scale with graphic resize.
#'
#' Glyph idea inspired by Ruben C. Arslan (@@_r_c_a)
#'
#' @md
#' @note You MUST use the Font Awesome 5 fonts bundled with the package.
#'       See [install_fa_fonts()].
#' @param parts named vector of values or a data frame to use for the chart
#' @param rows number of rows of blocks
#' @param keep keep factor levels (i.e. for consistent legends across waffle plots)
#' @param xlab text for below the chart. Highly suggested this be used to
#'     give the "1 sq == xyz" relationship if it's not obvious
#' @param title chart title
#' @param colors exactly the number of colors as values in `parts.`
#'     If omitted, Color Brewer "Set2" colors are used.
#' @param size width of the separator between blocks (defaults to `2`)
#' @param flip flips x & y axes
#' @param reverse reverses the order of the data
#' @param equal by default, waffle uses `coord_equal`; this can cause
#'     layout problems, so you an use this to disable it if you are using
#'     ggsave or knitr to control output sizes (or manually sizing the chart)
#' @param pad how many blocks to right-pad the grid with
#' @param use_glyph use specified glyph; if using built-in Font Awesome, can be
#'        the glyph name; otherwise, it must be the unicode glyph from the custom
#'        font the caller is using.
#' @param glyph_size size of the Font Awesome font
#' @param glyph_font,glyph_font_family if `use_glyph` is not `FALSE`,
#'        the `gplyph_font` will be looked up in the font database and
#'        the `glpyph_font_family` used as the `family` parameter to ggplot for
#'        font display since fonts in R, Python and anythign that relies on
#'        legacy font C libraries are woefully messed up. You may need to adjust
#'        either of these "font" parameters depending on your system & OS version
#'        due to the fact that font names are different even between OS versions
#'        (sometimes).\cr
#'        \cr
#'        The package comes with Font Awesome and helpers for it. Use of any other fonts
#'        requires the caller to be familiar with using fonts in R. NOT ALL FONTS
#'        will work with ggplot2 and definitely not under all graphics devices
#'        for ggplot2.
#' @param legend_pos position of legend
#' @export
#' @examples
#' parts <- c(80, 30, 20, 10)
#' waffle(parts, rows=8)
#'
#' parts <- data.frame(
#'   names = LETTERS[1:4],
#'   vals = c(80, 30, 20, 10)
#' )
#'
#' waffle(parts, rows=8)
#'
#' # library(extrafont)
#' # waffle(parts, rows=8, use_glyph="shield")
#'
#' parts <- c(One=80, Two=30, Three=20, Four=10)
#' chart <- waffle(parts, rows=8)
#' # print(chart)
waffle <- function(parts, rows=10, keep=TRUE, xlab=NULL, title=NULL, colors=NA,
                   size=2, flip=FALSE, reverse=FALSE, equal=TRUE, pad=0,
                   use_glyph = FALSE,
                   glyph_size = 12,
                   glyph_font = "Font Awesome 5 Free Solid",
                   glyph_font_family = "FontAwesome5Free-Solid",
                   legend_pos = "right") {

  if (inherits(parts, "data.frame")) {
    stats::setNames(
      unlist(parts[, 2], use.names = FALSE),
      unlist(parts[, 1], use.names = FALSE)
    ) -> parts
  }

  # fill in any missing names
  part_names <- names(parts)
  if (length(part_names) < length(parts)) {
    part_names <- c(part_names, LETTERS[1:length(parts) - length(part_names)])
  }

  names(parts) <- part_names

  # use Set2 if no colors are specified
  if (all(is.na(colors))) colors <- suppressWarnings(brewer.pal(length(parts), "Set2"))

  # make one big vector of all the bits
  parts_vec <- unlist(sapply(1:length(parts), function(i) {
    rep(names(parts)[i], parts[i])
  }))

  if (reverse) parts_vec <- rev(parts_vec)

  # setup the data frame for geom_rect
  dat <- expand.grid(y = 1:rows, x = seq_len(pad + (ceiling(sum(parts) / rows))))

  # add NAs if needed to fill in the "rectangle"
  dat$value <- c(parts_vec, rep(NA, nrow(dat) - length(parts_vec)))

  if (!inherits(use_glyph, "logical")) {

    if (length(use_glyph) == 1L) {

      if (grepl("wesom", glyph_font)) {
        fontlab <- .fa_unicode[.fa_unicode[["name"]] == use_glyph, "unicode"]
        dat$fontlab <- c(
          rep(fontlab, length(parts_vec)),
          rep("", nrow(dat) - length(parts_vec)
          # rep(NA, nrow(dat) - length(parts_vec)
          )
        )
      } else {
        dat$fontlab <- c(
          rep(use_glyph, length(parts_vec)),
          rep("", nrow(dat) - length(parts_vec)
          # rep(NA, nrow(dat) - length(parts_vec)
          )
        )
      }

    } else if (length(use_glyph) == length(parts)) {

      if (grepl("wesom", glyph_font)) {
        fontlab <- .fa_unicode[.fa_unicode[["name"]] %in% use_glyph, "unicode"]
        # fontlab <- .fa_unicode[use_glyph]
        dat$fontlab <- c(
          fontlab[as.numeric(factor(parts_vec, levels = names(parts)))],
          rep("", nrow(dat) - length(parts_vec))
          # rep(NA, nrow(dat) - length(parts_vec))
        )
      } else {
        dat$fontlab <- c(
          use_glyph[as.numeric(factor(parts_vec, levels = names(parts)))],
          # rep(NA, nrow(dat) - length(parts_vec))
          rep("", nrow(dat) - length(parts_vec))
        )
      }

    } else if (length(use_glyph) == length(parts_vec)) {

      if (grepl("wesom", glyph_font)) {
        fontlab <- .fa_unicode[.fa_unicode[["name"]] %in% use_glyph, "unicode"]
        dat$fontlab <- c(fontlab, rep(NA, nrow(dat) - length(parts_vec)))
      } else {
        dat$fontlab <- c(use_glyph, rep(NA, nrow(dat) - length(parts_vec)))
      }

    } else {
      stop("'use_glyph' must have length 1, length(parts), or sum(parts)")
    }
  }

  dat$value <- ifelse(is.na(dat$value), " ", dat$value)

  if (" " %in% dat$value) part_names <- c(part_names, " ")
  if (" " %in% dat$value) colors <- c(colors, "#00000000")

  dat$value <- factor(dat$value, levels = part_names)

  gg <- ggplot(dat, aes(x = x, y = y))

  if (flip) gg <- ggplot(dat, aes(x = y, y = x))

  gg <- gg + theme_bw()

  # make the plot

  if (inherits(use_glyph, "logical")) {

    gg <- gg + geom_tile(aes(fill = value), color = "white", size = size)

    gg <- gg + scale_fill_manual(
      name = "",
      values = colors,
      label = part_names,
      na.value = "white",
      drop = !keep
    )

    gg <- gg + guides(fill = guide_legend(override.aes = list(colour = "#00000000")))

    gg <- gg + theme(legend.background =
                       element_rect(fill = "#00000000", color = "#00000000"))

    gg <- gg + theme(legend.key =
                       element_rect(fill = "#00000000", color = "#00000000"))

  } else {

    if (extrafont::choose_font(glyph_font, quiet = TRUE) == "") {
      stop(
        sprintf(
          "Font [%s] not found. Please install it and use extrafont to make it available to R",
          glyph_font
        ),
        call. = FALSE
      )
    }

    load_fontawesome()

    gg <- gg + geom_tile(
      color = "#00000000", fill = "#00000000", size = size,
      alpha = 0, show.legend = FALSE
    )

    gg <- gg + geom_point(
      aes(color = value), fill = "#00000000", size = 0,
      show.legend = TRUE
    )

    gg <- gg + geom_text(
      aes(color = value, label = fontlab),
      family = glyph_font_family,
      size = glyph_size,
      show.legend = FALSE
    )

    gg <- gg + scale_color_manual(
      name = NULL,
      values = colors,
      labels = part_names,
      drop = !keep
    )

    gg <- gg + guides(color =
                        guide_legend(override.aes = list(shape = 15, size = 7)))

    gg <- gg + theme(legend.background =
                       element_rect(fill = "#00000000", color = "#00000000"))

    gg <- gg + theme(legend.key = element_rect(color = "#00000000"))
  }

  gg <- gg + labs(x = xlab, y = NULL, title = title)
  gg <- gg + scale_x_continuous(expand = c(0, 0))
  gg <- gg + scale_y_continuous(expand = c(0, 0))

  if (equal) gg <- gg + coord_equal()

  gg <- gg + theme(panel.grid = element_blank())
  gg <- gg + theme(panel.border = element_blank())
  gg <- gg + theme(panel.background = element_blank())
  gg <- gg + theme(panel.spacing = unit(0, "null"))

  gg <- gg + theme(axis.text = element_blank())
  gg <- gg + theme(axis.title.x = element_text(size = 10))
  gg <- gg + theme(axis.ticks = element_blank())
  gg <- gg + theme(axis.line = element_blank())
  gg <- gg + theme(axis.ticks.length = unit(0, "null"))

  gg <- gg + theme(plot.title = element_text(size = 18))

  gg <- gg + theme(plot.background = element_blank())
  gg <- gg + theme(panel.spacing = unit(c(0, 0, 0, 0), "null"))

  gg <- gg + theme(legend.position = legend_pos)

  gg

}
