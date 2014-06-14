#Check for the files / folder in the current working directory
#1. Check if both file and folder doesn't exists, download the file and unzip it
#2. If only folder doesn't exist, but the zip file exists, just unzip the file

if (!file.exists("UCI HAR Dataset") & !file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
        fileURL <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL,destfile="getdata_projectfiles_UCI HAR Dataset.zip",method="curl")
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")
} else if (!file.exists("UCI HAR Dataset") & file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}

##Check for plyr and reshape2 packages, if not available, install
if(!require(plyr)) { install.packages("plyr")}
if(!require(reshape2)) {install.packages("reshape2")}

##read activity labels
       activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt",colClasses=c("integer","character"))

##Read features and standardize names
        features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=F)
        features$V2 <- gsub("BodyBody", "Body", features$V2)
        features$V2 <- gsub("-mean\\(\\)", "Mean", features$V2)
        features$V2 <- gsub("-std\\(\\)", "StandardDeviation", features$V2)
        features$V2 <- gsub("^t", "time", features$V2)
        features$V2 <- gsub("^f", "Frequency", features$V2)
        features$V2 <- gsub("-X", "Xaxis", features$V2)
        features$V2 <- gsub("-Y", "Yaxis", features$V2)
        features$V2 <- gsub("-Z", "Zaxis", features$V2)
        features$V2 <- gsub("Gyro", "Gyroscope", features$V2)
        features$V2 <- gsub("Acc", "Accelerometer", features$V2)
        features$V2 <- gsub("Mag", "Magnitude", features$V2)


#Load X_train.txt file into x_train
       x_train<-read.table("UCI HAR Dataset/train/X_train.txt",colClasses="numeric")

#Load y_train.txt file in y_train
       y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

#Load train subjects into subject_train
       subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",comment.char = "", colClasses="numeric")

#Load X_test.txt file into x_test
        x_test<-read.table("UCI HAR Dataset/test/X_test.txt",colClasses="numeric")

#Load y_test.txt file in y_test
        y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

#Load test subjects into subject_test
        subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",comment.char = "", colClasses="numeric")


#combine x_train and x_test, then rename the columns from features read above 
        all_x <- rbind(x_train,x_test)
        names(all_x)<-features$V2

#combine y_train and y_test
        all_activities <- rbind(y_train,y_test)

#combine subject_train and subject_test and name the column as subject
        all_subjects <- rbind(subject_train,subject_test)
        names(all_subjects) <- "subject"

#join all_activites and activityLabels into activites_with_labels
        all_activities<-join(all_activities,activityLabels,by="V1")

#merge all the data - all_x, all_subjects and all_activities$V2 (only the activity labels), rename all_activities$V2 column to activity
        all_data <- cbind(all_x,all_subjects,all_activities$V2,stringsAsFactors=F)
        
        names(all_data)[563]<-"activity"

#get subset of all_data with subject(column 562), activity (column 563) and only standard deviation & mean columns (using grep)
        data_subset <- all_data[,c(grep(".*Mean.*", features$V2),grep(".*StandardDeviation.*", features$V2),562,563)]


#Create tidy dataset
melted_data <- melt(data_subset,(id.vars=c("subject","activity")))
summary_data <- dcast(melted_data, subject + activity ~ variable, mean)
write.csv(summary_data,"tidyData.csv",row.names=F)
