#' Calculates trophic level from food item data for species, populations, and individuals using a random subsampling routine.
#' @param FoodItems a data frame with rows as individuals and each row consisting of a prey item name.
#' @param PreyValues a data frame with rows as prey item names and columns containing the trophic level of the prey item and the standard error of that trophic item.
#' @param Taxonomy a data frame with the least inclusive level in the leftmost column progressing to more inclusive with columns to the right.Can be a single column.
#' @param PreyClass Column names of the PreyValues used for matching between FoodItems and PreyValues, exclusive of TL and SE. Default is those of FishBase.
#' @return a list containing estimated trophic levels from food items at each taxonomic level provided by the user.
#' @examples 
#' #Get some food item data from rfishbase
#' library(rfishbase)
#' my.food<-rfishbase::fooditems(c("Lutjanus apodus","Epinephelus itajara"))
#' #convert FishBase data into data for trophic calculation using TrophicLevelR
#' converted.foods<-ConvertFishbaseFood(my.food)
#' #Load Prey Values
#' data(FishBasePreyVals)
#' #Calculate Trophic Levels
#' my.TL<-FoodTroph(FoodItems = converted.foods$FoodItems,PreyValues = FishBasePreyVals, Taxonomy = converted.foods$Taxonomy,PreyClass=c("FoodI","FoodII","FoodIII","Stage"))
#' @export

FoodTroph<-function(FoodItems, PreyValues,Taxonomy,PreyClass=c("FoodI","FoodII","FoodIII","Stage")){
  PreyValues<-mgcv::uniquecombs(PreyValues)
  individual.TL<-data.frame(matrix(nrow = length(unique(Taxonomy[,1])), ncol = 4))#make final table
  colnames(individual.TL)<-c("Individual","TrophicLevel","SE","Items")#make column names for final table
  unique.records<-as.vector(unique(Taxonomy[,1]))#get the number of unique records
  check.food.items<-vector(length = length(unique.records))#check that the stuff is ok for now.
  for(record.index in 1:length(unique(unique.records))){#for each record
    individual.TL$Individual[record.index]<-unique.records[record.index]#put record name in final table
    current.rec<-subset(FoodItems,FoodItems[,1]==unique.records[record.index])#subset the current records data
    Food.Match <- merge(current.rec, PreyValues, by.y=PreyClass)#match the food with corresponding prey TL
    ifelse(dim(Food.Match)[1]<dim(current.rec)[1],check.food.items[record.index]<-"bad",check.food.items[record.index]<-"good")
    if(length(unique(Food.Match$TL))==1 && length(unique(Food.Match$SE))==1){#If only a single food item, use that without subsampling
      individual.TL$TrophicLevel[record.index]<-1+unique(Food.Match$TL)#add 1 to the single food items trophic level
      individual.TL$SE[record.index]<-unique(Food.Match$SE)#take the single food items SE estimate
      individual.TL$Items[record.index]<-1
    }else{
      samps2take<-ifelse(dim(Food.Match)[1]>10, 10, dim(Food.Match)[1])#if more than 10 items, only take first 10 as it is based off log10
      individual.TL$Items[record.index]<-samps2take
      resamps<-data.frame(matrix(nrow = 100, ncol = 2))#make table to house
      colnames(resamps)<-c("TL","SE")#make column names for table
      for(samp.index in 1:100){#for 100 random samplings of items
        ranks<-sample(1:dim(Food.Match)[1],size = samps2take, replace = F)#sample data
        Food.Order<-Food.Match[c(ranks),]#reorganize by rank
        expo = 2 - (0.16 * (log(samps2take) / log(10))) - (1.9 * (log(1:samps2take) / log(10)))#basic predictor function for TL
        PreyWeight = (10^expo)#solve the log for the prey weights
        resamps$TL[samp.index]<-sum(PreyWeight*Food.Order$TL)/sum(PreyWeight)#write the current TL estimation to the temporary vector of simulations
        check.SE.weight<-ifelse(PreyWeight-1>0,check.SE.weight<-PreyWeight-1,0)#check for negatives that will kill the sqrt, make them 0
        #resamps$SE[samp.index]<-sqrt(sum((Food.Order$SE^2)*(PreyWeight-1))/(sum(PreyWeight)-samps2take))
        resamps$SE[samp.index]<-sqrt(sum((Food.Order$SE^2)*(check.SE.weight))/(sum(PreyWeight)-samps2take))
      }
      individual.TL$TrophicLevel[record.index]<-1+sum(resamps$TL)/100
      individual.TL$SE[record.index]<-sum(resamps$SE)/100
    }
  }
  individual.TL
}