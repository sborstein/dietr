#' Calculates the vacuity index, the proportion of fish which contain food in their stomach.
#' @description This function calculates the vacuity index, the frequency of fish which lack food in 
#' their stomach.
#' @param StomachData Object of class data frame containing stomach data. The data frame must be set
#' up as follows. The first column should contain the specimen identifier, the second column the 
#' stomach weight.
#' @details This function calculates the vacuity index (Hureau, 1970). This is simply the percentage
#' ofempty stomachs. The function takes a data frame of stomach data, which should be formatted as 
#' follows. The first column should contain the specimen identifier and the second column should 
#' contain the stomach weight. If users also have information on fish weight, they can calculate the
#' Gastro-somatic index, using the function GastrosomaticIndex, which has an option to calculate the 
#' vaucity index utilizing this function.
#' @return Numeric vector of length one with the calculated vacuity index.
#' @references
#' Hureau J-C. 1970. Biologie comparee de quelques poissons antarctiques (Nototheniidae). Bulletin de l'Institut Oceanographique de Monaco 68:1-244. 
#' @author Samuel Borstein
#' @seealso \code{\link{GastrosomaticIndex}}
#' @examples 
#' data(SebastesStomachs)#load example data
#' My.Vacuity <- VacuityIndex(StomachData = SebastesStomachs)
#' @export

VacuityIndex <- function (StomachData){
  EmptyStomachs <- length(which(StomachData[,2]==0))
  TotalStomachs <- nrow(StomachData)
  VI <- (EmptyStomachs/TotalStomachs)*100
  return(VI)
}
