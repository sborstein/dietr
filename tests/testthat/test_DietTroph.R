#Test to see if DietTroph function works as expected
#Uses the Herichthys dataset for which trophic levels are calculated
#Tests that the mean calculated trophic level is what we expect it to be
test_that("DietTroph function works", {
  data(Herichthys)
  #Make a data frame of the individuals, lake by year, and lake.
  HMdat<-Herichthys[Herichthys$total==100,]
  HMtax<-cbind.data.frame(HMdat$individual,paste(HMdat$lake,HMdat$year),HMdat$lake)
  #Name the data frame
  colnames(HMtax)<-c("Individual","Lake x Year","Lake (all years)")
  #To calculate trophic level for the entire species, add a vecotr to the data frame of the species name
  HMtax$species<-"Herichthys minckleyi"
  HMdat<-HMdat[,c("individual","X.Gastrop","X.Insect","X.Fish","X.Zoopl","X.plants","X.algae",
                  "X.detritus")]
  #Repeat the individual name the number of unique prey types (6)
  Inds<-rep(x = HMdat$individual, times=6)[order(rep(x = HMdat$individual, times=6))]
  #Repeat the number of food typed the length of the number of individuals
  FoodTypes<-rep(x = colnames(HMdat[2:7]),times=length(unique(HMtax$Individual)))
  #Make a data frame, the length of the individuals with three columns
  HM.mat<-as.data.frame(matrix(nrow = length(Inds),ncol = 3))
  #Name these columns
  colnames(HM.mat)<-c("Individual","FoodItem","Percent")
  #Populate the dataframes first column with the individual and the second column with the prey type
  HM.mat$Individual<-Inds
  HM.mat$FoodItem<-FoodTypes
  #Run this for loop to find the diet data based on the individual and then match the diet percentage
  #based on the name of the prey type
  for(i in 1:nrow(HMdat)){
    rows2match<-which(HM.mat$Individual==HMdat$individual[i])
    HM.mat$Percent[rows2match]<-as.vector(as.numeric(HMdat[i,2:7]))
  }
  #Remove prey that do not contribute to diets
  HM.mat<-HM.mat[!HM.mat$Percent==0,]
  #Create a empty data frame for prey values
  PreyMat<-as.data.frame(matrix(ncol = 3,nrow = 6))
  #Name the columns something useful
  colnames(PreyMat)<-c("FoodItem","TL","SE")
  #Add in the prey name to the PreyMat
  PreyMat[,1]<-unique(FoodTypes)
  #Add in the trophic levels of the prey
  PreyMat[,2]<-c(2.37,2.2,3.5,2.1,2,2)
  #Add in the SE of the prey
  PreyMat[,3]<-c(.58,.4,.8,.3,0,0)
  test.TL <- DietTroph(DietItems = HM.mat,PreyValues = PreyMat, PreyClass = "FoodItem",Taxonomy = HMtax,
                       SumCheck = TRUE)#calculate trophic level using the function
  expect_setequal(round(test.TL$species$TrophicLevel,2), 3.21)#test to see correct trophic level is calculated
})