test_that('classification models', {
 skip_if(!run_tests())
 skip_if_not_installed("modeldata")

 #-----------------------------------------------------------------------------

 data(two_class_dat, package = "modeldata")
 x_tr_df <- two_class_dat[1:20, 1:2]
 x_tr_mat <- as.matrix(x_tr_df)
 y_tr <- two_class_dat$Class[1:20]

 x_te_df <- two_class_dat[21:23, 1:2]
 x_te_mat <- as.matrix(x_te_df)

 pred_ptype <-
  tibble::tibble(
   .pred_Class1 = numeric(0),
   .pred_Class2 = numeric(0),
   .pred_class = character(0)
  )

 #-----------------------------------------------------------------------------

 mod_df <- try(TabPFN(x_tr_df, y_tr), silent = TRUE)
 expect_s3_class(mod_df, exp_cls)
 expect_snapshot(mod_df)

 pred_df <- predict(mod_df, x_te_df)
 expect_equal(pred_df[0,], pred_ptype)
 expect_equal(nrow(pred_df), 3L)

 aug_df <- augment(mod_df, x_te_df)
 expect_s3_class(aug_df, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_df), 3L)
 expect_equal(ncol(aug_df), 5L)

 #-----------------------------------------------------------------------------

 mod_f <- try(TabPFN(Class ~ ., data = two_class_dat[1:20, ]), silent = TRUE)
 expect_s3_class(mod_f, exp_cls)
 expect_snapshot(mod_f)

 pred_f <- predict(mod_f, x_tr_df[21:23, ])
 expect_equal(pred_f[0,], pred_ptype)
 expect_equal(nrow(pred_f), 3L)

 aug_f <- augment(mod_f, x_tr_df[21:23, ])
 expect_s3_class(aug_f, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_f), 3L)
 expect_equal(ncol(aug_f), 5L)

 #-----------------------------------------------------------------------------

 mod_mat <- try(TabPFN(x_tr_mat, y_tr), silent = TRUE)
 expect_s3_class(mod_mat, exp_cls)
 expect_snapshot(mod_mat)

 pred_mat <- predict(mod_mat, x_te_mat)
 expect_equal(pred_mat[0,], pred_ptype)
 expect_equal(nrow(pred_mat), 3L)

 aug_mat <- augment(mod_mat, x_tr_df[21:23, ])
 expect_s3_class(aug_mat, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_mat), 3L)
 expect_equal(ncol(aug_mat), 5L)

})

test_that('classification models - recipes', {
 skip_if(!run_tests())
 skip_if_not_installed("modeldata")
 skip_if_not_installed("recipes")

 reticulate::import("torch")

 library(TabPFN)
 library(recipes)

 #-----------------------------------------------------------------------------

 data(two_class_dat, package = "modeldata")

 pred_ptype <-
  tibble::tibble(
   .pred_Class1 = numeric(0),
   .pred_Class2 = numeric(0),
   .pred_class = character(0)
  )

 #-----------------------------------------------------------------------------

 rec <-
  recipe(Class ~ ., data = two_class_dat) |>
  step_interact(~ A:B)

 mod_rec <- try(TabPFN(rec, two_class_dat[1:20, ]), silent = TRUE)
 expect_s3_class(mod_rec, exp_cls)
 expect_snapshot(mod_rec)

 pred_rec <- predict(mod_rec, two_class_dat[50:52, ])
 expect_equal(pred_rec[0,], pred_ptype)
 expect_equal(nrow(pred_rec), 3L)

 aug_rec <- augment(mod_rec, two_class_dat[50:52, ])
 expect_s3_class(aug_rec, c("tbl_df", "tbl", "data.frame"))
 expect_equal(nrow(aug_rec), 3L)
 expect_equal(ncol(aug_rec), 6L)

})


