##set directory, download file

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
setwd("~/Documents/coursera/datasciencecoursera/Getting Data/Project")
download.file(fileURL, "./project.zip", method = "curl")

##unzip download
unzip("./project.zip")
filelist1 <- list.files("./UCI HAR Dataset/test")
filelist2 <- list.files("./UCI HAR Dataset/train")

##read in the data- split into activity, subject and features
activitytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
activitytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

featurestest <- read.table("./UCI HAR Dataset/test/x_test.txt")
featurestrain <- read.table("./UCI HAR Dataset/train/x_train.txt")

##combine data
dataactivity <-rbind(activitytest, activitytrain)
datasubject <- rbind(subjecttest, subjecttrain)
datafeatures <-rbind(featurestest, featurestrain)

##read in features names
names(dataactivity)<-c("activity")
datafeaturesnames <- read.table("./UCI HAR Dataset/features.txt")
names(datafeatures)<- datafeaturesnames$V2

##bind columns to include all data
datacombine <- cbind(datasubject, dataactivity)
data <- cbind(datafeatures, datacombine)


##subset data to include only Mean and Std data
subdataFeaturesNames<-datafeaturesnames$V2[grep("mean\\(\\)|std\\(\\)", datafeaturesnames$V2)]
selectednames <-c(as.character(subdataFeaturesNames), "subject", "activity")
data<-subset(data, select=selectednames)


##Change numbers of activity data to names of activity data
data$activity <- factor(data$activity,
                        levels = C(1, 2, 3, 4, 5, 6),
                        labels = c("Walking", "Walking Upstairs", "Walking Downstairs", "sitting", "Standing", "Laying"))


##create new column names to include expanded names
names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))


##create new data set with just mean, subject and activity
data2 <- aggregate(. ~subject + activity, data, mean)

##change new dataset to be ordered by subject, then by activity
data2<-data2[order(data2$subject,data2$activity),]

##write table to create new tidy data file
write.table(data2, file = "tidydata.txt",row.name=FALSE)

##check tidy data file 
data4 <- read.table("./tidydata.txt", header = TRUE) 
View(data4)
