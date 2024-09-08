#' Converts FishBase/SealifBase diet data obtained from rfishbase for use with dietr
#' @param ExcludeStage a character vector, indicating which life stages to exclude. Must match stage names given by rfishbase (i.e. larvae, rec./juveniles, juv./adults, adults).
#' @return a list of length two, with two data frames. One containing the re-formatted diet items and their contributions and one containing the Taxonomy with species names.
#' @description This converts diet data from rfishbase into a format usable with dietr.
#' @details As of rfishbase 3.0, the package handles returning diet data differently than in previous versions. As currently implemented,
#' rfishbase returns two different unjoined diet tables, one with the actual diet items and their percent contribution in the diet, and another that 
#' has the metadata for the diet record. This unfortunately is a difficult format to work with and easily extract out species of interest. Additionally, in previous
#' versions you could specify species names or numbers and only return those of interest, the only function options in the current version
#' are specifying a server. As such, if the function is run, it will return all diet data on the site, requiring users to subset out 
#' those of interest for them. We have implemented in this function a way to join the tables for use as well as filter based on life history stage (if necessary).
#' @examples 
#' \donttest{
#' #Convert Fishbase Diet Data
#' my.diets <- ConvertFishbaseDiet(ExcludeStage=NULL)
#' #Convert Fishbase Diet Data and exclude juvenile and larval records
#' my.diets <- ConvertFishbaseDiet(ExcludeStage=c("recruits/juv.","larvae"))
#' }
#' @author Samuel Borstein
#' @export

ConvertFishbaseDiet<-function(ExcludeStage=NULL){
  items.raw<-as.data.frame(rfishbase::diet_items())#Read in FishBase diet item data
  items <- items.raw[!is.na(items.raw$DietCode),]#remove records lacking DietCode ID
  records.raw<-as.data.frame(rfishbase::diet())#Read in FishBase diet record info
  records <- records.raw[!is.na(records.raw),]#remove records lacking DietCode ID
  merged.diets<-merge(items,records,by.x = "DietCode")
  SpeciesDat <- rfishbase::fb_tbl("species")
  SpeciesDat$SciName <- paste(SpeciesDat$Genus, SpeciesDat$Species)
  SpeciesDatCleaned <- SpeciesDat[SpeciesDat$SpecCode%in%merged.diets$SpecCode,]
  merged.diets$Species <- vector(length = length(merged.diets$SpecCode),mode = "character")
  for(ID.index in 1:nrow(SpeciesDatCleaned)){
    found.Spec.Code <- which(SpeciesDatCleaned$SpecCode[ID.index]==merged.diets$SpecCode)
    merged.diets$Species[found.Spec.Code]<-SpeciesDatCleaned$SciName[ID.index]
  }
  if(is.null(ExcludeStage)){
    ConvertDat<-cbind.data.frame(merged.diets$DietCode,merged.diets$Species,merged.diets$FoodI,merged.diets$FoodII,merged.diets$FoodIII,merged.diets$Stage,merged.diets$DietPercent)
    colnames(ConvertDat)<-c("Individual","Species","FoodI","FoodII","FoodIII","Stage","Percentage")
    Taxonomy<-as.data.frame(cbind(merged.diets$DietCode,merged.diets$Species),stringsAsFactors = F)
    Taxonomy<-unique(Taxonomy)
    colnames(Taxonomy)<-c("Individual","Species")
    ConvertedStuff<-list(ConvertDat,Taxonomy)
    names(ConvertedStuff)<-c("DietItems","Taxonomy") 
  }else{
  ExcludeDat<-merged.diets[!merged.diets$SampleStage%in%ExcludeStage,]
  ConvertDat<-cbind.data.frame(ExcludeDat$DietCode,ExcludeDat$Species,ExcludeDat$FoodI,ExcludeDat$FoodII,ExcludeDat$FoodIII,ExcludeDat$Stage,ExcludeDat$DietPercent)
  colnames(ConvertDat)<-c("Individual","Species","FoodI","FoodII","FoodIII","Stage","Percentage")
  Taxonomy<-as.data.frame(cbind(ExcludeDat$DietCode,ExcludeDat$Species),stringsAsFactors = F)
  Taxonomy<-unique(Taxonomy)
  colnames(Taxonomy)<-c("Individual","Species")
  ConvertedStuff<-list(ConvertDat,Taxonomy)
  names(ConvertedStuff)<-c("DietItems","Taxonomy") 
  }
  ConvertedStuff
}
