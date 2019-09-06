#' Calculates trophic level from percentage based quantitative diet data (volumetric, weight, etc.) for species, populations, and individuals.
#' @param DietItems A data frame with rows as individual entries and each row consisting of a prey 
#' classification and a corresponding diet percentages. The column names for prey classification of 
#' the diets should match those of PreyValues. The first column should contain the identifier of 
#' the individual and be named "Individual", The last column should contain the percent of the prey in the diet and be labelled "Percent".
#' @param PreyValues a data frame with rows as prey item names and columns containing the trophic 
#' level of the prey item and the standard error of that trophic item. The column names of 
#' PreyValues except for TL and SE should match those in DietItems.
#' @param Taxonomy a data frame with the least inclusive level progressing to more inclusive moving
#'  towards the right.
#' @param PreyClass Column names of the PreyValues used for matching between DietItems and 
#' PreyValues, exclusive of TL and SE. Default is those of FishBase.
#' @param SumCheck Logical. Should the sum of diet items be checked, and if not equal to 100, recalculated?
#' @return a list length of the columns in taxonomy, each containing trophic level estimation at 
#' the respective taxonomic level.
#' @description 
#' Calculates trophic level from percentage based diet data following the routine described in TrophLab. 
#' While FishBase data obtained from rfishbase can be used, users can also upload their own data for
#' use in with function. 
#' @author Samuel Borstein
#' @examples
#'\dontrun{
#' #Get some food item data from rfishbase
#' #library(rfishbase)
#' #convert FishBase data into data for trophic calculation using dietr
#' converted.diet <- ConvertFishbaseDiet(ExcludeStage=NULL)
#' #Subset three studies out, as this contains all  studies from FishBase
#' my.diets <- converted.diet$DietItems[1:26,]
#' my.taxonomy <- converted.diet$Taxonomy[1:3,]
#' #Load Prey Values
#' data(FishBasePreyVals)
#' #Calculate Trophic Levels
#' my.TL <- DietTroph(DietItems = my.diets,PreyValues = FishBasePreyVals, Taxonomy = 
#' my.taxonomy, PreyClass=c("FoodI","FoodII","FoodIII","Stage"))
#' }
#' @export

DietTroph<-function(DietItems, PreyValues,Taxonomy,PreyClass=c("FoodI","FoodII","FoodIII","Stage"),SumCheck=TRUE){
  PreyValues<-unique(PreyValues)
  individual.TL<-data.frame(matrix(nrow = length(unique(Taxonomy[,1])), ncol = 3))#make final table
  colnames(individual.TL)<-c("Individual","TrophicLevel","SE")#make column names for final table
  unique.records<-as.vector(unique(Taxonomy[,1]))#get the number of unique records
  for(record.index in 1:length(unique(unique.records))){#for each record
    individual.TL[record.index,1]<-unique.records[record.index]#put record name in final table
    current.rec<-subset(DietItems,DietItems[,1]==unique.records[record.index])#subset the current records data
   # Troph.Match <- merge(current.rec, PreyValues, by.y=PreyClass,all.x = TRUE)#match the volumes with corresponding prey TL
    Troph.Match <- merge(current.rec, PreyValues, by.x = PreyClass,by.y = PreyClass)
    if(SumCheck==TRUE){
      if(!sum(Troph.Match$Percent)==100){
        fix.percent<-Troph.Match$Percent/sum(Troph.Match$Percent)*100
        Troph.Match$Percent<-fix.percent
      }
    }
    TrophLevel<- 1.0 + sum(as.numeric(Troph.Match$TL)*as.numeric(Troph.Match$Percent))/100#calculate Trophic Level for record
    seTroph=sqrt(sum(as.numeric(Troph.Match$Percent)*as.numeric(Troph.Match$SE^2)/100))#Calculate S.E. of Trophic Level
    #individual.TL$TrophicLevel[record.index]<-TrophLevel#add Trophic Level to final table
    ifelse(dim(current.rec)[1]>dim(Troph.Match)[1],individual.TL$TrophicLevel[record.index]<-"ERROR",individual.TL$TrophicLevel[record.index]<-TrophLevel)#
    individual.TL$SE[record.index]<-seTroph#add SE to final table
  }
  individual.TL
  rounding.error.herbivore<-which(individual.TL$TrophicLevel<2)#id individuals with TL less than 2
  individual.TL$TrophicLevel[rounding.error.herbivore]<-2
  tax.list<-list()
  tax.list[[1]]<-individual.TL
  if(dim(Taxonomy)[2]>1){
  for(tax.rank.index in 2:dim(Taxonomy)[2]){
    uni.taxa<-unique(Taxonomy[,tax.rank.index])
    current.level<-as.data.frame(matrix(nrow = length(uni.taxa),ncol = 4), stringsAsFactors = F)
    colnames(current.level)<-c(colnames(Taxonomy)[tax.rank.index],"TrophicLevel","SE", "nObs")
    for(taxa.index in 1:length(uni.taxa)){
      current.taxa<-subset(Taxonomy,Taxonomy[,tax.rank.index]==uni.taxa[taxa.index])
      current.TL.calcs<-individual.TL[individual.TL[,1]%in%unique(current.taxa[,1]),]
      #current.TL.calcs<-subset(individual.TL,individual.TL$Individual==unique(current.taxa$Individual))
      current.TL.Mean<-sum(current.TL.calcs$TrophicLevel)/dim(current.TL.calcs)[1]
      current.SE.Mean<-sum(current.TL.calcs$SE)/dim(current.TL.calcs)[1]
      current.level[taxa.index,1]<-as.character(uni.taxa[taxa.index])
      current.level$TrophicLevel[taxa.index]<-current.TL.Mean
      current.level$SE[taxa.index]<-current.SE.Mean
      current.level$nObs[taxa.index]<-dim(current.TL.calcs)[1]
    }
    tax.list[[tax.rank.index]]<-current.level
    names(tax.list)<-colnames(Taxonomy)[1:tax.rank.index]
  }
  }
  tax.list
}