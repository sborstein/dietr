#' Converts FishBase/SealifBase volumetric diet data obtained from the diet function into a usable format for TrophicLevelR
#' @param FishBaseDiet a data frame produced by the rfishbase diet function
#' @param ExcludeStage a character, indicating which life stages to exclude. Must match stage names given by rfishbase (i.e. larvae, rec./juveniles, juv./adults, adults).
#' @return a list of length two, with two data frames. One containing the re-formatted diet data and one containing the Taxonomy.
#' @details This converts the data frame produced by rfishbase into a usable form for calculating trophic levels in TrophicLevelR.
#' @examples
#' #Get rfishbase diet data for a few species
#' my.diets<-rfishbase::diet(c("Oreochromis niloticus","Salmo salar"))
#' #use the ConvertFishbaseDiet function to format it for TrophicLevelR and exclude recruits/juveniles
#' cleaned.diets<-ConvertFishbaseDiet(FishBaseDiet=my.diets, ExcludeStage=c("larvae","recruits/juv."))
#' @export

ConvertFishbaseDiet<-function(FishBaseDiet,ExcludeStage){
  if(!length(colnames(FishBaseDiet))==53){#check if right format
    stop('Error: Not Raw rfishbase Diet Data')#kill if it is not right format
  }else{
    unique.life<-unique(FishBaseDiet$SampleStage)#get the life stages to exclude
    if(!is.null(ExcludeStage)){
      for(ExcludeStage.index in 1:length(ExcludeStage)){#trim exclude lifestages out
      FishBaseDiet<-subset(FishBaseDiet,!FishBaseDiet$SampleStage==ExcludeStage[ExcludeStage.index])#subset bad lifestages
      }
    Taxonomy<-as.data.frame(cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname),stringsAsFactors = F)
    colnames(Taxonomy)<-c("Individual","Species")
    Volumes<-cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname,FishBaseDiet$FoodI,FishBaseDiet$FoodII,FishBaseDiet$FoodIII,FishBaseDiet$Stage, FishBaseDiet$DietPercent)
    colnames(Volumes)<-c("Individual","Species","FoodI","FoodII","FoodIII","Stage","Volume")
    Volumes<-as.data.frame(Volumes, stringsAsFactors = F)
    ConvertedStuff<-list(Volumes,Taxonomy)
    names(ConvertedStuff)<-c("Volumes","Taxonomy")
    }else{
      Taxonomy<-as.data.frame(cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname),stringsAsFactors = F)
      colnames(Taxonomy)<-c("Individual","Species")
      Volumes<-cbind(FishBaseDiet$DietCode,FishBaseDiet$sciname,FishBaseDiet$FoodI,FishBaseDiet$FoodII,FishBaseDiet$FoodIII,FishBaseDiet$Stage, FishBaseDiet$DietPercent)
      colnames(Volumes)<-c("Individual","Species","FoodI","FoodII","FoodIII","Stage","Volume")
      Volumes<-as.data.frame(Volumes, stringsAsFactors = F)
      ConvertedStuff<-list(Volumes,Taxonomy)
      names(ConvertedStuff)<-c("Volumes","Taxonomy") 
    }
  }
  ConvertedStuff
}