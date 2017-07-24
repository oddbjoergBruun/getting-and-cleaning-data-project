
library(httr)
library(data.table)
library(plyr)
library(dplyr)

# Downloading and unzipping dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

## Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")


setwd("/Users/n636617/datasciencecoursera/UCI HAR Dataset")


# 1) Combine the train and test data sets
## read all necessary tables
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")


## create data set x
x_dat <- rbind(x_train, x_test)

## create data set y
y_dat <- rbind(y_train, y_test)

## create subject data set
subject_dat <- rbind(subject_train, subject_test)




# 2) Extracts only the measurements on the mean and standard deviation for each measurement

## select only columns with mean() or std() from features table
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

## subset columns
x_dat <- x_dat[, mean_std_features]

## correct the column names in data set x
names(x_dat) <- features[mean_std_features, 2]




# 3) Use descriptive activity names to name the activities in data set
activity_labels <- read.table("activity_labels.txt")

## update ids with corresponding activity names
y_dat[, 1] <- activity_labels[y_dat[, 1], 2]

## name column in data set
names(y_dat) <- "activity"




# 4) Appropriately label the dataset with descriptive variable names
# name column in subject data set
names(subject_dat) <- "subject"

## bind all the data in a single data set
all_dat <- cbind(x_dat, y_dat, subject_dat)



# 5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

## average of all columns, exept activity & subject
avg_dat <- ddply(all_dat, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(avg_dat, "avg_dat.txt", row.name=FALSE)













