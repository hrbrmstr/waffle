utils::globalVariables(c("x", "y", "value"))

.dbg <- TRUE

msg <- function(...) {

  if (.dbg) message(...)

}