# DataScience02Homework.R

# Clear Workspace
rm(list=ls())
# Clear Console:
cat("\014")

# Get Data
url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00225/Indian Liver Patient Dataset (ILPD).csv"
ILPD <- read.csv(url, header=FALSE, stringsAsFactors=FALSE)

# What does the data look like?
head(ILPD)

# Manually construct a vector of column using
# http://archive.ics.uci.edu/ml/datasets/ILPD+(Indian+Liver+Patient+Dataset)#
headers <- c("Age","Gender","DB","TB","Alkphos","Sgpt","Sgot","TPr","ALB","AGRatio","Selector") 
headers

# Associate names with the dataframe
names(ILPD) <- headers
head(ILPD)

# Understand the data structures (types)
is(ILPD)
sapply(ILPD, is)

# Size of ILPD
ncol(ILPD)
nrow(ILPD)

# Determine the mean, median, and standard deviation (sd) of each column

# This is how you can determine the mean of the 1st column
mean(ILPD[                  ,1]) # indexed as if data frame is a matrix
mean(ILPD[[1]]) # specify first vector
mean(ILPD[1]) # doesn't work
mean(ILPD$Age) # specify first vector by name

# Note that AGRatio and Gender have NA results
sapply(ILPD, mean)
sapply(ILPD, sd)
sapply(ILPD, median)

# What's the matter with Gender?

# What's wrong with AGRatio"
ILPD[!complete.cases(ILPD),  ]

mean(ILPD$AGRatio)
?mean
mean(ILPD$AGRatio, na.rm=T)

# Remove values with NA's from calculations
# Note that AG can now be calculated
# Standard Deviation and mean are not calculated for Gender
# Interestingly, median is calculated
sapply(ILPD, mean, na.rm=TRUE)
sapply(ILPD, sd, na.rm=T)
sapply(ILPD, median, na.rm=T)

# Another way to determine mean and median
summary(ILPD)

# Count number of NAs
numberOfNAs <- sum(is.na(ILPD))
numberOfNAs

# Count number of rows that have at least one NA
NumberBadCases <- nrow(ILPD) - sum(complete.cases(ILPD))
NumberBadCases

badCases <- ILPD[!complete.cases(ILPD), ]
nrow(badCases)

# Another way to remove NA's:  The whole row is removed
# ILPD_noNA has fewer rows than ILPD
nrow(ILPD)
ILPD <- na.omit(ILPD)
nrow(ILPD)
head(ILPD)

# Plot all histomgrams
hist(ILPD$Age, col="cyan")
hist(ILPD$Gender, col="cyan")
hist(ILPD$TB, col="cyan")
hist(ILPD$DB, col="cyan")
hist(ILPD$Alkphos, col="cyan")
hist(ILPD$Sgpt, col="cyan")
hist(ILPD$Sgot, col="cyan")
hist(ILPD$TP, col="cyan")
hist(ILPD$ALB, col="cyan")
hist(ILPD$AGRatio, col="cyan")
hist(ILPD$Selector, col="cyan")

plot(ILPD) # doesn't work because gender is not numeric
ILPD_noGender <- ILPD[-2] # remove gender because it isn't numeric
summary(ILPD_noGender) # see that gender is removed
plot(ILPD_noGender) # plot the new ILPD

ILPD$Gender <- as.numeric(ILPD$Gender == "Female") # ifelse(ILPD$Gender == "Female", "F", "M")
head(ILPD)
hist(ILPD$Gender, col="blue")
plot(ILPD, col="blue") # Works because gender is  numeric

# Write data out to disk
# Silly requirement by R.  Otherwise col.names are written out to file
names(ILPD) <- c();

# Write out numeric file;
# col.names = FALSE doesn't work in write.csv (bug?)
?write.csv
write.csv(ILPD, "C:/Users/Ernst/Desktop/ILPD.csv", row.names=F)

####################################

# Clean upworkspace
rm(list=ls())

# Remove Outliers:
v <- c(-1, 1, 5, 1,  1, 17, -3, 1, 1, 1, 3)
highLimit <- mean(v) + 2*sd(v)
goodFlag <- v < highLimit
v <- v[goodFlag]
v

