#' Converts FishBase/SealifBase food item diet data obtained from the diet function into a usable format for TrophicLevelR
#' @param FishBaseFood a data frame produced by the rfishbase fooditem function
#' @param ExcludeStage a character, indicating which life stages to exclude. Must match stage names given by rfishbase (i.e. larvae, rec./juveniles, juv./adults, adults).
#' @return a list of length two, with two data frames. One containing the re-formatted food item data and one containing the Taxonomy.
#' @details This converts the data frame produced by rfishbase fooditem function into a usable fortmat for TrophicLevelR.
#' @examples
#' #Get rfishbase food item data for a few species
#' my.food<-rfishbase::fooditems(c("Oreochromis niloticus","Salmo salar"))
#' #use the ConvertFishbaseFood function to format it for TrophicLevelR and exclude recruits/juveniles
#' cleaned.food.items<-ConvertFishbaseFood(FishBaseFood=my.food, ExcludeStage=c("larvae","recruits/juv."))
#' @export

ConvertFishbaseFood<-function(FishBaseFood,ExcludeStage=NULL){
  if(!length(colnames(FishBaseFood))==30){#check if right format
    stop('Error: Not Raw rfishbase Food Data')#kill if it is not right format
  }else{
    unique.life<-unique(FishBaseFood$PredatorStage)#get the life stages to exclude
    if(!is.null(ExcludeStage)){
    for(ExcludeStage.index in 1:length(ExcludeStage)){#trim exclude lifestages out
      FishBaseFood<-subset(FishBaseFood,!FishBaseFood$PredatorStage==ExcludeStage[ExcludeStage.index])#subset bad lifestages
    }
      Taxonomy<-as.data.frame(FishBaseFood$sciname,stringsAsFactors = F)
      colnames(Taxonomy)<-"Species"
      FoodItems<-cbind(FishBaseFood$sciname,FishBaseFood$FoodI,FishBaseFood$FoodII,FishBaseFood$FoodIII,FishBaseFood$PreyStage)
      colnames(FoodItems)<-c("Species","FoodI","FoodII","FoodIII","Stage")
      FoodItems<-as.data.frame(FoodItems, stringsAsFactors = F)
      ConvertedStuff<-list(FoodItems,Taxonomy)
      names(ConvertedStuff)<-c("FoodItems","Taxonomy") 
    }else{
    Taxonomy<-as.data.frame(FishBaseFood$sciname,stringsAsFactors = F)
    colnames(Taxonomy)<-"Species"
    FoodItems<-cbind(FishBaseFood$sciname,FishBaseFood$FoodI,FishBaseFood$FoodII,FishBaseFood$FoodIII,FishBaseFood$PreyStage)
    colnames(FoodItems)<-c("Species","FoodI","FoodII","FoodIII","Stage")
    FoodItems<-as.data.frame(FoodItems, stringsAsFactors = F)
    ConvertedStuff<-list(FoodItems,Taxonomy)
    names(ConvertedStuff)<-c("FoodItems","Taxonomy")
    }
  ConvertedStuff
  }
}
