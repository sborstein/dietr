#' Creates Electivity plots
#' @description This function create a plot of electivity values calculated by 
#' the function Electivity.
#' @param Electivity.Calcs An object of class Electivity produced by the function Electivity.
#' @param Indices Character. Which index should be plotted. Options can include any single index or 
#' combination of Ivlev, Strauss, JacobsD, and VanderploegScavia.
#' @param BarColor Character vector. Color to be assigned for each record in Electivity.Calcs. If
#' specified, it should be the sames as the number of rows/records in Electivity.Calcs. If not specified, 
#' colors are randomly selected from the rainbow color pallette.
#' @param NameSize Numeric. Controls the font size for names of prey on the x-axis. Default = 1.
#' @param AxisFontSize Numeric. Contols the font size of values on the y-axis. Default = 1.
#' @param BorderCol Character or Logical. specifying color for the border. If users wish to not 
#' include a border between bars, they should set this to FALSE. Default = Black.
#' @param LegendFontSize Numeric. Controls the font size of the legeng. Default = 1.
#' @param LegendTitle Character. Title of the legend. Default is called "Record" following the
#' formatting returned by the Electivity function, but if records are distinct species, could be for
#' example set to "species".
#' @return One or more plots. Length of the plots will equal the length of the Index parameter
#' @author Samuel Borstein
#' @seealso \code{\link{Electivity}}
#' @examples
#' #Load Electivity Data from Horn 1982
#' data(Horn1982)
#' #Run all electivity indices
#' my.indices <- Electivity(Diet = Horn1982$Consumed, Available = Horn1982$Available, 
#' Indices = c("Ivlev","Strauss","JacobsD","VanderploegScavia"),LogQ = TRUE, Depleting = FALSE)
#' 
#' #Plot All Indices with default colors
#' PlotElectivity(Electivity.Calcs = my.indices)
#' #Plot only VanderploegScavia and set colors. Note, there are four records, so we need 
#' #to set four colors
#' PlotElectivity(Electivity.Calcs = my.indices, Indices = "VanderploegScavia", 
#' BarColor = c("Red","Purple","Black","Grey"))
#' @export

PlotElectivity <- function(Electivity.Calcs, Indices = c("Ivlev","Strauss","JacobsD","VanderploegScavia"), BarColor = NULL, NameSize = 1, AxisFontSize = 1, BorderCol = "Black", LegendFontSize = 1, LegendTitle = "Record"){
  if(!class(Electivity.Calcs)=="Electivity")stop('Data is not of class electivity. See the Electivity function to calculate Electivity indices')
  Data2Plot <- Electivity.Calcs[which(names(Electivity.Calcs)%in%Indices)]
  ifelse(is.null(BarColor), BarColor <- grDevices::rainbow(n=nrow(Data2Plot[[1]])), BarColor <- BarColor)
  if (!length(BarColor)==nrow(Data2Plot[[1]])) {
    stop(paste0("You have only specified ",length(BarColor)," colors, but the dataset has ", nrow(Data2Plot[[1]])," records. These must match"))
  }
  graphics::par(mar=c(11,4,4,15))
  for(PlotIndex in 1:length(Data2Plot)){
    current.dat <- Data2Plot[[PlotIndex]]
    current.dat.cleaned <- current.dat[,3:19]
    graphics::barplot(as.matrix(current.dat.cleaned),beside = TRUE, col = BarColor, ylim = c(-1,1),cex.axis = AxisFontSize, cex.names = NameSize, las =2, ylab = "Electivity", axis.lty = 0,border = BorderCol, main = names(Data2Plot[PlotIndex]))
    graphics::abline(h=0)
    graphics::legend("topright",legend = current.dat$Record,bty = 'n', cex = LegendFontSize, xpd = TRUE, inset = c(-.35,0), col = BarColor, pch = 15,title = LegendTitle)
  }
}
