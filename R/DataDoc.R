#' FishBasePreyVals
#'
#' A data frame containing prey items and their respective trophic levels following FishBase and
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
#'   \item Available A data frame with 2 rows and 18 columns containing data on percent weight relative abundance of macroalgae prey availability in two different years.
#'   \item Consumed A data frame with four rows and 19 columns containing data on percent weight relative abundance of macroalgae prey consumption by two species in two different years.
#'   }
#' @description Raw data from Horn, 1982. Prey consumption and availability are relative abundance by weight of macroalgae species. Note that values do not sum to 1 as dataset only includes macroalgae and not other prey items. See Table 4 and Table 4 in Horn et al., 1982.
#' @references{
#' \itemize{
#'   \item Horn M, Murray S, and Edwards T. 1982. Dietary selectivity in the field and food preferences in the laboratory for two herbivorous fishes (Cebidichthys violaceus and Xiphister mucosus) from a temperate intertidal zone. Marine Biology 67:237-246.
#'   }
#'  }
"Horn1982"
#' Casaux1998
#'
#' Data from Casaux, 1998 for the diet of Harpagifer antarcticus from two localities in the South Shetland Islands of Antarctica. 
#'
#' @format A data frames containing diet data for two populations (Potter Cove & Harmony Point) of Harpagifer antarcticus from the South Shetland Islands.
#' \itemize{
#'   \item Record: The record, in this case the name for the two populations, Harpagifer_antarcticus_PotterCove and Harpagifer_antarcticus_HarmonyPoint for populations from Potter Cover and Harmony Point respectively.
#'   \item Prey: Name of the prey item consumes.
#'   \item PercentOccurrence: Data for the percent occurrence of the prey consumed.
#'   \item PercentNumber: Data for the percent number of the prey consumed.
#'   \item PercentWeight: Data for the percent weight of the prey consumed.
#'   }
#' @description Raw data from Casaux, 1998. Prey is listed in percent frequency, percent number, and percent mass consumed.
#' @references{
#' \itemize{
#'   \item Casaux R. 1998. The contrasting diet of Harpagifer antarcticus (Notothenioidei, Harpagiferidae) at two localities of the South Shetland Islands, Antarctica. Polar Biology 19:283-285.
#'   }
#'  }
"Casaux1998"
#' SebastesStomachs
#'
#' Stomach and specimen weights for eleven Sebastes flavidus from the Gulf of Alaska by NOAA in 2011 (available at: https://access.afsc.noaa.gov/REFM/REEM/WebDietData/DietDataIntro.php). 
#'
#' @format A data frames containing three columns with specimen identifier, specimen stomach weight, and specimen weight for eleven Sebastes flavidus.
#' \itemize{
#'   \item SpecimenSpecimen identifier. Follows the pattern of number, month, day, and year.
#'   \item StomachWeight: Weight of stomach contents in grams.
#'   \item PredatorWeight: Weight of the specimen in grams.
#'   }
#' @description Raw data from NOAA containing information on the stomach weight and specimen weight of eleven Sebastes flavidus caught in the Gulf of Alaska in 2011.
#' @references{
#' \itemize{
#'   \item Livingston PA, Aydin K, Buckley TW, Lang GM, Yang M-S, and Miller BS. 2017. Quantifying food web interactions in the North Pacific - a data-based approach. Environmental Biology of Fishes 100:443-470. 10.1007/s10641-017-0587-0.
#'   \item .
#'   }
#'  }
"SebastesStomachs"