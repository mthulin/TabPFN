test_that('regression models', {
 skip_if(!run_tests())

 pred_ptype <- tibble::tibble(.pred = numeric(0))

 #-----------------------------------------------------------------------------

 mod_df <- try(TabPFN(predictors, outcome), silent = TRUE)
 expect_s3_class(mod_df, exp_cls)
 expect_snapshot(mod_df)

 pred_df <- predict(mod_df, mtcars[1:3, -1])
 expect_equal(pred_df[0,], pred_ptype)
 expect_equal(nrow(pred_df), 3L)

 aug_df <- augment(mod_df, mtcars[1:3, -1])
 expect_s3_class(aug_df, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_df), 3L)
 expect_equal(ncol(aug_df), 11L)

 #-----------------------------------------------------------------------------

 mod_f <- try(TabPFN(mpg ~ ., data = mtcars), silent = TRUE)
 expect_s3_class(mod_f, exp_cls)
 expect_snapshot(mod_f)

 pred_f <- predict(mod_f, mtcars[1:3, -1])
 expect_equal(pred_f[0,], pred_ptype)
 expect_equal(nrow(pred_f), 3L)

 aug_f <- augment(mod_f, mtcars[1:3, -1])
 expect_s3_class(aug_f, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_f), 3L)
 expect_equal(ncol(aug_f), 11L)

 #-----------------------------------------------------------------------------

 mod_mat <- try(TabPFN(as.matrix(predictors), outcome), silent = TRUE)
 expect_s3_class(mod_mat, exp_cls)
 expect_snapshot(mod_mat)

 pred_mat <- predict(mod_mat, mtcars[1:3, -1])
 expect_equal(pred_mat[0,], pred_ptype)
 expect_equal(nrow(pred_mat), 3L)

 aug_mat <- augment(mod_mat, mtcars[1:3, -1])
 expect_s3_class(aug_mat, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_mat), 3L)
 expect_equal(ncol(aug_mat), 11L)

 #-----------------------------------------------------------------------------

 expect_snapshot_error(
  TabPFN(1, 2)
 )
})

test_that('regression models - recipes', {
 skip_if(!run_tests())
 skip_if_not_installed("modeldata")
 skip_if_not_installed("recipes")

 reticulate::import("torch")

 library(TabPFN)
 library(recipes)
 data(Chicago, package = "modeldata")

 pred_ptype <- tibble::tibble(.pred = numeric(0))

 #-----------------------------------------------------------------------------

 rec <-
  recipe(ridership ~ Austin + Quincy_Wells + date, data = Chicago) |>
  step_date(date) |>
  step_rm(date)

 mod_rec <- try(TabPFN(rec, Chicago[1:20, ]), silent = TRUE)
 expect_s3_class(mod_rec, exp_cls)
 expect_snapshot(mod_rec)

 pred_rec <- predict(mod_rec, Chicago[50:52, ])
 expect_equal(pred_rec[0,], pred_ptype)
 expect_equal(nrow(pred_rec), 3L)

 aug_rec <- augment(mod_rec, Chicago[50:52, ])
 expect_s3_class(aug_rec, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_rec), 3L)
 expect_equal(ncol(aug_rec), 51L)

})

