# Janne Piiroinen
# 25.11.2018, 26.11.2018
# This is the R-code for RStudio Exercise 4 data wrangling part, 
# preparing the data for Exercise 5.
# We have continued working with this file on Exercise 5.

#########################
##  Reading the data   ##
#########################

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Meta file for the dataset
# http://hdr.undp.org/en/content/human-development-index-hdi
# Technical notes
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

######### 
# 3 

#Structure and dimensions of 'hd'
str(hd)
dim(hd)
summary(hd)

#Structure and dimensions of 'gii'
str(gii)
dim(gii)
summary(gii)

#########
# 4

#Checking variables in 'hd'
names(hd)
#Renaming the variables in 'hd'
names(hd) <- c("rank","country","hdi","lifeExp","expSchool","meanSchool","gni","gni-hdi")

#Renaming the variables in 'gii'
names(gii) <- c("rank","country","gii","mamo.ratio","adobirthrate","parlrep","edu2F","edu2M","labF","labM")

#########
# 5

#Mutate the “Gender inequality” data and create two new variables. 
#The first one should be the ratio of Female and Male populations 
#with secondary education in each country. (i.e. edu2F / edu2M). 
#The second new variable should be the ratio of labour force 
#participation of females and males in each country (i.e. labF / labM). 

gii <- gii %>% dplyr::mutate(
  pop.ratio = edu2F / edu2M,
  par.ratio = labF / labM
)

#########
# 6

#Join together the two datasets using the variable Country as 
#the identifier. Keep only the countries in both data sets 
#(Hint: inner join). 
#The joined data should have 195 observations and 19 variables. 
#Call the new joined data "human" and save it in your data folder. 

# common columns to use as identifiers
join_by <- c("country")

# join the two datasets by the selected identifiers
human <- inner_join(hd, gii, by = join_by, suffix = c(".hd", ".gii"))

# see that everything is ok
colnames(human)
summary(human)
head(human,10)
tail(human,10)
str(human)
dim(human)

#save the file
write.csv(human,"~/Documents/GitHub/IODS-project/data/human.csv", row.names=FALSE)

#check everything ok /w the file
library(readr)
View(read_csv("~/Documents/GitHub/IODS-project/data/human.csv"))

#End of exercise 4

###########################
## Data wrangling part   ##
##   of exercise 5       ##
###########################

#Mutate the data: transform the Gross National Income (GNI) 
#variable to numeric (Using string manipulation. 

read_csv("~/Documents/GitHub/IODS-project/data/human.csv")
human <- mutate(human, gni = as.numeric(gsub(",","",human$gni)))

#Exclude unneeded variables: keep only the columns matching 
#the following variable names (described in the meta file above):  
#"Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", 
#"GNI", "Mat.Mor", "Ado.Birth", "Parli.F"                                                                        
     
keep <- c("country", "edu2F", "labF", "lifeExp", "expSchool", "gni", "mamo.ratio", "adobirthrate", "parlrep")

# select the 'keep' columns
human <- select(human, one_of(keep))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human)==TRUE)
                                                                           
# look at the last 10 observations of human
tail(human_, 10)

# define the last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]

# add countries as rownames
rownames(human_) <- human_$country

#Check that the observations and variables match
str(human_)

#overwrite the old file... As the peer reviews are not in, I will try to
#remember to run this line later...
write.csv(human_,"~/Documents/GitHub/IODS-project/data/human.csv", row.names=TRUE)

#For now, I'll just overwrite the dataset in the memory
human <- human_



                                                                                
                                                                                