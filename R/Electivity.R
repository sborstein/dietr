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
#' Strauss, R. E. 1979. Reliability Estimates for Ivlev's Electivity Index, the Forage Ratio, and a Proposed Linear Index of Food Selection. Transactions of the American Fisheries Society 108:344-352.
#' Vanderploeg, H., and D. Scavia. 1979. Two electivity indices for feeding with special reference to zooplankton grazing. Journal of the Fisheries Board of Canada 36:362-365.
#' @export

Electivity<-function(Diet, Available, Indices=c("ForageRatio","Ivlev","Strauss","JacobsQ","JacobsD","Chesson","VanderploegScavia"),Depleting=FALSE){
  if(any(!colnames(Diet)[3:ncol(Diet)]%in%colnames(Available)[2:ncol(Available)]))stop('Items in Diet and in Available must be the same')
  if(any(!Diet[,2]%in%Available[,1]))stop('Some habitats in Diet and Available do not match. Check to make sure the occur in both data frames')
  OrgDat<-data.frame(matrix(ncol = 1+length(Available),nrow = nrow(Diet)))  
  colnames(OrgDat)<-c("Record","Available",colnames(Diet[-c(1:2)]))
  OrgDat$Record<-Diet[,1]
  OrgDat$Available<-Diet[,2]
  order.available<-order(match(colnames(Available),colnames(Diet)))
  Available<-Available[,order.available]
  ElectivIndices<-rep(list(OrgDat),times=length(Indices))
  names(ElectivIndices)<-Indices
  MatchHabs<-merge(Diet,Available,by.x = "Habitat",by.y = "Habitat")
  Diet.Dat<-grep(".x",colnames(MatchHabs),fixed = TRUE)
  Available.Dat<-grep(".y",colnames(MatchHabs),fixed = TRUE)
  if (any(Indices=="ForageRatio")) {
    #ForageRatio<-Diet/Available
    ElectivIndices$ForageRatio[,-c(1:2)]<-MatchHabs[,Diet.Dat]/MatchHabs[,Available.Dat]
  }
  if (any(Indices=="Ivlev")) {
    #Ivlev=(r-p)/(r+p)
    r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
    p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
    ElectivIndices$Ivlev[,-c(1:2)]<-(r-p)/(r+p)
  }
  if (any(Indices=="Strauss")) {
    #Strauss<-r-p
    r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
    p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
    ElectivIndices$Strauss[,-c(1:2)]<-r-p
  }
  if (any(Indices=="JacobsQ")) {
    #JacobsQ=log10((1-p)/(1-r))
    r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
    p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
    ElectivIndices$JacobsQ[,-c(1:2)]<-log10((1-p)/(1-r))
  }
  if (any(Indices=="JacobsD")) {
    #JacobsD=(r-p)/((r+p)-(2*(r*p)))
    r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
    p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
    ElectivIndices$JacobsD[,-c(1:2)]<-(r-p)/((r+p)-(2*(r*p)))
  }
  if (any(Indices=="Chesson")) {
    #Depleting Chesson = (log(p-r)/p)/sum(log(p-r)/p)
    #Chesson = (r/p)/sum(r/p)
    if(Depleting == FALSE){
      r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
      p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
      ElectivIndices$Chesson[,-c(1:2)]<-(r/p)/sum(r/p)
    }
    if(Depleting == TRUE){
      ElectivIndices$Chesson[,-c(1:2)]<-(log(p-r)/p)/sum(log(p-r)/p)
    }
  }
  if (any(Indices=="VanderploegScavia")) {
    #W_i = (r/p)/sum(r/p) Which Is The Same as Chesson
    #VanderploegScavia = (W_i-(1/length(W_i)))/(W_i+(1/length(W_i)))
    r<-MatchHabs[,Diet.Dat]/rowSums(MatchHabs[,Diet.Dat])
    p<-MatchHabs[,Available.Dat]/rowSums(MatchHabs[,Available.Dat])
    W_i<-(r/p)/sum(r/p)#Same as Chesson
    ElectivIndices$VanderploegScavia[,-c(1:2)]<-(W_i-(1/length(W_i)))/(W_i+(1/length(W_i)))
  }
  return(ElectivIndices)
}