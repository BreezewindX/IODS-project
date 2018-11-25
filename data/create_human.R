# Janne Piiroinen
# 25.11.2018
# This is the R-code for RStudio Exercise 4 data wrangling part, 
# preparing the data for Exercise 5.

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

#Thank you for visiting! ;)
