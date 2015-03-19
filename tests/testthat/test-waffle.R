context("basic functionality")
test_that("we can do something", {

  expect_that(waffle(c(80, 30, 20, 10), rows=8), is_a("ggplot"))

})
