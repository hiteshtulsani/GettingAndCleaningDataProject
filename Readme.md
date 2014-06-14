Getting and Cleaning Data
========================================================
Course Project - Readme
--------------------------------------------------------

***
### Submitted by: Hitesh Tulsani
### Date:15th June 2014

***
#### The goal of this project is to combine Human Activity Recognition Test and Train datasets available at the Coursera(tm) project page ([Link to Zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)). 
***

The data is taken from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, data was captured for 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 

The experiments are carried out by Sport companies like FitBit, Nike etc. in a race to develop most advanced algorithms to attract new customers. More about wearable computing arena can be read [here](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/).

The descriptions of the feature variables can be read in the [Codebook](https://github.com/hiteshtulsani/GettingAndCleaningDataProject/blob/master/CodeBook.md). 

***

#### Working details of run_analysis.R script

* The script [run_analysis.R](http://insertlink.to.repo.com) starts by checking the existance of the project zip file and / or the "UCI HAR Dataset" folder in the current working directory. If the file is not found it is **downloaded** and *unzipped*: 


```{r}
        if (!file.exists("UCI HAR Dataset") & !file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
                fileURL <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileURL,destfile="getdata_projectfiles_UCI HAR Dataset.zip",method="curl")
                unzip("getdata_projectfiles_UCI HAR Dataset.zip")
        } else if (!file.exists("UCI HAR Dataset") & file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
                unzip("getdata_projectfiles_UCI HAR Dataset.zip")
        }
```

* Then, the required packages are checked for availability using require(). If the packages couldn't be loaded, they are downloaded:

```{r}
        if(!require(plyr)) { install.packages("plyr")}
        if(!require(reshape2)) {install.packages("reshape2")}
```

* Activity labels are read into activityLabels data.frame:

```{r}
        activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt",colClasses=c("integer","character"))
```
* Features are read in features and the names are standardized:

```{r}
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
        features$V2 <- gsub("\\(","",features$V2)
        features$V2 <- gsub("\\)","",features$V2)
        features$V2 <- gsub(",","",features$V2)
        features$V2 <- gsub("-","",features$V2)
```
* Training data sets are loaded next:

```{r}
        #Load X_train.txt file into x_train
        x_train<-read.table("UCI HAR Dataset/train/X_train.txt",colClasses="numeric")

        #Load y_train.txt file in y_train
        y_train<-read.table("UCI HAR Dataset/train/y_train.txt")

        #Load train subjects into subject_train
        subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",comment.char = "", colClasses="numeric")
```
* Test data sets are loaded next:

```{r}
        #Load X_test.txt file into x_test
        x_test<-read.table("UCI HAR Dataset/test/X_test.txt",colClasses="numeric")

        #Load y_test.txt file in y_test
        y_test<-read.table("UCI HAR Dataset/test/y_test.txt")

        #Load test subjects into subject_test
        subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt",comment.char = "", colClasses="numeric")
```

* Data sets are combined as follows:

```{r}
        #combine x_train and x_test, then rename the columns from features dataset read above 
        all_x <- rbind(x_train,x_test)
        names(all_x)<-features$V2

        #combine y_train and y_test into all_activities
        all_activities <- rbind(y_train,y_test)

        #combine subject_train and subject_test and name the column as "subject"
        all_subjects <- rbind(subject_train,subject_test)
        names(all_subjects) <- "subject"

        #join all_activites and activityLabels
        all_activities<-join(all_activities,activityLabels,by="V1")

        #merge all the data - all_x, all_subjects and all_activities$V2 (only the activity labels), rename all_activities$V2 column to "activity"
        all_data <- cbind(all_x,all_subjects,all_activities$V2,stringsAsFactors=F)
        names(all_data)[563]<-"activity"

        #get subset of all_data to summarize with subject (column 562), activity (column 563) and only standard deviation & mean columns (using grep)
        data_subset <- all_data[,c(grep(".*Mean.*", features$V2),grep(".*StandardDeviation.*", features$V2),562,563)]

```
* Data is summarized into summary_data and saved to a csv file "tidyData.csv":

```{r}
        #Melt the data with subject and activity as ID vars
        melted_data <- melt(data_subset,(id.vars=c("subject","activity")))
        
        #dcast the melted_data        
        summary_data <- dcast(melted_data, subject + activity ~ variable, mean)

        #write summary_data to tidyData.csv
        write.csv(summary_data,"tidyData.csv",row.names=F)
```

***
REFERENCES:
------------------------
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
***
