# Janne Piiroinen
# 06.11.2018
# This is the R-code for RStudio Exercise 2

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14)  # Variable lrn14 has 183 objects of 60 variables
str(lrn14)  # Almost all variables are integers, only 'gender' is a factor with two levels "F" for female and "M" for male.

##########################################################
# Create an analysis dataset with the variables          #
# gender, age, attitude, deep, stra, surf and            #
# points by combining questions in the learning2014 data #
##########################################################

install.packages("dplyr") # install dplyr
library(dplyr)  # load dplyr 


# create column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude / 10

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

### Remove extra data from table
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

### Rename columns
colnames(learning2014)[2] <- "age"
# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

### Filter out the zero scores
learning2014 <- filter(learning2014, points > 0)

summary(learning2014)  # See that everything is fine.

########################################
### Set working directory and export ###
### CSV file                         ###
########################################

setwd("~/Documents/GitHub/IODS-project")  # Set working directory to IODS project folder

write.csv(learning2014,"~/Documents/GitHub/IODS-project/data/learning2014.csv", row.names=FALSE)
learning2014_test <- read.csv("data/learning2014.csv")  # Read the created CSV file
head(learning2014_test) # See if the data structure is the same
head(learning2014)
str(learning2014_test)
str(learning2014)
### OR
all.equal(learning2014,learning2014_test) # Test if the two data tables are the same

### Remove junk
rm(deep_columns, learning2014_test, strategic_columns, surface_columns, deep_questions, keep_columns, strategic_questions, surface_questions)

########################################
###  ANALYSIS PART                   ###
########################################

#Set working directory and read CSV file from GitHub
setwd("~/Documents/GitHub/IODS-project")
learning2014 <- read.csv("https://raw.githubusercontent.com/BreezewindX/IODS-project/master/data/learning2014.csv")

install.packages("broom") # install broom for later
install.packages("tidyverse")
library(broom)
library(tidyverse)
#Explore the data
summary(learning2014)

##################
### Draw plots

library(ggplot2)
learning2014 %>% ggplot(aes(x = attitude, y = points, col=gender)) +
geom_point() +
geom_smooth(method = "lm") +
ggtitle("Student's attitude versus exam points")

### Draw boxplot of the points by gender
### learning2014 %>% ggplot(aes(x = factor(gender), y = points, color = gender))  + geom_violin() + geom_boxplot() + xlab("Male = 1") + ggtitle("Male and female points")


### Draw ggpairs
install.packages("GGally")
library(GGally)
library(ggplot2)
ggpairs(learning2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))

# create a regression model with multiple explanatory variables
my_model <- lm(points ~ attitude + stra + surf, data = learning2014)
# print out a summary of the model
summary(my_model)

#Test if stra and surf are jointly zero

library(car)
ss_results<- linearHypothesis(my_model,  c("stra = 0", "surf = 0"))
print(ss_results)
round(ss_results$`Pr(>F)`[2], digits=3)

# draw diagnostic plots using the plot() function. Choose the plots 1, 2 and 5
par(mfrow = c(2,2))
plot(my_model, which=c(1,2,5))

new_model <- lm(points ~ attitude, data = learning2014)

# print out a summary of the model
summary(new_model)

### anova(new_model, my_model)

#Test for heteroscedasticity using Breusch-Pagan test, testin H_0 of no
#heteroscedasticity. We get p-value = 0.8156, cannot reject null hypothesis
#no evidence against homoscedasticity.
install.packages("lmtest")
library(lmtest)
new_model %>% 
  lmtest::bptest() -> bpresults
#Test for heteroscedasticity using the White-test
bptest(new_model, ~ attitude + I(attitude^2), data = learning2014)

#Test non-linear influence with RESET test
resettest(formula = points ~ attitude, power = 2, data = learning2014)
resettest(formula = points ~ attitude, power = 2:3, data = learning2014)
