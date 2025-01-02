#' Calculates a variety of electivity indices and foraging ratios
#' @description This function calculates the forage ratio and a variety of electivity indices. Included indices include Ivlev's (1961),
#' Strauss' (1979), Jacob's Q and D (1974), Chesson's (1983)(Which is similar to Manly's Alpha (1974)), and Vanderploeg & Scavia (1979).
#' @param Diet Data frame with data corresponding to consumed resources found in the diet. See details for formatting.
#' @param Available Data frame with data corresponding to the available resources. See details for formatting.
#' @param Indices Character vector containing the names of the desired indices to calculate. See description for information on available indices. 
#' @param LogQ Logical. If true, should Jacob's Q be logged? This is the recommendation of Jacob, 1974.Default is TRUE, following the recommendation. 
#' @param CalcAbundance Logical. If true, are the data raw and would you like to calculate the relative abundance? Relative abundance will be calculated for both diet and available given the row sums of the supplied Diet and Available parameter inputs. Default is False, i.e. relative abundances are not calculated.
#' @param Depleting Logical. If true, calculates Chesson's Case 2, where food depletion occurs and the available food is not constant. Default is False.
#' @details 
#' This function calculates one or multiple electivity indices for one or more diet records for which one or more records of prey availability exists.For example,
#' it is possible to calculate multiple indices for multiple diet records that may be from a number of sites with different prey
#' availability all in one call of the function (see example which ). Specifically, this function measures the following indices (and their input for the Indices argument)
#' Ivlev's (1961) Forage Ratio ("ForageRatio") and electivity ("Ivlev"), Strauss'(1979) ("Strauss"), Jacobs (1974) Q ("JacobsQ") and D ("JacobsD"), Chesson (1983)(Which is similar to Manly's Alpha (1974))("Chesson"),
#' and Vanderploeg & Scavia (1979) ("VanderploegScavia"). For those wishing to calculate Vanderploeg and Scavia's selectivity coefficient (W), please select "Chesson" as an argument for indices, which
#' will calculate Chesson's alpha, which is identical to Vanderploeg and Scavia's selectivity coefficient (W).
#' 
#' The function takes two data frames as input. The first argument, Diet, should be formatted as followed. Each row in the data frame should be a diet record. 
#' The first column should contain the name of the record to be calculated. The second column should contain the name linking the consumed prey in Diet to that in Available (example, name of the different habitats, note in our example it is "Year"), which will be described below.
#' All remaining columns should contain the abundance or relative abundance of the prey in the diet. These columns should also be named so they can be matched to those in Available. The second data frame, Available should be formatted similar to Diet where each row describes a unique record for available prey.
#' The remaining columns should contain the abundance or relative abundance of the prey that are available to be consumed. These columns should also be named so they can be matched to Those in Diet. These indices typically utilize relative abundances and the abundances with relative abundance represented by a decimal (i.e sum to 1). Users can supply raw data that are not in relative abundances and use the 
#' CalcAbundance option to calculate relative abundances if they wish to do so. By default, CalcAbundance is set to FALSE and assumes the supplied data are already in relative abundance, so users wishing to calculate relative abundance should use CalcAbundance = TRUE.
#'  
#' Indices are bounded by the following values. Ivlev's, Strauss', and Jacobs' D, and Vanderploeg & Scavia's indices are bounded between -1 and 1, with items closer to -1 representing avoided items, 0 randomly feeding, and 1 preferential items.
#' Forage ratio values range between 1 and infinity for preferred items while values between 0 and 1 represent avoided prey. Similar to forage ratio, Jacobs' Q ranges  
#' between 1 and infinity for preferred items and 0 and 1 for avoided prey, however log10(Q) is the preferred as it provides 
#' the advantage of equal ranges and ranges from -infinity to +infinity for avoidance and preference respectively. This option can be selected in the function with the logQ argument, which by default is set to TRUE. 
#' Finally, Chesson's index ranges between 0 and 1 and preference is typically assessed using 1/n, where n is the number of prey types. The value of 1/n represents random feeding while values 
#' above and below 1/n represent preference and avoidance respectively. For Chesson's index, users can also specify if the available resources are 
#' depleting, in which case the equation from case 2 of Chesson, 1983 is calculated. Note, this takes the log of (p-r)/p) and values of 0 or negatives will return NaN.
#' @return Object of class Electivity which is a list containing data frames for each electivity index selected.
#' @author Samuel Borstein
#' @seealso \code{\link{PlotElectivity}}
#' @examples
#' #Load Electivity Data from Horn 1982
#' data(Horn1982)
#' #Run all electivity indices
#' my.indices <- Electivity(Diet = Horn1982$Consumed, Available = Horn1982$Available, Indices = 
#' c("ForageRatio","Ivlev","Strauss","JacobsQ","JacobsD","Chesson","VanderploegScavia"),LogQ = TRUE,
#' CalcAbundance = FALSE, Depleting = FALSE)
#' @references
#' Chesson, J. 1983. The estimation and analysis of preference and its relatioship to foraging models. Ecology 64:1297-1304.
#' 
#' Ivlev, U. 1961. Experimental ecology of the feeding of fish. Yale University Press, New Haven.
#' 
#' Jacobs, J. 1974. Quantitative measurement of food selection. Oecologia 14:413-417.
#' 
#' Manly, B. 1974. A model for certain types of selection experiments. Biometrics 30:281-294.
#' 
#' Strauss, R. E. 1979. Reliability Estimates for Ivlev's Electivity Index, the Forage Ratio, and a Proposed Linear Index of Food Selection. Transactions of the American Fisheries Society 108:344-352.
#' 
#' Vanderploeg, H., and D. Scavia. 1979. Two electivity indices for feeding with special reference to zooplankton grazing. Journal of the Fisheries Board of Canada 36:362-365.
#' @export

