#' Calculates Gastro-somatic Index (AKA Fullness Index, Index of fullness)
#' @description This function calculates Gastro-somatic fullness, the relationship between stomach
#' weight and body weight to assess fullness.
#' @param StomachData Object of class data frame containing stomach data. The data frame must be set
#' up as follows. The first column should contain the specimen identifier, the second column the 
#' stomach weight, and the third column the weight of the specimens.
#' @param Calc.Vacuity Logical. Should the vaucity index also be calculated? Default is FALSE.
#' @return Object of Class List of length 2 or 3. If Calc.Vaucity = FALSE, a list of length two 
#' is returned containing a named vector of individual specimen gastro-somatic index as well as a
#' numeric vector length of 1 containing the mean gastro-somatic index. If Calc.Vaucity = TRUE, an
#' additional numeric vector of length 1 is returned containing the calculated vaucity index.
#' @references
#' Hureau J-C. 1970. Biologie comparee de quelques poissons antarctiques (Nototheniidae). Bulletin de l'Institut Oceanographique de Monaco 68:1-244. 
#' @author Samuel Borstein
#' @seealso \code{\link{VacuityIndex}}
#' @examples
#' data(SebastesStomachs)#load example data
#' #Calculate the Gastro-somatic Index
#' my.GSI <- GastrosomaticIndex (StomachData = SebastesStomachs)
#' #Calculate the Gastro-somatic Index and Vacuity Index
#' my.GSI <- GastrosomaticIndex (StomachData = SebastesStomachs, Calc.Vacuity = TRUE)
#' @export

GastrosomaticIndex <- function (StomachData, Calc.Vacuity = FALSE){
  ifelse(Calc.Vacuity == TRUE, desired_length <- 3, desired_length <- 2)
  GSI.res <- vector(mode = "list", length = desired_length)
  ifelse(Calc.Vacuity == TRUE, names(GSI.res) <- c("IndividualGSI","MeanGSI","VacuityIndex"), names(GSI.res) <- c("IndividualGSI","MeanGSI"))
  #GoSI <- StomachData[,1]/StomachData[,2]
  GSI <- StomachData[,2]/StomachData[,3]
  names(GSI) <- StomachData[,1] 
  GSI.res [[1]] <- GSI
  GSI.res [[2]] <- mean(GSI)
  if(Calc.Vacuity == TRUE){
    GSI.res [[3]] <- VacuityIndex(StomachData)
  }
  return(GSI.res)
}

