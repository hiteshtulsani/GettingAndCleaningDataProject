Getting and Cleaning Data
========================================================
Course Project - Codebook
--------------------------------------------------------

***
### Submitted by: Hitesh Tulsani
### Date:15th June 2014

***
The given dataset contains 561 variables in X_train.txt and X_test.txt files. The description of the variables can be found in 'features_info.txt' after extracting the [zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Following lines describe various data frames / variables created within the script:

* The first interface with project data happens when the activity labels are read into **activityLabels**. 

After which, the feature variables are loaded to a data.frame and the labels are standardized using following points:

* Convert abbreviations to full words:
   
   Abbreviation | Converted to
   ----------------|-------------
        mean| Mean
        std|  StandardDeviation
        BodyBody|       Body
        \^t|     time
        \^f|     Frequency
        -X|     Xaxis
        -Y|     Yaxis
        -Z|     Zaxis
        Gyro|   Gyroscope
        Acc|    Accelerometer
        Mag|    Magnitude
* Remove junk characters () and -, ^ etc.
* Data frames created while loading training dataset: 
  * __X_train.txt__ is loaded into __x_train__ data.frame
  * __Y_train.txt__ is loaded into __y_train__ data.frame
  * __subject_train.txt__ is loaded into __subject_train__ data.frame
* Data frames created while loading test dataset: 
  * __X_test.txt__ is loaded into __x_test__ data.frame
  * __Y_test.txt__ is loaded into __y_test__ data.frame
  * __subject_test.txt__ is loaded into __subject_test__ data.frame 
* Data frames created while combining the test and training data.frames
  * __all_x__ contains data from x_train and x_test combined (rbind)
  * __all_activities__ contains data from y_train and y_test combined (rbind)
  * __all_subjects__ contains data from subject_train and subject_test combined (rbind)
  * __all_data__ contains data from __all_x__, __all_activites__ and __all_subjects__ (cbind)
* __data_subset__ data frame contains subset data from __all_data__ only having __activity__, __subject__,__StandardDeviation__ and __Mean__ columns
  * List of feature variables retained in the __data_subset__:

```{r}
         [1] "timeBodyAccelerometerMeanXaxis"                          
         [2] "timeBodyAccelerometerMeanYaxis"                          
         [3] "timeBodyAccelerometerMeanZaxis"                          
         [4] "timeGravityAccelerometerMeanXaxis"                       
         [5] "timeGravityAccelerometerMeanYaxis"                       
         [6] "timeGravityAccelerometerMeanZaxis"                       
         [7] "timeBodyAccelerometerJerkMeanXaxis"                      
         [8] "timeBodyAccelerometerJerkMeanYaxis"                      
         [9] "timeBodyAccelerometerJerkMeanZaxis"                      
        [10] "timeBodyGyroscopeMeanXaxis"                              
        [11] "timeBodyGyroscopeMeanYaxis"                              
        [12] "timeBodyGyroscopeMeanZaxis"                              
        [13] "timeBodyGyroscopeJerkMeanXaxis"                          
        [14] "timeBodyGyroscopeJerkMeanYaxis"                          
        [15] "timeBodyGyroscopeJerkMeanZaxis"                          
        [16] "timeBodyAccelerometerMagnitudeMean"                      
        [17] "timeGravityAccelerometerMagnitudeMean"                   
        [18] "timeBodyAccelerometerJerkMagnitudeMean"                  
        [19] "timeBodyGyroscopeMagnitudeMean"                          
        [20] "timeBodyGyroscopeJerkMagnitudeMean"                      
        [21] "FrequencyBodyAccelerometerMeanXaxis"                     
        [22] "FrequencyBodyAccelerometerMeanYaxis"                     
        [23] "FrequencyBodyAccelerometerMeanZaxis"                     
        [24] "FrequencyBodyAccelerometerJerkMeanXaxis"                 
        [25] "FrequencyBodyAccelerometerJerkMeanYaxis"                 
        [26] "FrequencyBodyAccelerometerJerkMeanZaxis"                 
        [27] "FrequencyBodyGyroscopeMeanXaxis"                         
        [28] "FrequencyBodyGyroscopeMeanYaxis"                         
        [29] "FrequencyBodyGyroscopeMeanZaxis"                         
        [30] "FrequencyBodyAccelerometerMagnitudeMean"                 
        [31] "FrequencyBodyAccelerometerJerkMagnitudeMean"             
        [32] "FrequencyBodyGyroscopeMagnitudeMean"                     
        [33] "FrequencyBodyGyroscopeJerkMagnitudeMean"                 
        [34] "angletBodyAccelerometerMeangravity"                      
        [35] "angletBodyAccelerometerJerkMeangravityMean"              
        [36] "angletBodyGyroscopeMeangravityMean"                      
        [37] "angletBodyGyroscopeJerkMeangravityMean"                  
        [38] "angleXgravityMean"                                       
        [39] "angleYgravityMean"                                       
        [40] "angleZgravityMean"                                       
        [41] "timeBodyAccelerometerStandardDeviationXaxis"             
        [42] "timeBodyAccelerometerStandardDeviationYaxis"             
        [43] "timeBodyAccelerometerStandardDeviationZaxis"             
        [44] "timeGravityAccelerometerStandardDeviationXaxis"          
        [45] "timeGravityAccelerometerStandardDeviationYaxis"          
        [46] "timeGravityAccelerometerStandardDeviationZaxis"          
        [47] "timeBodyAccelerometerJerkStandardDeviationXaxis"         
        [48] "timeBodyAccelerometerJerkStandardDeviationYaxis"         
        [49] "timeBodyAccelerometerJerkStandardDeviationZaxis"         
        [50] "timeBodyGyroscopeStandardDeviationXaxis"                 
        [51] "timeBodyGyroscopeStandardDeviationYaxis"                 
        [52] "timeBodyGyroscopeStandardDeviationZaxis"                 
        [53] "timeBodyGyroscopeJerkStandardDeviationXaxis"             
        [54] "timeBodyGyroscopeJerkStandardDeviationYaxis"             
        [55] "timeBodyGyroscopeJerkStandardDeviationZaxis"             
        [56] "timeBodyAccelerometerMagnitudeStandardDeviation"         
        [57] "timeGravityAccelerometerMagnitudeStandardDeviation"      
        [58] "timeBodyAccelerometerJerkMagnitudeStandardDeviation"     
        [59] "timeBodyGyroscopeMagnitudeStandardDeviation"             
        [60] "timeBodyGyroscopeJerkMagnitudeStandardDeviation"         
        [61] "FrequencyBodyAccelerometerStandardDeviationXaxis"        
        [62] "FrequencyBodyAccelerometerStandardDeviationYaxis"        
        [63] "FrequencyBodyAccelerometerStandardDeviationZaxis"        
        [64] "FrequencyBodyAccelerometerJerkStandardDeviationXaxis"    
        [65] "FrequencyBodyAccelerometerJerkStandardDeviationYaxis"    
        [66] "FrequencyBodyAccelerometerJerkStandardDeviationZaxis"    
        [67] "FrequencyBodyGyroscopeStandardDeviationXaxis"            
        [68] "FrequencyBodyGyroscopeStandardDeviationYaxis"            
        [69] "FrequencyBodyGyroscopeStandardDeviationZaxis"            
        [70] "FrequencyBodyAccelerometerMagnitudeStandardDeviation"    
        [71] "FrequencyBodyAccelerometerJerkMagnitudeStandardDeviation"
        [72] "FrequencyBodyGyroscopeMagnitudeStandardDeviation"        
        [73] "FrequencyBodyGyroscopeJerkMagnitudeStandardDeviation"    
        [74] "subject"                                                 
        [75] "activity" 
```
* __melted_data__ data frame contains data from __data_subset__ melted over __activity__ and __subject__ ID Variables
* __summary_data__ contains average of each variable for each activity and each subject
* Finally, __summary_data__ gets stored as a [__tidyData.csv__](https://github.com/hiteshtulsani/GettingAndCleaningDataProject/blob/master/tidyData.csv) file in the working directory