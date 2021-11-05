#' Calculates various composite indices for studying trophic ecology
#' @param DietData A data frame containing the diet data. See details for information on formatting
#' @param Indices Character vector of indices to calculate. Options are IOP for index of preponderance, IRI for index of relative importance, and FQ for feeding quotient.
#' @param PercentNumber Numeric. Column number in DietData containing the percent numeric data. If calculating an index that does not require percent number data, can be left as NA.
#' @param PercentOccurrence Numeric. Column number in DietData containing the percent Occurrence data. If calculating an index that does not require frequency of occurrence data, can be left as NA.
#' @param PercentVolWeight Numeric. Column number in DietData containing the percent volume or weight data.
#' @param ReturnRaw Logical. Should the raw input data be returned with the compound indices? Default is FALSE (i.e. only the calculated indices are returned).
#' @param PercentOnly Logical. Should composite indices only be returned as percentages or should the raw calculated values be returned? Default is TRUE (i.e. indices are returned as percentages only). 
#' @details This function calculates compound indices (indices combining various diet measurements). Specifically, this function calculates three indices: The Index of Preponderance,
#' the Index of Relative Importance, and the Feeding Quotient. These indices have numerous synonyms, and for a review of them, I recommend de Silviera et al., 2020. With this function 
#' users can select to calculate one or more of the three compound indices mentioned above. The Index of Preponderance (Natarajan & Jhingran, 1961 AKA Feeding Index Kawakami & Vazzoler, 1980) is the 
#' product of the frequency of occurrence of prey with either their volumetric or weight contribution to the diet. The Index of Relative Importance (Pinkas et al., 1971) is calculated as the 
#' the product of the sum of the weight or volume of a prey item and the percent number and the percent frequency occurrence. The Feeding Quotient (Hureau, 1970) is the product of the percent number
#' and the percent weight. These indices can be returned as just a percentage or the percentage and the raw calculations with the PercentOnly argument.
#' 
#' The main input for this function is DietData, which requires minimal formatting. It is mandatory for this function that the first column contain the diet record identifier and the second column the names of
#' the prey. The diet record identifier should be a unique name for each record, which allows one to calculate feeding indices for numerous records with a single call of the function. As the second column
#' contains the prey identifier, if a species feeds upon three different prey, the first three rows of the dataset should have the same record identifier. The remaining columns should contain
#' information on the the contribution of the various prey to the diet of the record required to calculate the indices. Note that the order of these columns does not matter as the frequency of occurrence, 
#' precent number, and percent volume or weight are specified with the arguments PercentNumber, PercentOccurrence, and PercentVolWeight respectively. Users should enter in the column number for these arguments 
#' that corresponds to their respective position in DietData. If you are having difficulty formatting data, I highly recommend seeing the format of the diet data used in the example below, which can be loaded
#' by running data(Casaux1998). This example is for two unique diet records for the fish Harpagifer antarcticus from two different localities (Potter Cove and Harmony Point) and contains data on the frequency of occurrence 
#' percent number, and percent mass of the prey in the diets of the fish from these two populations.
#' @return A list the length of the unique records in DietData containing data frames with the calculated diet indices. The lists will be names with the respective diet record names. 
#' @author Samuel Borstein
#' @examples
#' #Load diet data from Casaux1998, which contains diet for two populations of Harpagifer
#' # antarcticus in percent frequency, percent number, and percent mass.
#' data(Casaux1998)
#' #Calculate all three diet indices (IOP, IRI, FQ), return the raw data, and all calculations.
#' CompositeIndices(DietData = Casaux1998, Indices = c("IOP","IRI","FQ"), PercentNumber = 4, 
#' PercentOccurrence = 3, PercentVolWeight = 5, ReturnRaw = TRUE, PercentOnly = FALSE)
#' #Calculate all three diet indices and return only the percent of the index
#' CompositeIndices(DietData = Casaux1998, Indices = c("IOP","IRI","FQ"), PercentNumber = 4, 
#' PercentOccurrence = 3, PercentVolWeight = 5, ReturnRaw = FALSE, PercentOnly = TRUE)
#' #Calculate Feeding Quotient and return the raw data and the all calculations.
#' CompositeIndices(DietData = Casaux1998, Indices = "FQ", PercentNumber = 4, PercentVolWeight = 5,
#' ReturnRaw = FALSE, PercentOnly = FALSE)
#' @references
#' da Silveira EL, Semmar N, Cartes JE, Tuset VM, Lombarte A, Ballester ELC, and Vaz-dos-Santos AM. 2019. Methods for Trophic Ecology Assessment in Fishes: A Critical Review of Stomach Analyses. Reviews in Fisheries Science & Aquaculture 28:71-106. 10.1080/23308249.2019.1678013
#' 
#' Hureau J-C. 1970. Biologie comparee de quelques poissons antarctiques (Nototheniidae). Bulletin de l'Institut Oceanographique de Monaco 68:1-244. 
#' 
#' Kawakami E, and Vazzoler G. 1980. Metodo grafico e estimativa de indice alimentar aplicado no estudo de alimentacao de peixes. Boletim do Instituto Oceanografico 29:205-207.
#' 
#' Natarajan A, and Jhingran A. 1961. Index of preponderance-a method of grading the food elements in the stomach analysis of fishes. Indian Journal of Fisheries 8:54-59.
#' 
#' Pinkas L, Oliphant MS, and Iverson IL. 1971. Food Habits of Albacore, Bluefin Tuna, and Bonito In California Waters. Fish Bulletin 152:1-105.
#' @export

