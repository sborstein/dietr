#' An R package to estimate trophic level from diet and food item data
#'
#' @description Trophic level estimation from diet and food item data
#'
#' @details 
#' Package: tRophic
#' 
#' Type: Package
#' 
#' Title: An R package to estimate trophic level from diet and food item data
#' 
#' Version: 1.0a
#' 
#' Date: 2018-4-4
#' 
#' License: GPL (>= 2)
#' 
#' This package allows users to calculte trophic levels from proportional diet data or from food 
#' items given trophic levels of the prey items. This package calculates trophic level following 
#' the procedures from TrophLab, which was a microsoft access program. This implementation is faster
#' than the original microsoft access program and also allows for a hierarchical estimation of 
#' trophic level given a corresponding "taxonomy" data frame (i.e. estimate trophic level for a 
#' individual,population,species, etc.). 
#'  
#' @author Samuel Borstein
#' Maintainer: Samuel Borstein <sborstei@vols.utk.edu>
#' 
#' @seealso \code{\link{ConvertFishbaseDiet}},\code{\link{ConvertFishbaseFood}},\code{\link{DietTroph}},\code{\link{FoodTroph}},\code{\link{TrophLabPrey}},\code{\link{ChondrichthyesPrey}}
#' 
#' @docType package
#' @name tRophic
#"_PACKAGE"
#> [1] "_PACKAGE"
NULL