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
#' 
#' @seealso \code{\link{MergeSearchTerms}}
"FishBasePreyVals"

#' Mitochondrial DNA Search Terms for Plants
#'
#' A data frame containing search terms for plant mitochondrial loci. Can be subset for loci of 
#'  interest. Columns are as follows and users should follow the column format if they wish to
#'  add search terms using the MergeSearchTerms function:
#'
#' @format A data frame of of 248 rows and 3 columns
#' \itemize{
#'   \item Locus: Locus name, FASTA files will be written with this name
#'   \item Type: Type of subsequence, either CDS,tRNA,rRNA,misc_RNA, or D-loop
#'   \item Name:Name of synonym for a locus to search for
#' }
#' 
#' @seealso \code{\link{FoodTroph}}
"FishBasePreyVals"