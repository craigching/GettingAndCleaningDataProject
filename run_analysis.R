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

df3 <- melt(df2, id.vars = c("subject", "activity"))
df4 <- dcast(df3, subject + activity ~ variable, mean)