# Relabel:
v <- c("BS", "MS", "PhD", "HS", "Bachelors", "Masters", "High School", "BS", "BS", "MS", "MS")
vRelabeled <- v
vRelabeled["Bachelors" == vRelabeled] <- "BS"
vRelabeled["Masters" == vRelabeled] <- "MS"
vRelabeled["High School" == vRelabeled] <- "HS"
vRelabeled

# Normalize normalizVector <- (vector - a) / b
v <- c(-1, 1, 5, 1,  1, 17, -3, 1, 1, 1, 3)
# Min-Max normalization:
vMinMax <- (v - min(v))/(max(v) - min(v))
vMinMax
# z-score normalization
v <- c(-1, 1, 5, 1,  1, 17, -3, 1, 1, 1, 3)
vZScore <- (v - mean(v))/sd(v)
vZScore

# Binarize:
Colors <- c("Red", "Green", "Blue", "Blue", "Blue", "Blue", "Blue", "Blue", "Red", "Green", "Blue")
Red <- Colors == "Red"
Green <- Colors == "Green"
Blue <- Colors == "Blue"
Red
Green
Blue
Red <- as.numeric(Red)
Green <- as.numeric(Green)
Blue <- as.numeric(Blue)
Red; Green; Blue

# Repeatable Code for Binarization:  Create a dataframe of vectors with binary values
MultiNomialVector <- Colors # Colors analogous <someDATFRAME$someVector>

namesOfColumns <- unique(MultiNomialVector)
numberOfColumns <- length(namesOfColumns)
numberOfRows <- length(MultiNomialVector)
BinarizedVector <- data.frame(matrix(nrow=numberOfRows, ncol=numberOfColumns))
names(BinarizedVector) <- namesOfColumns
for (columnName in namesOfColumns)
{
  BinarizedVector[,columnName] <- as.numeric(MultiNomialVector == columnName)
}
BinarizedVector
is(BinarizedVector)

?cbind
ColorsAndBinarized <- cbind(Colors, BinarizedVector)
ColorsAndBinarized

# Discretization
v <- c(3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 9, 12, 23, 23, 23, 25, 81)
numberOfBins <- 3
vMax <- max(v)
vMin <- min(v)
vRange <- vMax - vMin
binRange <- vRange / numberOfBins
bin1Min <- -Inf
bin1Max <- vMin + binRange
bin2Max <- bin1Max + binRange
bin3Max <- +Inf
bin1Min
bin1Max
bin2Max
bin3Max
discretizedV <- v
discretizedV[bin1Min < v & v <= bin1Max] <- "Low"
discretizedV[bin1Max < v & v <= bin2Max] <- "Med"
discretizedV[bin2Max < v & v  < bin3Max] <- "High"
discretizedV

v <- c(3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 9, 12, 23, 23, 23, 25, 81)
numberOfBins <- 3
binLimits <- seq(from=min(v), to=max(v), length.out=numberOfBins+1)
binMaxes <- binLimits[-1]
binMaxes[numberOfBins] <- +Inf
binNames <- paste("L", 1:numberOfBins, sep = "")
discretizedVector <- rep(NA, numberOfBins)
binMin <- -Inf
binNumber <- 0
for (binMax in binMaxes)
{
  binNumber <- binNumber + 1
  binName <- binNames[binNumber]
  discretizedVector[binMin < v & v <= binMax] <- binName
  binMin <- binMax
}
discretizedVector

# One way to do equal area dicretization
v <- c(3, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 9, 12, 23, 23, 23, 25, 81)
numberOfBins <- 3
vSorted <- sort(v)
binRange <- length(vSorted) / numberOfBins
bin1Min <- -Inf
bin1Max <- vSorted[round(binRange)]
bin2Max <- vSorted[round(2*binRange)]
bin3Max <- +Inf
discretizedV <- v
discretizedV[bin1Min < v & v <= bin1Max] <- "Low"
discretizedV[bin1Max < v & v <= bin2Max] <- "Med"
discretizedV[bin2Max < v & v <  bin3Max] <- "High"
discretizedV
