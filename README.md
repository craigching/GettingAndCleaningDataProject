# Overview
This is a repository containing the solution for the peer assessment project for the Coursera course "Getting and Cleaning Data."  Included in this repository is:

1. This README.md that describes the contents of the repsository
2. An R script called "run_analysis.R" that implements the data analysis required by the project.
3. A code book called "CodeBook.md" describing the tidy dataset
4. A file called "data.txt" that contains the tidy dataset

The project asked us to analyze a dataset that includes accelerometer data collected from a Galaxy S smartphone while subjects performed various activities.  The dataset itself is a machine learning dataset that contains test and train data.  We are to take the get the data, work with it and clean it by submitting a dataset that shows the means of a subset of the data by subject and activity.

# run_analysis.R
This script was developed for maximum readability to ease the work a peer must do to assess it.  Because of this it is a bit longer than a more succinct or modular program.  The script is broken up into three main parts:

## Utility functions

These are intended to ease the implementation and readability of the core functions mentioned next.

## Core functions

These implement the main logic for the analysis.  They are modeled after the requirements of the project:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## The analysis

Run the Core functions to produce the tidy dataset.

## The tidy dataset

The tidy dataset is included in data.txt and has also been uploaded using the course project web page.  The tidy dataset includes 180 rows of 86 variables.  The variables themselves have been made more readable by simply replacing the '-mean()' and '-std()' with 'Mean' and 'StdDev' respectively.  Depending on the peer assessing the dataset it may or may not be considered tidy, but the requirements were not specific and I felt that the names were already pretty long and chose not to make them longer.  It is also important, when looking at the variable names, to realize that each value is itself a mean according to the requirements of the project.  That fact is not reflected in the variable names.

# Notes and assumptions

The analysis was done on a MacBook Pro with the following uname output:

> $ uname -mrsv
> Darwin 13.1.0 Darwin Kernel Version 13.1.0: Thu Jan 16 19:40:37 PST 2014; root:xnu-2422.90.20~2/RELEASE_X86_64 x86_64

An assumption was made that when the project said "Extracts only the measurements on the mean and standard deviation for each measurement" that we only kept the mean() and std() data values.  There were other values that could possibly be interpreted by mean() (for instance, meanFreq), but these were not included.  Only those variables that had literally "-mean()" and "-std()" in the names were used.