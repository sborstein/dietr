#Test to see if ConvertFishbaseFood works properly.
#Will test data is downloaded, filtered, and formatted 
test_that("ConvertFishbaseFood function works", {
  test.food <- try(rfishbase::fooditems("Plectropomus maculatus"),silent = TRUE)
  if ("try-error"%in%class(test.food)) {
    skip("could not connect to remote database")
  }else{
  test.convert <- ConvertFishbaseFood(test.food,ExcludeStage = "recruits/juv.")
  expect_length(test.convert,2)#test that conversion is list of the right length
  expect_setequal(dim(test.convert$FoodItems), c(1,5))#test to see if filtered dimensions for food  items are correct
  expect_setequal(dim(test.convert$Taxonomy), c(1,1))#test to see if the dimensions for taxonomy are correct
  }
})

