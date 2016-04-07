filesPath <- "C:\\Users\\msunkpal\\Desktop\\R_Final\\UCI HAR Dataset"

# packages loaded are: dplyr and tidyr

#Reading trainings files
trainX <- read.table(file.path(filesPath, "train","X_train.txt"))
XtrainData <- tbl_df(trainX)
trainy <- read.table(file.path(filesPath, "train","y_train.txt"))
ytrainData <- tbl_df(trainy)
trainD <- read.table(file.path(filesPath, "train", "subject_train.txt"))
SubjectTrainD <- tbl_df(trainD)

#Reading testing files
testX <- read.table(file.path(filesPath,"test", "X_test.txt"))
XtestData <- tbl_df(testX)
testy <- read.table(file.path(filesPath,"test", "y_test.txt"))
ytestData <- tbl_df(testy)
testD <- read.table(file.path(filesPath, "test" , "subject_test.txt" ))
SubjectTestD  <- tbl_df(testD)

# Read activity files
activity <- read.table(file.path(filesPath, "activity_labels.txt"))
activityData <- tbl_df(activity)

# Read feature files
feature <- read.table(file.path(filesPath, "features.txt"))

# 1. Merges the training and the test sets to create one data set

# Assigning column names:

colnames(XtrainData) <- feature[,2] 
colnames(ytrainData) <-"activity"
colnames(SubjectTrainD) <- "subject"

colnames(XtestData) <- feature[,2] 
colnames(ytestData) <- "activity"
colnames(SubjectTestD) <- "subject"

colnames(activityData) <- c("activity","activityNum")

# Merge all data into a single dataframe
trainMerge <- cbind(ytrainData, SubjectTrainD, XtrainData)
testMerge <- cbind(ytestData, SubjectTestD, XtestData)
mergeAll <- rbind(trainMerge,testMerge)

# 2. Extract measurements on the mean and standard deviation for each measurement

# Reading column names
Names <- colnames(mergeAll)

# Create vector for defining ID, mean and standard deviation:
mean_std <- (grepl("activity" , Names) | grepl("subject" , Names) |  grepl("mean.." , Names) |  grepl("std.." , Names))

# Making nessesary subset from setAllInOne:
subset_Mean_Std <- mergeAll[ , mean_std == TRUE]

# 3. Use descriptive activity names to name the activities in the data set
activityNames <- merge(subset_Mean_Std, activityData , by = "activity", all.x = TRUE)

# 4. Appropriately labels the data set with descriptive variable names.
   # step is complete from parts of step 1, 2, and 3. this can be verified by the following commands

head(str(activityNames),4)

# 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

tidydataset <- aggregate(. ~subject + activity, activityNames, mean)
tidydataset <- tidydataset[order(tidydataset$subject, tidydataset$activity),]

write.table(tidydataset, "tidyData.txt", row.name=FALSE)
