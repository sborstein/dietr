setwd("C:/Users/sam/Desktop/dietr_Manuscript/")
#Load Dependencies
library(rfishbase)
library(mgcv)
library(ggplot2)
#NOTE: Load the data and do not re-run the sampling as results will be different due to selecting different diet records
load("dietr_AnalysisCode.R")


#Get Diet Data
Diets<-diet_items()
Diets$autoctr
all.diets<-diet()
DietsWithData<-all.diets[which(!is.na(all.diets$DietCode)),]#Filter out diets missing diet codes

#Diets2Calc<-sample(unique(Diets$DietCode),replace = FALSE,size = 1000)#Randomly select 1000 diets
DietDat<-Diets[Diets$DietCode%in%Diets2Calc,]#Subset out data based on the randomly selected diet numbers
DietDat<-DietDat[,c("DietCode","FoodI","FoodII","FoodIII","Stage","DietPercent")]#Grab columns with diet data
names2Match<-match(DietDat$DietCode,DietsWithData$DietCode)#Match diet data with diet records
Species<-DietsWithData$Species[names2Match]#Match species names
NamedDiets<-cbind.data.frame(Species,DietDat)#bind oclumns of the datasets
combs<-uniquecombs(NamedDiets[,1:2])

Hierarchy<-combs[,c(2,1)]#Make taxonomic hierarchy, in this case just for the records
DietItems<-NamedDiets[,2:7]#Grab out the diet items
colnames(DietItems)[6]<-"Percent"
FB.Timing<-system.time(CompTL<-DietTroph(DietItems = DietItems,PreyValues = FishBasePreyVals,Taxonomy = Hierarchy))#Time run of function
FB.Dat<-DietsWithData[DietsWithData$DietCode%in%CompTL$DietCode$Individual,c("DietCode","Troph")]#Get the associated Trophic levels off FishBase
matchTL<-match(FB.Dat$DietCode,CompTL$DietCode$Individual)#Match the FishBase data to the dietr data
BothDat<-cbind.data.frame(FB.Dat,CompTL$DietCode$TrophicLevel[matchTL])#Merge the datasets
cor.test(BothDat$Troph,round(BothDat$`CompTL$DietCode$TrophicLevel[matchTL]`,digits = 2))#run correlation
#plot(BothDat$Troph,round(BothDat$`CompTL$DietCode$TrophicLevel[matchTL]`,digits = 2),xlab = "Trophic Level From FishBase",ylab = "Trophic Level From dietr")

foods<-fooditems()#Get food item data
unique(foods$Species)#see unique species in dataset
foods<-foods[-which(is.na(foods$FoodI)),]#Filter out records where foodI is missing info
#Food2Calc<-sample(unique(foods$Species),replace = FALSE,size = 1000)
eco<-ecology()#Get the TL from FishBase, which is in the ecology table
eco<-eco[-which(is.na(eco$FoodTroph)),]#remove records missing trophic levels
#Food2Calc<-sample(unique(eco$Species),replace = FALSE,size = 1000)#randomly select 1000 species with records
foodData<-foods[foods$Species%in%Food2Calc,]#match species between ecology table and food table
foodTax<-as.data.frame(unique(foodData$Species))#Make Taxonomy
foodDat<-foodData[,c("Species","FoodI","FoodII","FoodIII","PreyStage")]#Get pertinant food item data
colnames(foodDat)[5]<-"Stage"#change the name of the column
foodTime<-system.time(foodTL<-FoodTroph(FoodItems = foodDat,PreyValues = FishBasePreyVals,Taxonomy = foodTax,PreyClass = ))#Run and time FoodTroph function
matchFTL<-match(foodTL[[1]]$Individual,eco$Species)#Match the trophic levels from FishBase to those from dietr
BothFood<-cbind.data.frame(foodTL[[1]]$TrophicLevel,eco$FoodTroph[matchFTL])#make matched trophic levels a data frame
rownames(BothFood)<-foodTL[[1]]$Individual#make individual the row names
cor.test(BothFood$`eco$FoodTroph[matchFTL]`,round(BothFood$`foodTL[[3]]$TrophicLevel`,digits = 2))#run correlation between trophic levels from food on FishBase vs. dietr

