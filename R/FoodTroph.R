#' Calculates trophic level from qualitative food item data for species, populations, and individuals using a random subsampling routine.
#' @param FoodItems a data frame with rows as individuals and each row consisting of a prey item name.
#' @param PreyValues a data frame with rows as prey item names and columns containing the trophic level of the prey item and the standard error of that trophic item.
#' @param Taxonomy a data frame with the least inclusive level in the leftmost column progressing to more inclusive with columns to the right.Can be a single column.
#' @param PreyClass Column names of the PreyValues used for matching between FoodItems and PreyValues, exclusive of TL and SE. Default is those of FishBase.
#' @param Iter Numeric representing how many iterations of the subsampling routine should be performed. Default is 100 (same as in TrophLab)
#' @param SE.Type Type of SE to perform. Can be either TrophLab, Sims, or Both. Default is TrophLab. See details for a more in-depth description of these options.
#' @return a list of data frames containing estimated trophic levels from food items at each taxonomic level provided by the user.
#' @description 
#' Calculates trophic level from food items where quantitative contribution is unknown. Follows the routine described in TrophLab. 
#' While FishBase data obtained from rfishbase can be used, users can also upload their own data for
#' use with the function.
#' @details 
#' Users can set the number of iterations for the subsampling routine for the simulated ranking of trophic items used in calculating trophic levels. We have this set currently to match
#' how it is implemented in TrophLab, at 100. We find this performs relatively well and is quite quick to do, but users could also increase this value with minimal impacts on run time.
#' 
#' For calculating the SE (SE.Type parameter) around the estimated trophic level users have a few options. The current default follows TrophLab and uses the SE around the trophic levels of prey to estimate
#' the SE which they also refer to as the omnivory index. Alternatively, users can select the Sims option, in which case the SE is estimated based on the estimated TL of the n number
#' of subsampling routines.Users can also select "Both" if they would like to calculate both types of SE.
#' @author Samuel Borstein
#' @examples 
#' \donttest{
#' #Get some food item data from rfishbase
#' my.food <- rfishbase::fooditems(c("Lutjanus apodus","Epinephelus itajara"))
#' #convert FishBase data into data for trophic calculation using TrophicLevelR
#' converted.foods <- ConvertFishbaseFood(my.food)
#' #Load Prey Values
#' data(FishBasePreyVals)
#' #Calculate Trophic Levels
#' my.TL <- FoodTroph(FoodItems = converted.foods$FoodItems,PreyValues = FishBasePreyVals, Taxonomy =
#' converted.foods$Taxonomy,PreyClass=c("FoodI","FoodII","FoodIII","Stage"))
#' }
#' @export

