library(reshape2)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("./dataset.zip")) {
  download.file(url, destfile = "./dataset.zip", method = "curl")
  unzip("./dataset.zip")
}

# Read the train data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
train_df <- cbind(y_train, subject_train, X_train)

# Read the test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
test_df <- cbind(y_test, subject_test, X_test)

# Combine the train and test data into one data set
df <- rbind(train_df, test_df)

# Read the activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
features <- features[, 2]
colnames(df) <- c("y", "subject", features)
df$activity <- factor(df$y, levels = 1:6, labels = activity_labels$V2)

df2 <- df[, grep("subject|activity|-mean\\(|-std\\(", colnames(df))]
#df2 <- df[, grep("subject|activity|mean|std", colnames(df), ignore.case = TRUE)]

vgsub <- function(pattern, replacement, x, ...) {
  for (i in 1:length(pattern)) {
    x <- gsub(pattern[i], replacement[i], x, ...)
  }
  x
}

# Clean up the variable names
colnames(df2) <- vgsub(c("-mean\\(\\)", "-std\\(\\)"), c("Mean", "StdDev"), colnames(df2))

df3 <- melt(df2, id.vars = c("subject", "activity"))
df4 <- dcast(df3, subject + activity ~ variable, mean)

write.table(df4, "data.txt", row.names = FALSE)

#View(df4)