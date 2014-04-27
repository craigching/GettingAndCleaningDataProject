library(reshape2)

## BEGIN Utility functions

# Creates a filename based on the base directory name,
# the dataset (train or test) and the type (X, y, subject)
makeDataSetFname <- function(directory, dataset, type) {
  paste(".", directory, dataset, paste(type, "_", dataset, ".txt", sep = ""), sep = "/")
}

# Loads a dataset (train or test) and combines the individual
# data frames into one dataset
loadDataSet <- function(directory, dataset) {

  # Download and unzip the data set if it hasn't yet been downloaded and unzipped
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if (!file.exists("./dataset.zip")) {
    download.file(url, destfile = "./dataset.zip", method = "curl")
    unzip("./dataset.zip")
  }

  # Read the specfified data set.  The dataset is spread
  # across three files, read them and combine into one
  X <- read.table(makeDataSetFname(directory, dataset, "X"))
  subject <- read.table(makeDataSetFname(directory, dataset, "subject"))
  y <- read.table(makeDataSetFname(directory, dataset, "y"))

  # Return the dataset, a combination of the data
  # from the X, subject, and y files
  cbind(y, subject, X)
}

# Load the features of the data into a data frame
loadFeatures <- function() {
  read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[, 2]
}

# Load the activity labels into a data frame
loadActivityLabels <- function() {
  read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
}

# Vectorize gsub, for use when making "nice" variable labels
vgsub <- function(pattern, replacement, x, ...) {
  for (i in 1:length(pattern)) {
    x <- gsub(pattern[i], replacement[i], x, ...)
  }
  x
}

## END Utility functions

## BEGIN Core functions

# Reads the train and test data, combining them into
# a single dataset returning the dataset
readTrainAndTestDataset <- function() {
  train <- loadDataSet("UCI HAR Dataset", "train")
  test <- loadDataSet("UCI HAR Dataset", "test")
  rbind(train, test)
}

# Returns a new dataset that contains only the
# variables that represent mean() or std() variables
# from the original dataset and the activity
# and subject variables
extractMeanAndStdMeasurements <- function(df) {

  # First, we need to associate the features with
  # the dataset (by assigning them to the column
  # names)
  features <- loadFeatures()
  colnames(df) <- c("activity", "subject", features)

  # Now grab only those columns that are explicitly either
  # mean() or std() variables
  df[, grep("subject|activity|-mean\\(|-std\\(", colnames(df))]

  # Alternatively we could include meanFreq(), but we are choosing not to
  # df[, grep("subject|activity|mean|std", colnames(df), ignore.case = TRUE)]
}

# Replace the numeric representation of the activities
# with more readable labels (from activity_labels.txt)
replaceActivities <- function(df) {
  activity_labels <- loadActivityLabels()
  df$activity <- factor(df$activity, levels = 1:6, labels = activity_labels$V2)
  df
}

# Make the variables more readable by replacing -mean() with Mean
# and -std() with StdDev.  The variables are already quite long
# so more is not done to make them more readable here.
labelVariables <- function(df) {
  colnames(df) <- vgsub(c("-mean\\(\\)", "-std\\(\\)"), c("Mean", "StdDev"), colnames(df))
  df
}

# First turn the dataset into a "long" dataset (using melt) and then
# use dcast to create a new dataset that contains the means of all
# the numeric variables for each subject and activity combination
createResultantData <- function(df) {
  tmp <- melt(df, id.vars = c("subject", "activity"))
  dcast(tmp, subject + activity ~ variable, mean)
}

## END Core functions

## Run analysis

df <- readTrainAndTestDataset()
df <- extractMeanAndStdMeasurements(df)
df <- replaceActivities(df)
df <- labelVariables(df)
df <- createResultantData(df)

## Write the dataset to a file for uploading

write.table(df, "data.txt", row.names = FALSE)

#View(df)
