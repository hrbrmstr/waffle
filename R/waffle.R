y <- x <- value <- NULL

#' Make waffle (square pie) charts
#'
#' Given a named vector, this function will return a ggplot object that represents a
#' "waffle chart" of the values. The individual values will be summed up and each
#' that will be the total number of squares in the "grid". You can perform appropriate
#' value transformation ahead of time to get the desired "waffle" layout/effect.
#'
#' If the vector is not named or only partially named, \code{LETTERS} will be used instead.
#' It is highly suggested that you limit the number of elements to plot, just like you should
#' if you ever got wasted and decided that a regular pie chart was a good thing to create and
#' then decide to be totally evil and make one to pollute this beautiful world of ours.
#'
#' Chart title and x-axis labels are optional, especially if you'll just be exporting to another
#' program for use/display.
#'
#' @param parts [named] vector of values to use for the chart
#' @param rows number of rows of blocks
#' @param xlab text for below the chart. Highly suggested this be used to give the
#'     "1 sq == xyz" relationship if it's not obvious
#' @param title chart title
#' @param colors exactly the number of colors as values in \code{parts}. If omitted,
#'     Color Brewer "Set2" colors are used.
#' @param size width of the separator between blocks (defaults to \code{2})
#' @param flip flips x & y axes
#' @param reverse reverses the order of the data
#' @param equal by default, waffle uses \code{coord_equal}; this can cause layout problems,
#'     so you an use this to disable it if you are using ggsave or knitr to control
#'     output sizes (or manually sizing the chart)
#' @param pad how many blocks to right-pad the grid with
#'
#' @examples \dontrun{
#' parts <- c(80, 30, 20, 10)
#' waffle(parts, rows=8)
#'
#' parts <- c(`Un-breached US Population`=(318-11-79), `Premera`=11, `Anthem`=79)
#'
#' waffle(parts, rows=8, size=1, colors=c("#969696", "#1879bf", "#009bda"),
#'        title="Health records breaches as fraction of US Population",
#'        xlab="One square == 1m ppl")
#'
#' waffle(parts/10, rows=3, colors=c("#969696", "#1879bf", "#009bda"),
#'        title="Health records breaches as fraction of US Population",
#'        xlab="One square == 10m ppl")
#'
#' # http://graphics8.nytimes.com/images/2008/07/20/business/20debtgraphic.jpg
#' # http://www.nytimes.com/2008/07/20/business/20debt.html
#' savings <- c(`Mortgage ($84,911)`=84911, `Auto and tuition loans ($14,414)`=14414,
#'              `Home equity loans ($10,062)`=10062, `Credit Cards ($8,565)`=8565)
#' waffle(savings/392, rows=7, size=0.5,
#'        colors=c("#c7d4b6", "#a3aabd", "#a0d0de", "#97b5cf"),
#'        title="Average Household Savings Each Year", xlab="1 square == $392")
#'
#' # https://eagereyes.org/techniques/square-pie-charts
#' professional <- c(`Male`=44, `Female (56%)`=56)
#' waffle(professional, rows=10, size=0.5, colors=c("#af9139", "#544616"),
#'        title="Professional Workforce Makeup")
#' }
#'
#' @export
waffle <- function(parts, rows=10, xlab=NULL, title=NULL, colors=NA,
                   size=2, flip=FALSE, reverse=FALSE, equal=TRUE, pad=0) {

  # fill in any missing names

  part_names <- names(parts)
  if (length(part_names) < length(parts)) {
    part_names <- c(part_names, LETTERS[1:length(parts)-length(part_names)])
  }

  # use Set2 if no colors are specified

  if (all(is.na(colors))) {
    colors <- brewer.pal(length(parts), "Set2")
  }

  # make one big vector of all the bits

  parts_vec <- unlist(sapply(1:length(parts), function(i) {
    rep(LETTERS[i+1], parts[i])
  }))

  if (reverse) { parts_vec <- rev(parts_vec) }

  # setup the data frame for geom_rect

  dat <- expand.grid(y=1:rows, x=seq_len(pad + (ceiling(sum(parts) / rows))))

  # add NAs if needed to fill in the "rectangle"

  dat$value <- c(parts_vec, rep(NA, nrow(dat)-length(parts_vec)))

  if (flip) {
    gg <- ggplot(dat, aes(x=y, y=x, fill=value))
  } else {
    gg <- ggplot(dat, aes(x=x, y=y, fill=value))
  }

  # make the plot

  gg <- gg + geom_tile(color="white", size=size)
  gg <- gg + labs(x=xlab, y=NULL, title=title)
  gg <- gg + scale_x_continuous(expand=c(0, 0))
  gg <- gg + scale_y_continuous(expand=c(0, 0))
  gg <- gg + scale_fill_manual(name="",
                               values=colors,
                               labels=part_names)

  gg <- gg + guides(fill=guide_legend(override.aes=list(colour=NULL)))

  if (equal) { gg <- gg + coord_equal() }

    gg <- gg + theme_bw()

  gg <- gg + theme(panel.grid=element_blank())
  gg <- gg + theme(panel.border=element_blank())
  gg <- gg + theme(panel.background=element_blank())
  gg <- gg + theme(panel.margin=unit(0, "null"))

  gg <- gg + theme(axis.text=element_blank())
  gg <- gg + theme(axis.title.x=element_text(size=10))
  gg <- gg + theme(axis.ticks=element_blank())
  gg <- gg + theme(axis.line=element_blank())
  gg <- gg + theme(axis.ticks.length=unit(0, "null"))
  gg <- gg + theme(axis.ticks.margin=unit(0, "null"))

  gg <- gg + theme(plot.title=element_text(size=18))

  gg <- gg + theme(plot.background=element_blank())
  gg <- gg + theme(plot.margin=unit(c(0, 0, 0, 0), "null"))
  gg <- gg + theme(plot.margin=rep(unit(0, "null"), 4))

  gg

}

