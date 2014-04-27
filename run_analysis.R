library(data.table)
library(reshape2)

## Load and merge training dataset columns
sub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x <- read.table("./UCI HAR Dataset/train/X_train.txt")
y <- read.table("./UCI HAR Dataset/train/y_train.txt")
training <- cbind(sub, x, y)

## Load and merge testing dataset columns
sub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x <- read.table("./UCI HAR Dataset/test/X_test.txt")
y <- read.table("./UCI HAR Dataset/test/y_test.txt")
testing <- cbind(sub, x, y)

## -> (1) Merges the training and the testing datasets to create one dataset
data <- rbind(training,testing)

## Load the names of the columns and rename the columns in the dataset
features <- read.table("./UCI HAR Dataset/features.txt",header=F,colClasses="character")
colnames(data) <- c('subject', as.character(features$V2), 'activityNr')

## Activity labels table
activ_lab <- read.table("activity_labels.txt")
colnames(activ_lab) <- c('activityNr', 'activity')

## Add the activity labels to data 
## -> (3) Uses descriptive activity names to name the activities in the data set
## -> (4) Appropriately labels the data set with descriptive activity names. 
data <- merge(activ_lab, data, all = TRUE)

## -> (2) Extract only the measurements on the mean and standard deviation for each measurement 
## i.e. in data extract stays activity, subject and columns w/ mean() or std() in their name
data_extract <- data[, c(2, 3, grep("-mean\\(\\)|-std\\(\\)", names(data)))]

## -> (5) Create a second, independent tidy data set with the average of each variable for each activity and each subject 
tidy_dataset <- melt(data_extract, id = c('activity', 'subject'))
tidy_dataset <- dcast(tidy_dataset, activity + subject ~ variable, mean)

## Save the tidy dataset
write.table(tidy_dataset, "tidy_dataset.txt", sep = ";", row.names = F)
