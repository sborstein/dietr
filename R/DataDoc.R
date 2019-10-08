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
#' Horn1982
#'
#' Data from Horn, 1982 for the diet of two species of Stichaeidae and prey availability over two years. 
#'
#' @format A list of length 2 containing two data frames.
#' \itemize{
#'   \item Available A data frame with 2 rows and 18 columns containing data on prey availability in two different years.
#'   \item Consumed A data frame with four rows and 19 columns containing data on prey consumption by two species in two different years..
#'   }
#' @description Raw data from Horn, 1982. Prey consumption and availability are in percent weight. Not that as the values do not sum to 100, the relative abundance will be calculated.
#' @references{
#' \itemize{
#'   \item Horn M, Murray S, and Edwards T. 1982. Dietary selectivity in the field and food preferences in the laboratory for two herbivorous fishes (Cebidichthys violaceus and Xiphister mucosus) from a temperate intertidal zone. Marine Biology 67:237-246.
#'   }
#'  }
"Horn1982"