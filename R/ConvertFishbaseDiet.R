#' Converts FishBase/SealifBase volumetric diet data obtained from the diet function into a usable format for TrophicLevelR
#' @param FishBaseDiet a data frame with rows as individuals and each row consisting of a prey item name.
#' @param ExcludeStage a character, indicating which life stages to exclude. Must match stage names given by rfishbase (i.e. larvae, rec./juveniles, juv./adults, adults).
#' @return a list of length two, with two data frames. One containing the re-formatted diet data and one containing the Taxonomy.
#' @details This converts the data frame produced by rfishbase 
#' @export

ConvertFishbaseDiet<-function(FishBaseDiet,ExcludeStage){
  if(!length(colnames(FishBaseDiet))==53){#check if right format
    stop('Error: Not Raw rfishbase Diet Data')#kill if it is not right format
  }else{
    unique.life<-unique(FishBaseDiet$SampleStage)#get the life stages to exclude
    for(ExcludeStage.index in 1:length(ExcludeStage)){#trim exclude lifestages out
      FishBaseDiet<-subset(FishBaseDiet,!FishBaseDiet$SampleStage==ExcludeStage[ExcludeStage.index])#subset bad lifestages
    }
    Taxonomy<-as.data.frame(cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname),stringsAsFactors = F)
    colnames(Taxonomy)<-c("Individual","Species")
    Volumes<-cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname,adult.diets$FoodI,adult.diets$FoodII,adult.diets$FoodIII,adult.diets$Stage, adult.diets$DietPercent)
    colnames(Volumes)<-c("Individual","Species","FoodI","FoodII","FoodIII","Stage","Volume")
    Volumes<-as.data.frame(Volumes, stringsAsFactors = F)
    ConvertedStuff<-list(Volumes,Taxonomy)
    names(ConvertedStuff)<-c("Volumes","Taxonomy")
  }
  ConvertedStuff
}