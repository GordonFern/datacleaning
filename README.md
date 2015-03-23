---
title: "Course Project Code Book"

---
#Study Design

This project seeks to summarize the Human Activity Recognition Using Smartphones Dataset provided by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. www.Smartlabs.ws

*"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details."  See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for more detail.*  

This project took the results of this data set and summarized them by grouping the results by:
- Subject
- Data Set (Train / Test)
- Measurement type (Walking, Walking upstairs, Waling Downstairs, Sitting, Standing, laying)
- normalized mean of the subject for this measurement type
- normalized standard deviation of the subject for this measurement type
##Source Raw Data
The source data can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The zip file consists of the following folder structure of interest

UCI HAR Dataset
- train
- test
'
Under the train folder there are 3 files of interest
- subject_train.txt
- X_train.txt a series of data items seperated by spaces.  There is whitespace at the begining and end of the line as well.  Seperation of data items is via one or more spaces
- Y_train.txt a code between 1..6 representing Walking, Walking upstairs, Waling Downstairs, Sitting, Standing, laying respectively.

Under the test folder there are 3 files of interest
- subject_train.txt
- X_train.txt a series of data items seperated by spaces.  There is whitespace at the begining and end of the line as well.  Seperation of data items is via one or more spaces
- Y_train.txt a code between 1..6 representing Walking, Walking upstairs, Waling Downstairs, Sitting, Standing, laying respectively.

###Acknowledgement & License
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


#Code Book  
| Name            | Meaning                                                                                                                       |
|---------------	|-----------------------------------------------------------------------------------------------------------------------------	|
| subject       	| The number of the test subject (1..30)                                                                                      	|
| result.set    	| The results set that the observation came from test/train                                                                   	|
| activity      	| walking / walking upstairs / walking downstairs / sitting / standing / laying                                               	|
| average       	| The mean of all accelerations for this subject and activity in units of g (gravity) normalized between -1..1                	|
| std.deviation 	| The standard deviation for all accelerations for this subject and activity in units of g (gravity) normalized between -1..1 	|  

#Summarization Design

The processing consists of:
- Downloading the zip file
- processing the train data
- processing the test data
- merging the train and test data
- writing the file and returning the data in a data frame dat.

The design consists of 3 functions located in the run_analysis.R file:
##downloadData(url, toFile,overwrite=False)
-- Parameters:  url     - the URL to download
--              toFile  - the name of the filename to download to
--              overwrite - if TRUE the file is downloaded even it already exists in the current working directory

This function simply downloads the data file to the current working directory

##processData(resultSet,zipFile)
-- Parameters:  resultSet - Either train or test
--              zipFile   - The zip file containing the raw data downloaded by downloadData

This function combines the subject_train or subject_test which contains a number between 1 and 30 with the train_Y or test_Y which is a number between 1 and 6 which is looked up in a vector containing Walking, Walking upstairs, Waling Downstairs, Sitting, Standing, laying and then mean and standard deviation for all results in in train_X or train_Y

##main()
controls the exercise and manages the reading and merging of both the train and test data sets