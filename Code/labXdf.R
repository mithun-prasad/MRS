library(RevoTreeView)

filename <- "irisDataset.csv"
irisDataset <- read.csv(filename)
head(irisDataset)

# Return a data frame
irisDF = rxImport(filename)

# Generate a useful summary of whats in the data frame
rxGetInfo(irisDF, getVarInfo = TRUE)
names(irisDF)

# Returns a data source object
irisDS = rxImport(filename, "iris.xdf", overwrite = TRUE)
rxGetInfo(irisDS, getVarInfo = TRUE)
names(irisDS)

####################################################################
#                       BASIC GRAPHING                             #
#                                                                  # 
####################################################################

# Histogram Analysis
rxHistogram( ~ sepallength, data = irisDS, title = "Sepal Length Frequency")

# To plot Histogram on Categorical Variables
factoredDS = rxFactors(irisDS, factorInfo = c("class"))
rxHistogram( ~ class, data = factoredDS, title = "Class Histogram")

# 2D plot of Sepallength vs Petallength
rxLinePlot(sepallength ~ petallength, data = irisDS, xTitle = 'Petal Length', yTitle = 'Sepal Length', title = 'Sepal Length vs Petal Length')

# ROC Plots
sampleDF <- data.frame(actual = c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1),
    badPred = c(.99, .99, .99, .99, .99, .01, .01, .01, .01, .01),
    goodPred = c(.01, .01, .01, .01, .01, .99, .99, .99, .99, .99))

rxRocCurve(actualVarName = "actual", predVarNames = "badPred", data = sampleDF, numBreaks = 10, title = "ROC for Bad Predictions")
rxRocCurve(actualVarName = "actual", predVarNames = "goodPred", data = sampleDF, numBreaks = 10, title = "ROC for Great Predictions")

####################################################################
#                       DATA SCIENCE                               #
#                                                                  # 
####################################################################
##########             SUPERVISED LEARNING                    ######
irisTree = rxDTree(formula = class ~ sepallength + sepalwidth + petallength + petalwidth, data = factoredDS)
plot(createTreeView(irisTree))

# Split Dataset into Train / Test

splitFiles <- rxSplit(inData = factoredDS,
    outFilesBase = "irisSplitData",
    splitByFactor = "splitVar", overwrite = TRUE,
    transforms = list(splitVar = factor(
        sample(0:1, size = .rxNumRows, replace = TRUE, prob = c(0.1, 0.9)),
        levels = 0:1, labels = c("Test", "Train"))))
names(splitFiles)

trainIrisXdf = RxXdfData(splitFiles[[2]])
irisModel = rxDTree(formula = class ~ sepallength + sepalwidth + petallength + petalwidth, data = trainIrisXdf)
rxPredict(irisModel, RxXdfData(splitFiles[[1]]), outData = "out.xdf", writeModelVars = TRUE)

predDF = RxXdfData("out.xdf")
names(predDF) = c("setosa_prob", "verisicolr_prob", "virginica_prob", "class", "sepallength", "sepalwidth", "petallength", "petalwidth")

####################################################################
#######              UNSUPERVISED LEARNING                    ######
####################################################################
kclustsIris <- rxKmeans(formula = ~sepallength + sepalwidth + petallength + petalwidth,
    data = irisDataset,
    seed = 10, numClusters = 5)

kclustsIris