#Set up plots
par(mfrow=c(1,2))
plot(BothDat$Troph,round(BothDat$`CompTL$DietCode$TrophicLevel[matchTL]`,digits = 2),xlab = "Trophic Level From FishBase",ylab = "Trophic Level From dietr DietTroph Function",main = "Quantitative Data", bty= 'n', cex = 1.5)#Plot quantitative data
points(BothDat$Troph[3],BothDat$`CompTL$DietCode$TrophicLevel[matchTL]`[3],col = brewer.pal(n = 3, name = 'Dark2')[3], pch =16, cex = 1.5)#Plot outlier below TL of 2
legend("topleft", "r = 0.888, p < 0.001", bty="n")# add correlation stats
CortesDat <- DietsWithData[DietsWithData$DietRefNo==33559,]#Get Cortes items, which use different trophic levels for the prey
Cortes.TL <- BothDat[BothDat$DietCode%in%CortesDat$DietCode,]#Get Cortes points
points(Cortes.TL$Troph,Cortes.TL$`CompTL$DietCode$TrophicLevel[matchTL]`,col = brewer.pal(n = 3, name = 'Dark2')[2], pch =16, cex = 1.5)#Plot cortes outlier
checkDat <- DietsWithData[DietsWithData$DietRefNo==92354,]#Get data from ICES
ICES.Samples <- BothDat[BothDat$DietCode%in%checkDat$DietCode,]#Get samples
ICES.Diets <- Diets[Diets$DietCode%in%ICES.Samples$DietCode,]#Get diets
ICES.Issues <- ICES.Diets[ICES.Diets$FoodII=="others",]#Find diets with "Others" prey, which is causing differnces in calculations
ICES.records <- BothDat[BothDat$DietCode%in%ICES.Issues$DietCode,]#Find diet codes with this prey type
points(ICES.records$Troph,round(ICES.records$`CompTL$DietCode$TrophicLevel[matchTL]`,digits = 2), col = add.alpha(brewer.pal(n = 3, name = 'Dark2')[1],0.4), pch = 16, cex = 1.5)#plot ICES outliers

plot(BothFood$`eco$FoodTroph[matchFTL]`,round(BothFood$`foodTL[[1]]$TrophicLevel`,digits = 2),xlab = "Trophic Level From FishBase",ylab = "Trophic Level From dietr FoodTroph Function",main = "Qualitative Data", bty= 'n', cex = 1.5)#plot qualitative data
legend("topleft", "r = 0.989, p < 0.001", bty="n")# add correlation stats for qualitative data


#Herichthys Data Use Case. See the vignette in dietr for a more in-depth description and tutorial on how to carry out this analysis
HMdat<-read.csv("dryad_data.csv",stringsAsFactors = FALSE)#Read data
HMdat<-HMdat[HMdat$total==100,]#Filter out records without diets
HMtax<-cbind.data.frame(HMdat$individual,paste(HMdat$lake,HMdat$year),HMdat$lake)#Make taxonomy data frame
colnames(HMtax)<-c("Individual","Lake x Year","Lake (all years)")#provide colum nales
HMtax$species<-"Herichthys minckleyi"#Make a final column for taxonomy for species. This will repeat the whole length of the dataframe
HMdat<-HMdat[,c("individual","X.Gastrop","X.Insect","X.Fish","X.Zoopl","X.plants","X.algae","X.detritus")]#Grab volumetric diet data

#Reformat columns and rows for use with dietr
Inds<-rep(x = HMdat$individual, times=6)[order(rep(x = HMdat$individual, times=6))]
FoodTypes<-rep(x = colnames(HMdat[2:7]),times=length(unique(HMtax$Individual)))

