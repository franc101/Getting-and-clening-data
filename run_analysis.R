setwd("~/Algorithms/Data Science Specialization/03 - Getting and Cleaning data/Week 3/UCI HAR Dataset")

# 1. Merges the training and the test sets to create one data set.
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
train_data <- cbind(X_train, y_train, subject_train)

X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
test_data <- cbind(X_test, y_test, subject_test)

data <- rbind(train_data, test_data)

# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
features <- read.table("features.txt")
# I use grep function (from the 4th week) to select the measurements
measurements <- grep("(mean|std)[(][)]", features$V2)
data <- data[c(measurements, 562, 563)]

# 3. Uses descriptive activity names to name the activities in the data set.
activity_labels <- read.table("activity_labels.txt")
# 67 is the activity column index
for(i in 1:nrow(activity_labels)){
        data[data[67]==i, 67] <- as.character(activity_labels[i, 2])
}


# 4. Appropriately labels the data set with descriptive variable names. 
# features (X_) columns
names(data)[-c(67, 68)] <- as.character(features[measurements, 2])

# Activity column
names(data)[67] <- "activity"

# Subject column
names(data)[68] <- "subject"


# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)
average_data <- aggregate(data, by=list(activity=data$activity, subject=data$subject), mean)
# remove activity and subject columns
average_data[70] <- NULL
average_data[69] <- NULL

write.table(average_data, "data.txt", row.name=FALSE)
