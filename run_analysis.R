library(reshape2)

makeDataSetFname <- function(directory, dataset, type) {
  paste(".", directory, dataset, paste(type, "_", dataset, ".txt", sep = ""), sep = "/")
}

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

loadFeatures <- function() {
  read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[, 2]
}

loadActivityLabels <- function() {
  read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
}

readTrainAndTestDataset <- function() {
  train <- loadDataSet("UCI HAR Dataset", "train")
  test <- loadDataSet("UCI HAR Dataset", "test")
  rbind(train, test)
}

extractMeanAndStdMeasurements <- function(df) {

  # First, we need to associate the features with
  # the dataset (by assigning them to the column
  # names)
  features <- loadFeatures()
  colnames(df) <- c("activity_numeric", "subject", features)

  # Now grab only those columns that are explicitly either
  # mean() or std() variables
  df[, grep("subject|activity_numeric|-mean\\(|-std\\(", colnames(df))]

  # Alternatively we could include meanFreq(), but we are choosing not to
  # df[, grep("subject|activity|mean|std", colnames(df), ignore.case = TRUE)]
}

replaceActivities <- function(df) {
  activity_labels <- loadActivityLabels()
  df$activity <- factor(df$activity_numeric, levels = 1:6, labels = activity_labels$V2)
  df
}

# Vectorize gsub, for use when making "nice" variable labels
vgsub <- function(pattern, replacement, x, ...) {
  for (i in 1:length(pattern)) {
    x <- gsub(pattern[i], replacement[i], x, ...)
  }
  x
}

labelVariables <- function(df) {
  colnames(df) <- vgsub(c("-mean\\(\\)", "-std\\(\\)"), c("Mean", "StdDev"), colnames(df))
  df
}

createResultantData <- function(df) {
  tmp <- melt(df, id.vars = c("subject", "activity"))
  dcast(tmp, subject + activity ~ variable, mean)
}

df <- readTrainAndTestDataset()
df <- extractMeanAndStdMeasurements(df)
df <- replaceActivities(df)
df <- labelVariables(df)
df <- createResultantData(df)

write.table(df, "data.txt", row.names = FALSE)

#View(df4)
