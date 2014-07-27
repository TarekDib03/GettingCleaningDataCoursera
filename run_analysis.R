######################## Loading and Reading the Data Sets #############################
# Url where data are located
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Change working directory
setwd("GettingCleaningDataCoursera/Project")
# Download zip file
download.file(fileUrl, destfile="Data.zip", method="curl")
# Unzip the file
unzip("Data.zip")
# Rename file
file.rename("UCI HAR Dataset", "Data")
# Change working directory
setwd("Data")
############################### Merging Data Sets ####################################

# Read training and test sets
trainX <- read.table("train/X_train.txt")
testX <- read.table("test/X_test.txt")
trainY <- read.table("train/y_train.txt")
testY <- read.table("test/y_test.txt")
subjectTrn <- read.table("train/subject_train.txt")
subjectTest <- read.table("test/subject_test.txt")
subject <- rbind(subjectTrn, subjectTest)
colnames(subject) <- "Subject"

# row bind the training and test sets
X <- rbind(trainX, testX)
Y <- rbind(trainY, testY)

############################## Measurements and Manipulation ###########################
# Read features data set
features <- read.table("features.txt")
# Use grep function to extract only the mean and standard deviation of each of the measurements
mean_std_features <- grep("-mean\\(\\)|-std\\(\\)",features[,2])
# mean and standard deviation features
X <- X[,mean_std_features]
# Rename the columns of the X data frame to the names of features
names(X) <- features[mean_std_features, 2]

# Uses descriptive activity names to name the activities in the data set X
names(X) <- gsub("\\()","",names(X))

#################################### Activities #######################################
# Activity (1 to 6)
names(Y) <- "activity"

# Read the "activity_labels.txt" file
activity <- read.table("activity_labels.txt")

# Transfer underscores to dashes using gsub
activity[, 2] = gsub("_", "-", tolower(as.character(activity[, 2])))

# Replace the numbers with descriptive names
Y[,1] = activity[Y[,1],2]

##################################### Tidy Data ##########################################
# Merge subjects with activities and features
tidyData <- cbind(subject, Y, X)
# Average of each variable for each activity and each subject
tidyData2 <- aggregate(tidyData[,-c(1:2)], by=list(tidyData$Subject, tidyData$activity), 
                       mean)
# Change the names of the first 2 columns
colnames(tidyData2)[1:2] <- c("Subject.ID", "Activity")
write.table(tidyData2, "processedTidyDataSet.csv", row.names=F, sep=",")