CompositeIndices <- function (DietData, Indices = c("IOP","IRI","FQ"), PercentNumber = NA, PercentOccurrence = NA, PercentVolWeight = NA, ReturnRaw = FALSE, PercentOnly = TRUE){
  DietData <- data.frame(DietData,stringsAsFactors = FALSE)
  uni.records <- unique(DietData[,1])
  Store.Indices <- vector(mode = "list", length = length(uni.records))
  names(Store.Indices) <- uni.records
  for(record.index in seq_along(uni.records)){
    current.record <- DietData[DietData[,1]==uni.records[record.index],]
    if(ReturnRaw == TRUE){
      #IndicesCalced <- data.frame(matrix(nrow = nrow(current.record),ncol = 1+length(Indices)+length(which(!is.na(c(PercentNumber,PercentOccurrence,PercentVolWeight))==TRUE))))
      IndicesCalced <- data.frame(matrix(nrow = nrow(current.record),ncol = 1+length(which(!is.na(c(PercentNumber,PercentOccurrence,PercentVolWeight))==TRUE))))
      RawCols <- c("PercentNumber","PercentOccurrence","PercentVolWeight")
      Raw.Check <- which(!is.na(c(PercentNumber,PercentOccurrence,PercentVolWeight)))
      colnames(IndicesCalced) <- c("Prey",RawCols[Raw.Check])
      IndicesCalced[,1] <- current.record[,2]
      if(any(colnames(IndicesCalced)=="PercentNumber")){
        IndicesCalced$PercentNumber <- current.record[,PercentNumber]
      }
      if(any(colnames(IndicesCalced)=="PercentOccurrence")){
        IndicesCalced$PercentOccurrence <- current.record[,PercentOccurrence]
      }
      if(any(colnames(IndicesCalced)=="PercentVolWeight")){
        IndicesCalced$PercentVolWeight <- current.record[,PercentVolWeight]
      }

    }else{
      IndicesCalced <- data.frame(matrix(nrow = nrow(current.record),ncol = 1))
      colnames(IndicesCalced) <- c("Prey")
      IndicesCalced[,1] <- current.record[,2]
    }
    if(any(Indices == "IOP")){
      Current.IOP <- Calc.IOP(DietData = current.record, PercentOccurrence = PercentOccurrence, PercentVolWeight = PercentVolWeight)
      if(PercentOnly == TRUE){
        IndicesCalced$'%IOP' <- Current.IOP$`%IOP`
      }else{
        IndicesCalced <- cbind.data.frame(IndicesCalced,Current.IOP)
      }
    }
    if(any(Indices == "IRI")){
      Current.IRI <- Calc.IRI(DietData = current.record, PercentOccurrence = PercentOccurrence, PercentNumber = PercentNumber, PercentVolWeight = PercentVolWeight)
      if(PercentOnly == TRUE){
        IndicesCalced$'%IRI' <- Current.IRI$`%IRI`
      }else{
        IndicesCalced <- cbind.data.frame(IndicesCalced,Current.IRI)
      }
    }
    if(any(Indices == "FQ")){
      Current.FQ <- Calc.FQ(DietData = current.record, PercentNumber = PercentNumber, PercentVolWeight = PercentVolWeight)
      if(PercentOnly == TRUE){
        IndicesCalced$'%FQ' <- Current.FQ$`%FQ`
      }else{
        IndicesCalced <- cbind.data.frame(IndicesCalced,Current.FQ)
      }
    }
    Store.Indices[[record.index]] <- IndicesCalced
  }
  return(Store.Indices)
}

##################################
####Function to calculate IOP#####
##################################
Calc.IOP <- function (DietData, PercentOccurrence, PercentVolWeight){
  VO <- DietData[,PercentOccurrence]*DietData[,PercentVolWeight]
  sumVO <- sum(VO)
  PercentIOP <- (VO/sumVO)*100
  IOP <- cbind.data.frame(VO,PercentIOP)
  colnames(IOP) <- c("IOP","%IOP")
  return(IOP)
}

##################################
####Function to calculate IRI#####
##################################
Calc.IRI <- function (DietData, PercentNumber, PercentOccurrence, PercentVolWeight){
  NVO <- (DietData[,PercentNumber]+DietData[,PercentVolWeight])*DietData[,PercentOccurrence]
  sumNVO <- sum(NVO)
  PercentIRI <- (NVO/sumNVO)*100
  IRI <- cbind.data.frame(NVO,PercentIRI)
  colnames(IRI) <- c("IRI","%IRI")
  return(IRI)
}

##################################
####Function to calculate IRI#####
##################################
Calc.FQ <- function (DietData, PercentNumber, PercentVolWeight){
  NV <-  DietData[,PercentNumber]*DietData[,PercentVolWeight]
  sumNV <- sum(NV)
  PercentFQ <- (NV/sumNV)*100
  FQ <- cbind.data.frame(NV,PercentFQ)
  colnames(FQ) <- c("FQ","%FQ")
  return(FQ)
}

