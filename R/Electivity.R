#' Calculates a variety of electivity indices and foraging ratios
#' @param Diet Data frame with data corresponding to consumed resources found in the diet. See details for formatting.
#' @param Available Data frame with data corresponding to the available resources. See details for formatting.
#' @param Indices Character vector containing the names of the desired indices to calculate. See description for information on availabble indices. 
#' @param Depleting Logical. If true, will assume the food source is depleting and perform calculations following Manly. Default is FALSE.
#' @references
#' Chesson, J. 1983. The estimation and analysis of preference and its relatioship to foraging models. Ecology 64:1297-1304.
#' Ivlev, U. 1961. Experimental ecology of the feeding of fish. Yale University Press, New Haven.
#' Jacobs, J. 1974. Quantitative measurement of food selection. Oecologia 14:413-417.
#' Manly, B. 1974. A model for certain types of selection experiments. Biometrics 30:281-294.
#' Strauss, R. E. 1979. Reliability Estimates for Ivlevˈs Electivity Index, the Forage Ratio, and a Proposed Linear Index of Food Selection. Transactions of the American Fisheries Society 108:344-352.
#' Vanderploeg, H., and D. Scavia. 1979. Two electivity indices for feeding with special reference to zooplankton grazing. Journal of the Fisheries Board of Canada 36:362-365.

Electivity<-function(Diet, Available,Hierarchy, Indices=c("ForageRatio","Ivlev","Strauss","JacobsQ","JacobsD","Chesson","VanderploegScavia"),Depleting=FALSE){
  individual.Elect<-data.frame(matrix(nrow = length(unique(Hierarchy[,1])), ncol = 1+length(Indices)))#make final table
  colnames(individual.Elect)<-c(Individual,Indices)
  unique.records<-as.vector(unique(Hierarchy[,1]))#get the number of unique records
  for(record.index in 1:length(unique(unique.records))){#for each record
    current.rec<-Diet[Diet$Species==unique.records[record.index],]#subset the current records data
    current.hab<-Available[Available$Habitat==current.rec$Habitat,]#subset the current records data
    
  }
#Forage Ratio  
ForageRatio<-diet/available

#Ivlev Electivity
Ivlev<-(diet-available)/(diet+available)
r<-diet/sum(diet)
p<-available/sum(diet)
(r-p)/(r+p)

#Strauss
r<-diet/sum(diet)
p<-available/sum(available)
Strauss<-r-p

#Jacobs Q
r<-diet/sum(diet)
p<-available/sum(diet)
JacobsQ<-log10((1-p)/(1-r))

#Jacobs D
r<-diet/sum(diet)
p<-available/sum(diet)
JacobsD<-(r-p)/((r+p)-(2*(r*p)))

#Chesson/Manly
r<-diet/sum(diet)
p<-available/sum(diet)
Chesson<-(r/p)/sum(r/p)
if(Depleting == TRUE){
  Chesson<-(log(p-r)/p)/sum(log(p-r)/p)
}

#Vanderploeg & Scavia
W_i<-(r/p)/sum(r/p)#Same as Chesson
VanderploegScavia<-(W_i-(1/length(W_i)))/(W_i+(1/length(W_i)))
}