FoodTroph <- function(FoodItems, PreyValues, Taxonomy, PreyClass=c("FoodI","FoodII","FoodIII","Stage"), Iter = 100, SE.Type = "TrophLab"){
  PreyValues <- unique(PreyValues)
  #individual.TL<-data.frame(matrix(nrow = length(unique(Taxonomy[,1])), ncol = 4))#make final table
  individual.TL <- data.frame(matrix(nrow = length(unique(Taxonomy[,1])), ncol = ifelse(SE.Type == "Both", 5, 4)))#make final table
  ifelse(ncol(individual.TL)==5,colnames(individual.TL)<-c("Individual","TrophicLevel","TrophLabSE","SimsSE","Items"),colnames(individual.TL)<-c("Individual","TrophicLevel","SE","Items"))#make column names for final table
  #colnames(individual.TL)<-c("Individual","TrophicLevel","SE","Items")#make column names for final table
  unique.records <- as.vector(unique(Taxonomy[,1]))#get the number of unique records
  check.food.items <- vector(length = length(unique.records))#check that the stuff is ok for now.
  for(record.index in 1:length(unique(unique.records))){#for each record
    individual.TL$Individual[record.index] <- unique.records[record.index]#put record name in final table
    current.rec <- subset(FoodItems,FoodItems[,1]==unique.records[record.index])#subset the current records data
    #merge(current.rec, PreyValues, by.x = c("FoodI","FoodII","FoodIII","Stage"),by.y = c("FoodI","FoodII","FoodIII","Stage"))
    Food.Match <- merge(current.rec, PreyValues, by.x = PreyClass,by.y = PreyClass)
    ifelse(dim(Food.Match)[1]<dim(current.rec)[1],check.food.items[record.index]<-"bad",check.food.items[record.index]<-"good")
    if(length(unique(Food.Match$TL))==1 && length(unique(Food.Match$SE))==1){#If only a single food item, use that without subsampling
      individual.TL$TrophicLevel[record.index] <- 1+unique(Food.Match$TL)#add 1 to the single food items trophic level
      if(SE.Type == "Both"){
        individual.TL$TrophLabSE[record.index] <- unique(Food.Match$SE)
        individual.TL$SimsSE[record.index] <- 0
        individual.TL$Items[record.index] <- 1
      }else{
        ifelse(SE.Type == "TrophLab", individual.TL$SE[record.index]<-unique(Food.Match$SE),individual.TL$SE[record.index]<-0)
        individual.TL$Items[record.index] <- 1
      }
      #individual.TL$SE[record.index]<-unique(Food.Match$SE)#take the single food items SE estimate
    }else{
      samps2take <- ifelse(dim(Food.Match)[1]>10, 10, dim(Food.Match)[1])#if more than 10 items, only take first 10 as it is based off log10
      individual.TL$Items[record.index] <- samps2take
      resamps <- data.frame(matrix(nrow = Iter, ncol = 2))#make table to house
      colnames(resamps) <- c("TL","SE")#make column names for table
      for(samp.index in 1:Iter){#for 100 random samplings of items
        ranks <- sample(1:dim(Food.Match)[1],size = samps2take, replace = F)#sample data
        Food.Order <- Food.Match[c(ranks),]#reorganize by rank
        expo = 2 - (0.16 * (log(samps2take) / log(10))) - (1.9 * (log(1:samps2take) / log(10)))#basic predictor function for TL
        PreyWeight = (10^expo)#solve the log for the prey weights
        resamps$TL[samp.index] <- sum(PreyWeight*Food.Order$TL)/sum(PreyWeight)#write the current TL estimation to the temporary vector of simulations
        check.SE.weight <- ifelse(PreyWeight-1>0,check.SE.weight<-PreyWeight-1,0)#check for negatives that will kill the sqrt, make them 0
        #resamps$SE[samp.index]<-sqrt(sum((Food.Order$SE^2)*(PreyWeight-1))/(sum(PreyWeight)-samps2take))
        resamps$SE[samp.index] <- sqrt(sum((Food.Order$SE^2)*(check.SE.weight))/(sum(PreyWeight)-samps2take))
      }
      if(SE.Type == "Both"){
        individual.TL$TrophicLevel[record.index] <- 1+sum(resamps$TL)/Iter
        individual.TL$TrophLabSE[record.index] <- sum(resamps$SE)/Iter
        individual.TL$SimsSE[record.index] <- stats::sd(resamps$TL)/sqrt(length(resamps$TL))
      }else{
        individual.TL$TrophicLevel[record.index] <- 1+sum(resamps$TL)/Iter
        ifelse(SE.Type == "TrophLab", individual.TL$SE[record.index]<-sum(resamps$SE)/Iter,individual.TL$SE[record.index]<-stats::sd(resamps$TL)/sqrt(length(resamps$TL)))
        #individual.TL$SE[record.index]<-sum(resamps$SE)/Iter
      }
    }
  }
  individual.TL
  tax.list <- list()
  tax.list[[1]] <- individual.TL
  if(dim(Taxonomy)[2]>1){
    for(tax.rank.index in 2:dim(Taxonomy)[2]){
      uni.taxa <- unique(Taxonomy[,tax.rank.index])
      current.level <- as.data.frame(matrix(nrow = length(uni.taxa),ncol = 4), stringsAsFactors = F)
      colnames(current.level) <- c(colnames(Taxonomy)[tax.rank.index],"TrophicLevel","SE", "nObs")
      for(taxa.index in 1:length(uni.taxa)){
        current.taxa <- subset(Taxonomy,Taxonomy[,tax.rank.index]==uni.taxa[taxa.index])
        current.TL.calcs <- individual.TL[individual.TL[,1]%in%unique(current.taxa[,1]),]
        #current.TL.calcs<-subset(individual.TL,individual.TL$Individual==unique(current.taxa$Individual))
        current.TL.Mean <- sum(current.TL.calcs$TrophicLevel)/dim(current.TL.calcs)[1]
        current.SE.Mean <- sum(current.TL.calcs$SE)/dim(current.TL.calcs)[1]
        current.level[taxa.index,1] <- as.character(uni.taxa[taxa.index])
        current.level$TrophicLevel[taxa.index] <- current.TL.Mean
        current.level$SE[taxa.index] <- current.SE.Mean
        current.level$nObs[taxa.index] <- dim(current.TL.calcs)[1]
      }
      tax.list[[tax.rank.index]] <- current.level
      names(tax.list) <- colnames(Taxonomy)[1:tax.rank.index]
    }
  }
  tax.list
}
