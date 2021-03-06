context("print")

test_that("error formatting works properly", {
  x <- set_errors(rep(11111.22222, 8),
                  c(12345678, 1234.5678, 12.345678, 1.2345678,
                    .12345678, .012345678, .000012345678, .000000012345678))

  expect_equal(capture.output(print(x)), c(
    "errors: 1.234568e+07 1.234568e+03 1.234568e+01 1.234568e+00 1.234568e-01 ...",
    "[1] 11111.22 11111.22 11111.22 11111.22 11111.22 11111.22 11111.22 11111.22"
  ))

  for (i in seq_along(x))
    expect_equal(capture.output(print(x[i])), format(x[i]))

  expect_equal(format(x, notation="parenthesis"),
               c("10000(10000000)", "11000(1000)", "11110(10)", "11111(1)",
                 "11111.2(1)", "11111.22(1)", "11111.22222(1)", "11111.22222000(1)"))
  expect_equal(format(x, notation="parenthesis", digits=3),
               c("10000(12300000)", "11110(1230)", "11111.2(123)", "11111.22(123)",
                 "11111.222(123)", "11111.2222(123)", "11111.2222200(123)", "11111.2222200000(123)"))
  expect_equal(format(x, notation="parenthesis", scientific=TRUE),
               c("1(1000)e4", "1.1(1)e4", "1.111(1)e4", "1.1111(1)e4", "1.11112(1)e4",
                 "1.111122(1)e4", "1.111122222(1)e4", "1.111122222000(1)e4"))

  expect_equal(format(x, notation="plus-minus"),
               c("10000 +/- 10000000", "11000 +/- 1000", "11110 +/- 10", "11111 +/- 1",
                 "11111.2 +/- 0.1", "11111.22 +/- 0.01", "11111.22222 +/- 0.00001", "11111.22222000 +/- 0.00000001"))
  expect_equal(format(x, notation="plus-minus", digits=3),
               c("10000 +/- 12300000", "11110 +/- 1230", "11111.2 +/- 12.3", "11111.22 +/- 1.23",
                 "11111.222 +/- 0.123", "11111.2222 +/- 0.0123", "11111.2222200 +/- 0.0000123", "11111.2222200000 +/- 0.0000000123"))
  expect_equal(format(x, notation="plus-minus", scientific=TRUE),
               c("(1 +/- 1000)e4", "(1.1 +/- 0.1)e4", "(1.111 +/- 0.001)e4", "(1.1111 +/- 0.0001)e4",
                 "(1.11112 +/- 0.00001)e4", "(1.111122 +/- 0.000001)e4", "(1.111122222 +/- 0.000000001)e4",
                 "(1.111122222000 +/- 0.000000000001)e4"))

  x <- set_errors(10, 1)
  expect_equal(format(x - set_errors(10)), "0(1)")
  expect_equal(format(x - x), "0(1)")

  x <- set_errors(c(0.4, NA, NaN, Inf))
  expect_equal(format(x[1]), "0.4(0)")
  expect_equal(format(x[2]), "NA(NA)")
  expect_equal(format(x[3]), "NaN(NaN)")
  expect_equal(format(x[4]), "Inf(Inf)")
})
