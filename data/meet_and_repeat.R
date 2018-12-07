# Janne Piiroinen
# 02.12.2018
# This is the R-code for RStudio Exercise 6 data wrangling

###########################
##  1 Reading the data   ##
###########################

setwd("~/Documents/GitHub/IODS-project/") 
BPRS <- read.csv("data/BPRS.txt", sep="")
RATS <- read.csv("data/rats.txt", sep="")

#check their variable names, view the data contents and structures,
#and create some brief summaries of the variables, so that you understand 
#the point of the wide form data.

names(BPRS)
str(BPRS)
head(BPRS)
summary(BPRS)

names(RATS)
str(RATS)
head(RATS)
summary(RATS)

#BPRS
#Column #1 identifies the treatment, column #2 identifies the subject, and
#the rest of the columns are the different observations taken in the test.
#We can see the amount of subjects and treatment groups from the summary.

#RATS
#The participants of the test are the rows in the data table and the columns
#are the observations. Column #1 is the ID number of the individual and
#column #2 tells which group the individual belongs into.

#############################
##  2 Convert to factors   ##
#############################

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Take a glimpse at the BPRSL data
glimpse(BPRS)
# Glimpse the data RATS
glimpse(RATS)

#The two first variables (the categorical ones) are now factored

# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

####################################
##  3 Convert to long form,       ##
##  add a week variable to BPRS   ##
##  and a time variable to RATS.  ##
####################################

# Convert BPRS to long form, add "week"
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Convert RATS data to long form, add "time"
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 

# Glimpse the data
glimpse(RATSL)

####################################
##  4 A serious look at the data  ##
####################################

names(BPRS)
names(BPRSL)

str(BPRS)
str(BPRSL)

head(BPRS)
head(BPRSL)

summary(BPRS)
summary(BPRSL)

#In long form all the values for BPRS are in one column, and the time for
#every observation is identified by another column named "week" which is
#column weeks in simple numerical form

#What is most notable, is that the data dimensions have changed a lot:
#In the original data there were 40 obs. of 11 variables. Now there are
#360 obs. of 5 variables! Same goes for RATS data.

names(RATS)
names(RATSL)

str(RATS)
str(RATSL)

head(RATS)
head(RATSL)

summary(RATS)
summary(RATSL)

#In RATS long form we also have all weight observations for every rat in
#one column, identified by the new column "Time". From the summary of the
#long form we can see nice summary for all values of "Weight", which we
#didn't have before converting. Also the "ID" summary now tells us the number
#of observations per ID number, and "Group" has all the group observations.

#We can conclude that in long vertical format, every row represents 
#an observation belonging to a particular category.

#Write data to a new file (this is required in order to load the data into
#Rmarkdown)

write.csv(BPRSL,"data/BPRSL.csv", row.names=FALSE)
write.csv(RATSL,"data/RATSL.csv", row.names=FALSE)
write.csv(BPRS,"data/BPRS.csv", row.names=FALSE)