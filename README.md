# GettingDataProject
Course Project for Getting and Cleaning Data
---
title: "Getting and Cleaning Data Project"
author: "makerjessica"
date: "November 19, 2015"
output: html_document
---
#Assignment
You should create one R script called run_analysis.R that does the following. 
*Merges the training and the test sets to create one data set.
*Extracts only the measurements on the mean and standard deviation for each measurement. 
*Uses descriptive activity names to name the activities in the data set
*Appropriately labels the data set with descriptive variable names. 
*From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
---
#Step 1: Set Working Directory
setwd("~/Documents/coursera/datasciencecoursera/Getting Data/Project")

#Step 2: Get Data
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, "./project.zip", method = "curl")

#Step 3: Unzip Data
unzip("./project.zip")

#Step 4: Read in Data
filelist1 <- list.files("./UCI HAR Dataset/test")

filelist2 <- list.files("./UCI HAR Dataset/train")

activitytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
activitytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

featurestest <- read.table("./UCI HAR Dataset/test/x_test.txt")
featurestrain <- read.table("./UCI HAR Dataset/train/x_train.txt")

#Step 5: Merge Datasets

dataactivity <-rbind(activitytest, activitytrain)
datasubject <- rbind(subjecttest, subjecttrain)
datafeatures <-rbind(featurestest, featurestrain)

names(dataactivity)<-c("activity")
datafeaturesnames <- read.table("./UCI HAR Dataset/features.txt")
names(datafeatures)<- datafeaturesnames$V2


datacombine <- cbind(datasubject, dataactivity)
data <- cbind(datafeatures, datacombine)

#Step 6: Extract Mean and Standard Deviation
subdataFeaturesNames<-datafeaturesnames$V2[grep("mean\\(\\)|std\\(\\)", datafeaturesnames$V2)]
selectednames <-c(as.character(subdataFeaturesNames), "subject", "activity")
data<-subset(data, select=selectednames)

#Step 7: Name Activities
data$activity <- factor(data$activity,
                        levels = C(1, 2, 3, 4, 5, 6),
                        labels = c("Walking", "Walking Upstairs", "Walking Downstairs", "sitting", "Standing", "Laying"))
#Step 8: Label Desctiptive Variables
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

#Step 9: Create New Tidy Data Set

data2 <- aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

