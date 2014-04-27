# Introduction

The resultant dataset is a derivation of the UCI "Human Activity Recognition Using Smartphones" dataset available from the UCI machine learning repository.  The link to the original dataset is:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A description of this dataset is available at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The original dataset is intended to be used with a machine learning algorithm to determine the activity (WALKING, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) from various acceleerometer data points read from a Samsung Galaxy S II smartphone worn by the subject.

The resultant dataset is a dataset that contains the mean of all mean and standard deviation variables from the original dataset by subject and activity.  It contains 180 rows and 68 columns, data from 30 subjects over the 6 activities.

It is important to note that only variables that explicitly contain the "-mean()" and "-std()" strings were considered for this analysis.  There are other "mean" variables (e.g. -meanFreq()) that were not considered as it was deemed not in the spirit of the requirements.  The analysis could easily be changed to include any other variables should the need arise.

# Procedure

To generate the resulant dataset, the R function run_analysis.R was used.  The general procedure that was followed was:

1. Download the original dataset from the UCI machine learning repository
2. Combine the test and train datasets into one dataset
3. Extract only the mean() and std() variables to be used for the analysis
4. Clean up the activities by replacing the numeric activities (1-6) with the more readable labels (WALKING, etc.)
5. Clean up the variable names on the resultant dataset
6. Create the resultant dataset by melting the data so that each observation has its own row and then dcasting the molten dataset into a tidy dataset that has the mean of each variable by subject and activity

# Variables

Since there are 68 variables and they are all basically combinations of simpler information, an exhaustive description of each variable will not be given.  It is easy enough with some simple rules to derive the meaning of each variable, so those rules are documented instead.  Also note that all measured values in the resultant dataset are means of the original data values.  This is not reflected in the variable names since it is a uniform feature of the data.

There are two variables that are the exception to the rule, so they are described here

* subject

Subject is an identifier that identifies the subject performing the activies.  It is a simple numeric (integer) value unqiue to the subject.

* activity

Activity is one of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING.  It is the activity that was performed during the original accelerometer measurements.

The rest of the variables follow these simple rules:

* 't' or 'f' prefix

If the variable is prefixed with a 't', then that variable is a time domain signal captured at a constant rate of 50 Hz.  If the variable name is prefixed with an 'f', then that variable has had a fast fourier transform applied to it and represents a frequency.

* The variable is one of the following:

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

each representing an accelerometer measurement.  Note that each of the -XYZ represent a vector measurement and that data has been broken out into their constituent parts in the original and resultant datasets (i.e. seperate X, Y, Z variables).

* A summary

The resultant dataset only contains "-mean()" and "-std()" measurements representing the mean and standard deviation for the measurements.  These have been converted to "Mean" and "StdDev" in the variable names of the resultant dataset.

# Values

As mentioned, each value in the resultant dataset represents a mean of the measured value.  So, for instance, "tBodyAccMean-X" is the mean value for all measurements of "tBodyAccMean-X" (measurement of body acceleration in the X direction) for the subject in each activity (the mean of the mean), and "tBodyAccStdDev-X" is the mean value for all measurements of "tBodyAccStdDev-X" for the subject in each activity (the mean of the standard deviation).