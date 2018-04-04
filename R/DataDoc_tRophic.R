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
#' Prey values from standardize diet composition of Cortes, 1999 and Ebert & Bizzarro, 2007 for sharks and rays
#'
#' A data frame containing prey item names, the prey's trophic level, and the standard error for
#' the prey item. Values are from Cortes, 1999 who analyzed shark diets and from Ebert & Bizzarro, 
#' 2007 who analyzed rays/skate diets. These have been combined as they contain slightly different 
#' prey items. For the most part, shared prey items between the studies have similar values. 
#' However, there are different values for mysids and euphasiids (2.2 in Cortes, 1999 and 2.25 in 
#' Ebert & Bizzarro, 2007) as well as miscellaneous benthic inverts (2.5 in Cortes, 1999 and 2.4 
#' in Ebert & Bizzarro, 2007). We have therefore chosen to use the values from the more recent
#' study for this data set. As neither of these studies provide SE estimates like Fishbase/TrophLab
#' does, we have set the SE for all prey items to 0.
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
#' @seealso \code{\link{TrophLabPrey}}
#' @references 
#' Cortés, E. (1999). Standardized diet compositions and trophic levels of sharks. ICES Journal of 
#'  marine science, 56, 707-717.
#' 
#' Ebert, D.A. & Bizzarro, J.J. (2007). Standardized diet compositions and trophic levels of skates
#'  (Chondrichthyes: Rajiformes: Rajoidei). Environmental Biology of Fishes, 80, 221-237.
#' 
"ChondrichthyesPrey"