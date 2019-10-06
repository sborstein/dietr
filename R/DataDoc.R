#' FishBasePreyVals
#'
#' A data frame containing prey items and their respective trophic levels following  FishBase and
#'  TrophLab.
#'
#' @format A data frame of of 384 rows and 6 columns
#' \itemize{
#'   \item FoodI: Food category I.
#'   \item FoodII: Food category II.
#'   \item FoodIII: Food category III.
#'   \item Stage: Life history stage of the prey item.
#'   \item TL: Trophic level of the prey item.
#'   \item SE: Standard error around trophic level estimate of the prey item.
#' }
#' @references{
#' \itemize{
#'   \item Froese R, and Pauly D. 2018. FishBase. http://www.fishbase.org/2018).
#'   \item Pauly D, Froese R, Sa-a P, Palomares M, Christensen V, and Rius J. 2000. TrophLab manual. ICLARM, Manila, Philippines. 
#'   }
#' }
"FishBasePreyVals"
#' CortesPreyVals
#'
#' A data frame containing prey items and their respective trophic levels for Chondrichthyes prey from Cortes, 1999
#'
#' @format A data frame of of 10 rows and 6 columns
#' \itemize{
#'   \item FoodI: Food category I.
#'   \item FoodII: Food category II.
#'   \item FoodIII: Food category III.
#'   \item Stage: Life history stage of the prey item.
#'   \item TL: Trophic level of the prey item.
#'   \item SE: Standard error around trophic level estimate of the prey item.
#' }
#' @references{
#' \itemize{
#'   \item Cortes E. 1999. Standardized diet compositions and trophic levels of sharks. ICES Journal of marine science 56:707-717.
#'   }
#' }
"CortesPreyVals"
#' Herichthys
#'
#' Raw supplementary data from Magalhaes et al., 2015 for the diets of Herichthys minckleyi used in a tutorial for the vignette.
#'
#' @format A data frame of of 519 rows and 40 columns
#' @references{
#' \itemize{
#'   \item Magalhaes IS, Ornelas-Garcia CP, Leal-Cardin M, Ramirez T, and Barluenga M. 2015. Untangling the evolutionary history of a highly polymorphic species: introgressive hybridization and high genetic structure in the desert cichlid fish Herichtys minckleyi. Mol Ecol 24:4505-4520. 10.1111/mec.13316
#'   }
#' }
"Herichthys"
#' VirginRiverForage
#'
#' Data from Magalhaes et al., 2015 for the diet of two species of Cyprinidae in the Vergin River, Neveda over four months and prey abundance.
#'
#' @format A list of length 2 containing two data frames.
#' \itemize{
#'   \item Available A data frame with four rows and seven columns containing data on prey availability in the Virgin River over four months.
#'   \item Consumed A data frame with four rows and seven columns containing data on prey consumption by two species over four months.
#'   }
#' @references{
#' \itemize{
#'   \item Greger PD, and Deacon JE. 1988. Food partitioning among fishes of the Virgin River. Copeia 1988:314-323.
#'   }
#'  }
"VirginRiverForage"