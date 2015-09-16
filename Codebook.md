Codebook
========

This codebook describes datasets created with run_analysis.R script and transformations applied.

## Datasets

### Generated datasets

#### Dataset: dsReducedWActivityName

Dataset dsReducedWActivityName contains 81 columns:

The first column in dataset activityname contains information about activity performed. This column has 6 different values:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

The second column in dataset is subjectid. There are 30 subjects with unique Subject Ids (values 1-30) who performed the experiment.

Columns 3- 81 contain measurements that were reduced from 561 measurments in original dataset. dsReducedWActivityName dataset contains Mean and Standard deviation measurements only. Remark: X(YZ) represents 3 different measurements - 3-axial signals in the X, Y and Z directions:

* timeBodyAccMeanX(YZ)
* timeGravityAccMeanX(YZ)
* timeBodyAccJerkMeanX(YZ)
* timeBodyGyroMeanX(YZ)
* timeBodyGyroJerkMeanX(YZ)
* timeGravityAccMagMean
* timeBodyAccJerkMagMean
* timeBodyGyroMagMean
* timeBodyGyroJerkMagMean
* frequencyBodyAccMeanX(YZ)
* frequencyBodyAccMeanFreqX(YZ)
* frequencyBodyAccJerkMeanX(YZ)
* frequencyBodyAccJerkMeanFreqX(YZ)
* frequencyBodyGyroMeanX(YZ)
* frequencyBodyGyroMeanFreqX(YZ)
* frequencyBodyAccMagMean
* frequencyBodyAccMagMeanFreq
* frequencyBodyBodyAccJerkMagMean
* frequencyBodyBodyAccJerkMagMeanFreq
* frequencyBodyBodyGyroMagMean
* frequencyBodyBodyGyroMagMeanFreq
* frequencyBodyBodyGyroJerkMagMean
* frequencyBodyBodyGyroJerkMagMeanFreq
* timeBodyAccStdX(YZ)
* timeGravityAccStdX(YZ)
* timeBodyAccJerkStdX(YZ)
* timeBodyGyroStdX(YZ)
* timeBodyGyroJerkStdX(YZ)
* timeBodyAccMagStd
* timeGravityAccMagStd  
* timeBodyAccJerkMagStd 
* timeBodyGyroMagStd 
* timeBodyGyroJerkMagStd 
* frequencyBodyAccStdX 
* frequencyBodyAccJerkStdX(YZ)
* frequencyBodyGyroStdX(YZ)
* frequencyBodyAccMagStd 
* frequencyBodyBodyAccJerkMagStd
* frequencyBodyBodyGyroMagStd
* frequencyBodyBodyGyroJerkMagStd 

#### Dataset: dsFinalMean

Dataset dsFinalMean contains observations from dsReducedWActivityName dataset grouped by subjectid and activityname aggregated using mean for each measurement.

Dataset contains 180 rows (6 activity names x 30 subject id). 

### Original datasets

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

## Transformations

run_analysis.R script has 5 steps:

* step 1: Merges the training and the test sets to create one data set.
* step 2: Extracts only the "mean" and "std" measurements for each measurement. 
* step 3: "join" with activity_labels to replace activity ids with descriptive activity names
* step 4: replace labels of the data set with descriptive variable names 
* step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject


### Step 1

In Step 1, all required csv/txt files are read into corresponding data frames:
* features.csv is a file that contains the list fo all feature labels 
* X_train.txt contains a training set, 2nd column of features data frame contains labels for training set features
* y_train.txt file contains activity ids for each measurement in training set
* subject_train contains data for subjects (volunteers) who performed the experiment each row correspond to the row in training set
* X_test.txt contains a training set, 2nd column of features data frame contains labels for training set features
* y_test.txt file contains activity ids for each measurement in training set
* subject_test contains data for subjects (volunteers) who performed the experiment each row correspond to the row in testing set
# activity_labels data set contains labels for activities

After, data files are read into corresponding data frames, test and train datasets are combined using cbind (X_train, y_train and subject_train; X_test, y_test, subject_test) into two data sets train_ds and test_ds.

In the next step complete train/test data set ds is created using rbind.

### Step 2

From dataset ds, all columns that are not "mean" and "standard deviation" are excluded. Of course "activity id" and "subject id" are also kept in data frame.

As a result dsReduced data frame is created.

### Step 3

In this step new dataset dsReducedWActivityName is created in order to merge dsReduced dataset and activity lables. 

In dsReducedWActivityName, there are two columns now (activity name, activity id, from which one is redundant. That's why "activity id" is removed.

### Step 4

In step 4, "technical" column names are replaced with "non-technical" ones. 

gsub is used to replace characters/string of characters in column names.

### Step 5

In step 5 melt function is used to create a new tidy data set dsFinal. dsFinal contains two id column pairs - activityname and subjectid, with only one variable/value pair.

For example:
  activityname subjectid         variable     value
1      WALKING        28 timeBodyAccMeanX 0.3079548
2      WALKING        28 timeBodyAccMeanX 0.1683027
3      WALKING        28 timeBodyAccMeanX 0.3430729
4      WALKING        28 timeBodyAccMeanX 0.3099743
5      WALKING        28 timeBodyAccMeanX 0.1695621
6      WALKING        28 timeBodyAccMeanX 0.3361759

Final step in the script is to use dcast function to create a new data set that contains calculated mean for each variable by activity and subject name.

New data frame dsFinalMean is written as a final tidy data - tidydata.txt to disk.
