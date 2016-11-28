####################################################################
#                           DPLYR Lab                              #
#                                                                  # 
####################################################################
### Install the following packages into a directory that is writable
library("lazyeval", lib.loc = "C:/Rlibraries")
library("downloader", lib.loc = "C:/Rlibraries")
library("dplyr", lib.loc = "C:/Rlibraries")


### 1. Download the Iris Dataset from the git account and view the content ###
url <- "https://raw.githubusercontent.com/mithun-prasad/azure-ml/master/Data/irisDataset.csv"
filename <- "irisDataset.csv"
if (!file.exists(filename)) download(url, filename)

irisDataset <- read.csv(filename)
head(irisDataset)

### 2. Filter the dataset to view only sepallength and sepalwidth ###
irisDataSepal <- select(irisDataset, sepallength, sepalwidth)
head(irisDataSepal)

### 3. Exclude a column (sepallength) ###
head(select(irisDataset, - sepallength))

### 4. Select columns starting with the letter P ###
head(select(irisDataset, starts_with("p")))

### ************* ADDITIONAL OPTIONS ************* ###
### Some additional options to select columns based on a specific criteria include
### ends_with() = Select columns that end with a character string
### contains() = Select columns that contain a character string
### matches() = Select columns that match a regular expression
### one_of() = Select columns names that are from a group of names

### 5. Filter on Rows ###
filter(irisDataset, class == 'Iris-setosa')

### 6. Add new variables ###
### Add a variable that divides sepallength by petallength ###
mutate(irisDataset, lengthRatio = sepallength/petallength)

### 7. Summarize ###
summarise(irisDataset, mean(sepallength, na.rm = TRUE))

### 8. Group By ###
summarise(group_by(irisDataset, class), mean(sepallength))

### 9. Sample By row count/percentage ###
sample_n(irisDataset, size = 10)
sample_frac(irisDataset, size = 0.1)

### 10. Arrange Function ###
arrange(irisDataset, desc(class), sepallength)

### 11. Pipe operator: %>%
irisDataset %>%
    select(sepallength) %>%
head