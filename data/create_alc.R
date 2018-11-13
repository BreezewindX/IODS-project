# Janne Piiroinen
# 13.11.2018
# This is the R-code for RStudio Exercise 3


###############
## Parts 1-3 ##
###############

setwd("~/Documents/GitHub/IODS-project/")  # Set working directory to IODS project folder

student_mat <- read.csv("data/student-mat.csv")  # Read student-mat.csv

library(readr)
student_por <- read_delim("data/student-por.csv", 
                          ";", escape_double = FALSE, trim_ws = TRUE)
library(readr)
student_mat <- read_delim("data/student-mat.csv", 
                          ";", escape_double = FALSE, trim_ws = TRUE)


dim(student_por)  # Data student_por has 649 objects of 33 variables
str(student_por)  # Dataset includes attributes for Portuguese language students

dim(student_mat)  # Data student_por has 395 objects of 33 variables
str(student_mat)  # Dataset includes attributes for Math students

### We can conclude that the dataset of the math students has only approx. 0.61 times the observations
### of the Portuguese learners'

############
## Part 4 ##
############

# Joining the two datasets

library(dplyr)   #Loading dplyr

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

# Take a look at the data structure
dim(math_por)
summary(math_por)
# math_por has 382 objects and 53 variables (there are duplicates)

############
## Part 5 ##
############

# Using the datacamp code as it's good code.
# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(student_mat)[!student_mat %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


############
## Part 6 ##
############

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

############
## Part 7 ##
############

# glimpse at the new combined data
glimpse(alc)

# Everything is in order, write the CSV
write.csv(alc,"~/Documents/GitHub/IODS-project/data/alc.csv", row.names=FALSE)


######################
###     ANALYSIS   ###
######################


