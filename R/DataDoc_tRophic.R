#' Prey values from Fishbase/TrophLab
#'
#' A data frame containing prey item names, the prey's trophic level, and the standard error for
#' the prey item. Values are from Fishbase/TrophLab and Column names follow Fishbase style 
#' formatting as follows:
#' @format A data frame of of 165 rows and 6 columns
#' \itemize{
#'   \item FoodI: Broad category of the prey item.
#'   \item FoodII: More detailed category of prey item.
#'   \item FoodIII: Most detailed category of the food item.
#'   \item Stage: Life history stage of the prey item.
#'   \item TL: Trophic level of the prey items.
#'   \item SE: Standard error estimate around the prey items trophic level.
#' }
#' 
#' @seealso \code{\link{DietTroph}}
#' @seealso \code{\link{FoodTroph}}
#' @references 
#' Froese, R., & Pauly, D. (2000). FishBase 2000: Concepts Designs and Data Sources. 
#'  Laguna, Philippines: ICLARM.
#'  
#'  Froese, R. & Pauly, D. (2016). FishBase. Available at: http://www.fishbase.org.
#' 
#' Pauly, D., Froese, R., Sa-a, P., Palomares, M., Christensen, V. & Rius, J. (2000). TrophLab 
#'  manual. ICLARM, Manila, Philippines.
#' 
"TrophLabPrey"
