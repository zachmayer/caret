library(caret)

test_that('treebag classification', {
  skip_on_cran()
  set.seed(1)
  tr_dat <- twoClassSim(200)
  te_dat <- twoClassSim(200)
  
  set.seed(2)
  class_trim <- train(Class ~ ., data = tr_dat,
                      method = "treebag",
                      nbagg = 3,
                      trControl = trainControl(method = "none", 
                                               classProbs = TRUE,
                                               trim = TRUE))
  
  set.seed(2)
  class_notrim <- train(Class ~ ., data = tr_dat,
                        method = "treebag",
                        nbagg = 3,
                        trControl = trainControl(method = "none", 
                                                 classProbs = TRUE,
                                                 trim = FALSE))
  
  expect_equal(predict(class_trim,   te_dat),
               predict(class_notrim, te_dat))
  
  expect_equal(predict(class_trim,   te_dat, type = "prob"),
               predict(class_notrim, te_dat, type = "prob"))
  
  expect_less_than(object.size(class_trim)-object.size(class_notrim), 10)
})

test_that('rpart regression', {
  skip_on_cran()
  set.seed(1)
  tr_dat <- SLC14_1(200)
  te_dat <- SLC14_1(200)
  
  set.seed(2)
  reg_trim <- train(y ~ ., data = tr_dat,
                    method = "treebag",
                    nbagg = 3,
                    trControl = trainControl(method = "none", 
                                             trim = TRUE))
  
  set.seed(2)
  reg_notrim <- train(y ~ ., data = tr_dat,
                      method = "treebag",
                      nbagg = 3,
                      trControl = trainControl(method = "none", 
                                               trim = FALSE))
  expect_equal(predict(reg_trim,   te_dat),
               predict(reg_notrim, te_dat))
  expect_less_than(object.size(reg_trim)-object.size(reg_notrim), 10)
})