HM.mat<-as.data.frame(matrix(nrow = length(Inds),ncol = 3))
colnames(HM.mat)<-c("Individual","FoodItem","Percent")
HM.mat$Individual<-Inds
HM.mat$FoodItem<-FoodTypes
for(i in 1:nrow(HMdat)){
  rows2match<-which(HM.mat$Individual==HMdat$individual[i])
  HM.mat$Percent[rows2match]<-as.vector(as.numeric(HMdat[i,2:7]))
}

#
HM.mat<-HM.mat[!HM.mat$Percent==0,]#Remove rows where prey is equal to 0 contribution
PreyMat<-as.data.frame(matrix(ncol = 3,nrow = 6))#make matrix of prey values
colnames(PreyMat)<-c("FoodItem","TL","SE")#name columns for prey values
#Add trophic levels and SE for prey. These are equal to those on FishBase
PreyMat[,1]<-unique(FoodTypes)
PreyMat[,2]<-c(2.37,2.2,3.5,2.1,2,2)
PreyMat[,3]<-c(.58,.4,.8,.3,0,0)

#Run and time Herichthys dataset using the DietTroph function
HMtime<-system.time(HM.TL<-DietTroph(DietItems = HM.mat,PreyValues = PreyMat, PreyClass = "FoodItem",Taxonomy = HMtax,SumCheck = TRUE))

#Plot results of Herichthys dataset
library(cowplot)
library(gridExtra)
par(mfrow=c(3,1))

Hist.dat<-as.data.frame(HM.TL$Individual$TrophicLevel)
colnames(Hist.dat)<-"Trophic Level"
breaks <- seq(2.0, 4.5, .1)
labels <- as.character(breaks)
labels[!(breaks%%0.5==0)] <- ''
ybreaks<-seq(0,100,10)
ylabels <- as.character(ybreaks)
ylabels[!(ybreaks%%25==0)] <- ''


hist<-ggplot(Hist.dat, aes(x=as.numeric(Hist.dat$`Trophic Level`))) + geom_histogram(breaks=seq(2,max(Hist.dat$`Trophic Level`),.1), color ="black", fill = "lightgrey")+theme_classic()+xlab("Trophic Level")+ ylab("Frequency") +scale_x_continuous(breaks = breaks, labels = labels, limits = c(1.9,4.6))+scale_y_continuous(breaks = ybreaks, labels = ylabels, limits = c(0,110))
hist<-hist+ geom_vline(aes(xintercept=mean(Hist.dat$`Trophic Level`)),
              color="red", linetype="dashed", size=1)

HMplot.LakeYear<-ggplot(data.frame(cbind(HM.TL$Individual$TrophicLevel,HMtax$`Lake x Year`)), aes(x=as.factor(HMtax$`Lake x Year`), y=HM.TL$Individual$TrophicLevel)) + 
  geom_violin(show.legend = FALSE)+
  #scale_fill_manual(values = col.select)+
  xlab("Lake & Year")+
  ylab("Trophic Level")+
  #ggtitle("Herichthys minckleyi Trophic Levels By Lake and Year")+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_boxplot(width=0.1)+
  stat_summary(fun.y=mean, geom="point", shape=23, size=2,fill="gray")

HMplot.Lake<-ggplot(data.frame(cbind(HM.TL$Individual$TrophicLevel,HMtax$`Lake (all years)`)), aes(x=as.factor(HMtax$`Lake (all years)`), y=HM.TL$Individual$TrophicLevel)) + 
  geom_violin(show.legend = FALSE)+
  #scale_fill_manual(values = col.select)+
  xlab("Lake")+
  ylab("Trophic Level")+
  #ggtitle("Herichthys minckleyi Trophic Levels By Lake Across Years")+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_boxplot(width=0.1)+
  stat_summary(fun.y=mean, geom="point", shape=23, size=2,fill="gray")

grid.arrange(hist,HMplot.LakeYear,HMplot.Lake)