#' Turn a ggplot waffle chart object into an htmlwidget
#'
#' Takes the output from \code{waffle} and turns it into an \code{rcdimple}
#' \code{htmlwidget}.  For this to work, you will need to install
#' \code{rcdimple} with \code{devtools::install_github("timelyportfolio/rcdimple")}.
#'
#' @param wf waffle chart ggplot2 object
#' @param height height of the resultant \code{htmlwidget}
#' @param width width of the resultant \code{htmlwidget}
#'
#' @examples \dontrun{
#'   # requires install of rcdimple
#'   # devtools::install_github("timelyportfolio/rcdimple")
#'   parts <- c( 80, 30, 20, 10 )
#'   as_rcdimple( waffle( parts, rows=8) )
#' }
#'
#' @export
as_rcdimple <- function( wf, height = NULL, width = NULL ) {

  # not import since optional dependency
  #  check here to see if rcdimple is available
  if(!requireNamespace("rcdimple", quietly=TRUE)) stop("please devtools::install_github('timelyportfolio/rcdimple')", call. = FALSE)

  # let ggplot2 do the work and build the chart
  gb <- ggplot_build(wf)
  dimp <- rcdimple::dimple(
    na.omit(
      data.frame(
        group = wf$scales$scales[[3]]$labels[
          match(wf$data$value,unique(wf$data$value))
        ]
        ,gb$data[[1]]
        ,stringsAsFactors = F
      )
    )
    , y~x
    , type = "bar"
    , groups = "group"
    , width = width
    , height = height
    , xAxis = list( type = "addCategoryAxis", title  = "" )
    , yAxis = list( type = "addCategoryAxis", title = "" )
    , defaultColors = unique( na.omit(gb$data[[1]])$fill )
    , title = list( text = wf$labels$title )
    , tasks = list(
        JS(
          'function(){
            this.widgetDimple[0].axes.forEach(function(ax){
              ax.shapes.remove()
            })
          }'
        )
    )
  )
  return(dimp)
}