Electivity <- function(Diet, Available, Indices = c("ForageRatio","Ivlev","Strauss","JacobsQ","JacobsD","Chesson","VanderploegScavia"), LogQ = TRUE, CalcAbundance = FALSE, Depleting = FALSE){
  if(any(!colnames(Diet)[3:ncol(Diet)]%in%colnames(Available)[2:ncol(Available)]))stop('All prey items in Diet must also be occur in Available')
  if(any(!Diet[,2]%in%Available[,1]))stop('Some habitats in Diet and Available do not match. Check to make sure the occur in both data frames')
  if(any(!colnames(Diet)[3:ncol(Diet)]==colnames(Available)[2:ncol(Available)]))warning('Prey items in Diet and in Available are not in the same order, re-ordering')
  if(any(Diet[3:ncol(Diet)]>1)|any(Available[2:ncol(Available)]>1) && CalcAbundance == FALSE)warning('Some values are greater than 1, but you specified not to calculate relative abundance. You may get odd results for some indices. For relative abundance, data should sum to 1 and therefore cannot be greater than 1. If your data are relative abundance, you may need to divide them by 100 so they sum to 1. If they are not yet in relative abundance, please use CalcAbundance = TRUE')
  if (CalcAbundance == TRUE) {
    Diet[,3:ncol(Diet)] <- Diet[,3:ncol(Diet)]/rowSums(Diet[,3:ncol(Diet)])
    Available[,2:ncol(Available)] <- Available[,2:ncol(Available)]/rowSums(Available[,2:ncol(Available)])
  }
  order.available <- order(match(colnames(Available),colnames(Diet)))
  Available <- Available[,order.available]
  MatchHabs <- merge(Diet,Available,by.x = colnames(Diet)[2],by.y = colnames(Available)[1],sort = FALSE)
  Diet.Dat <- grep(".x",colnames(MatchHabs),fixed = TRUE)
  Available.Dat <- grep(".y",colnames(MatchHabs),fixed = TRUE)
  OrgDat <- data.frame(matrix(ncol = 1+length(Available),nrow = nrow(Diet)))  
  colnames(OrgDat) <- c("Record","Available",colnames(Diet[-c(1:2)]))
  OrgDat$Record <- MatchHabs[,2]
  OrgDat$Available <- MatchHabs[,1]
  ElectivIndices <- rep(list(OrgDat),times=length(Indices))
  names(ElectivIndices) <- Indices
  if (any(Indices=="ForageRatio")) {
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    ElectivIndices$ForageRatio[,-c(1:2)] <- r/p
  }
  if (any(Indices=="Ivlev")) {
    #Ivlev=(r-p)/(r+p)
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    ElectivIndices$Ivlev[,-c(1:2)] <- (r-p)/(r+p)
  }
  if (any(Indices=="Strauss")) {
    #Strauss<-r-p
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    ElectivIndices$Strauss[,-c(1:2)] <- r-p 
  }
  if (any(Indices=="JacobsQ")) {
    #JacobsQ=log10((1-p)/(1-r))
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    ifelse(LogQ == TRUE, ElectivIndices$JacobsQ[,-c(1:2)]<-log10((r*(1-p))/(p*(1-r))), ElectivIndices$JacobsQ[,-c(1:2)]<-(r*(1-p))/(p*(1-r)))
  }
  if (any(Indices=="JacobsD")) {
    #JacobsD=(r-p)/((r+p)-(2*(r*p)))
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    ElectivIndices$JacobsD[,-c(1:2)] <- (r-p)/((r+p)-(2*(r*p))) 
  }
  #CHECK IF SUM OR ROWSUM  
  if (any(Indices=="Chesson")) {
    #Chesson = (r/p)/sum(r/p)
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    num <- r/p
    is.na(num) <- sapply(num, is.infinite)
    num[is.na(num)] <- NA
    #W_i<-num/rowSums(num,na.rm = TRUE)#Same as Chesson
    ifelse(Depleting == FALSE, ElectivIndices$Chesson[,-c(1:2)]<- (num)/rowSums(num,na.rm = TRUE),ElectivIndices$Chesson[,-c(1:2)]<-((log((p-r)/p))/(rowSums(log((p-r)/p),na.rm = TRUE))))
  }
  if (any(Indices=="VanderploegScavia")) {
    #W_i = (r/p)/sum(r/p) Which Is The Same as Chesson
    #VanderploegScavia = (W_i-(1/length(W_i)))/(W_i+(1/length(W_i)))
    r <- MatchHabs[,Diet.Dat]
    p <- MatchHabs[,Available.Dat]
    num <- r/p
    is.na(num) <- sapply(num, is.infinite)
    num[is.na(num)] <- NA
    W_i <- num/rowSums(num,na.rm = TRUE)#Same as Chesson
    ElectivIndices$VanderploegScavia[,-c(1:2)] <- (W_i-(1/length(W_i)))/(W_i+(1/length(W_i)))
  }
  ElectivIndices <- rapply(ElectivIndices, f=function(x) ifelse(is.infinite(x),NA,x), how="replace" )
  ElectivIndices <- rapply(ElectivIndices, f=function(x) ifelse(is.nan(x),NA,x), how="replace" )
  class(ElectivIndices) <- "Electivity"
  return(ElectivIndices)
}