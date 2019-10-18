#Test to see if FoodTroph function works as expected
#Test obtains food item data from FishBase database and calcultes the trophic level of the record
#Tests that the calculated trophic level is what we expect it to be
test_that("FoodTroph function works", {
  test.food <- rfishbase::fooditems("Plectropomus maculatus")#get food items from database
  test.convert <- ConvertFishbaseFood(test.food,ExcludeStage = "recruits/juv.")#convert food items
  test.TL <- FoodTroph(test.convert$FoodItems,Taxonomy = test.convert$Taxonomy,FishBasePreyVals)#calculate with FoodTroph function
  expect_setequal(test.TL[[1]]$TrophicLevel, 4.5)#test to see correct trophic level is calculated
})