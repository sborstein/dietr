#' Calculates trophic level from percentage based quantitative diet data (volumetric, weight, etc.) for species, populations, and individuals.
#' @param DietItems A data frame with rows as individual entries and each row consisting of a prey 
#' classification and a corresponding diet percentages. The column names for prey classification of 
#' the diets should match those of PreyValues. The first column should contain the identifier of 
#' the individual and be named "Individual", The last column should contain the percent of the prey in the diet and be labelled "Percent".
#' @param PreyValues a data frame with rows as prey item names and columns containing the trophic 
#' level of the prey item and the standard error of that trophic item. The column names of 
#' PreyValues except for TL and SE should match those in DietItems.
#' @param Taxonomy a data frame starting with the least inclusive level progressing to more inclusive moving
#'  towards the right.
#' @param PreyClass Column names of the PreyValues used for matching between DietItems and 
#' PreyValues, exclusive of TL and SE. Default is those of FishBase.
#' @param SumCheck Logical. Should the sum of diet items be checked, and, if not equal to 100, recalculated?
#' @return A list length of the columns in taxonomy, each containing trophic level estimation at the respective taxonomic level.
#' @description 
#' Calculates trophic level from percentage based diet data following the routine described in TrophLab. 
#' While FishBase data obtained from rfishbase can be used, users can also upload their own data for
#' use in with function (see vignette for a tutorial). 
#' @author Samuel Borstein
#' @examples
#' \donttest{
#' ###EXAMPLE USING RAW DATA FROM Magalhaes et al., 2015###
#' data(Herichthys)#load data
#' #Subset out individuals with diet data
#' HMdat<-Herichthys[Herichthys$total==100,]
#' #Make a data frame of the individuals, lake by year, and lake.
#' HMtax<-cbind.data.frame(HMdat$individual,paste(HMdat$lake,HMdat$year),HMdat$lake)
#' #Name the data frame
#' colnames(HMtax)<-c("Individual","Lake x Year","Lake (all years)")
#' #To calculate trophic level for the entire species, add a vecotr to the data frame of
#' #the species name
#' HMtax$species<-"Herichthys minckleyi"
#' HMdat<-HMdat[,c("individual","X.Gastrop","X.Insect","X.Fish","X.Zoopl"
#' ,"X.plants","X.algae", "X.detritus")]
#' #Repeat the individual name the number of unique prey types (6)
#' Inds<-rep(x = HMdat$individual, times=6)[order(rep(x = HMdat$individual, times=6))]
#' #Repeat the number of food typed the length of the number of individuals
#' FoodTypes<-rep(x = colnames(HMdat[2:7]),times=length(unique(HMtax$Individual)))
#' #Make a data frame, the length of the individuals with three columns
#' HM.mat<-as.data.frame(matrix(nrow = length(Inds),ncol = 3))
#' #Name these columns
#' colnames(HM.mat)<-c("Individual","FoodItem","Percent")
#' #Populate the dataframes first column with the individual and the second column with the prey type
#' HM.mat$Individual<-Inds
#' HM.mat$FoodItem<-FoodTypes
#' #Run this for loop to find the diet data based on the individual and then match the 
#' #diet percentage based on the name of the prey type
#' for(i in 1:nrow(HMdat)){
#' rows2match<-which(HM.mat$Individual==HMdat$individual[i])
#' HM.mat$Percent[rows2match]<-as.vector(as.numeric(HMdat[i,2:7]))
#' }
#' #Remove prey that do not contribute to diets
#' HM.mat<-HM.mat[!HM.mat$Percent==0,]
#' #Create a empty data frame for prey values
#' PreyMat<-as.data.frame(matrix(ncol = 3,nrow = 6))
#' #Name the columns something useful
#' colnames(PreyMat)<-c("FoodItem","TL","SE")
#' #Add in the prey name to the PreyMat
#' PreyMat[,1]<-unique(FoodTypes)
#' #Add in the trophic levels of the prey
#' PreyMat[,2]<-c(2.37,2.2,3.5,2.1,2,2)
#' #Add in the SE of the prey
#' PreyMat[,3]<-c(.58,.4,.8,.3,0,0)
#' HM.TL<-DietTroph(DietItems = HM.mat,PreyValues = PreyMat, PreyClass = "FoodItem",
#' Taxonomy = HMtax, SumCheck = TRUE)
#' ###EXAMPLE USING DATA FROM FISHBASE###
#' #Get some food item data from rfishbase
#' library(rfishbase)
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

DietTroph <- function(DietItems, PreyValues, Taxonomy, PreyClass=c("FoodI","FoodII","FoodIII", "Stage"),SumCheck=TRUE){
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