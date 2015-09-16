# run_analysis.R script does the following:
# step 1: Merges the training and the test sets to create one data set.
# step 2: Extracts only the "mean" and "std" measurements for each measurement. 
# step 3: "join" with activity_labels to replace activity ids with descriptive activity names
# step 4: replace labels of the data set with descriptive variable names 
# step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

# reshape2 is needed to perform "melt" operation on data.frames
library(reshape2)

# step 1: read required csv files and and prepare a single training set

# features.csv is a file that contains the list fo all feature labels 
features <- read.table("./UCI HAR Dataset/features.txt")

# X_train.txt contains a training set
# 2nd column of features data frame contains labels for training set features
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(X_train) <- features[, 2]

# y_train.txt file contains activity ids for each measurement in training set
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- "activity_id"

# subject_train contains data for subjects (volunteers) who performed the experiment 
# each row correspond to the row in training set
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "subject_id"

# X_test.txt contains a training set
# 2nd column of features data frame contains labels for training set features
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(X_test) <- features[, 2]

# y_test.txt file contains activity ids for each measurement in training set
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- "activity_id"

# subject_test contains data for subjects (volunteers) who performed the experiment 
# each row correspond to the row in testing set
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "subject_id"

# activity labels data set 
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("activity_id", "activity_name")

# complete training and testing data sets consist of training set (X_train), activities performed (y_train) 
# and subjects who performed each experiment(subject_train)
# similarly test data set is created
train_ds <- cbind(X_train, y_train, subject_train)
test_ds <- cbind(X_test, y_test, subject_test)

# at the end of step 1 training and test datasets are combined into one dataset using rbind()
ds <- rbind(train_ds, test_ds)

# step 2: 
# keep only columns that contain mean and standard deviation
# in dataset names identify those which contain "-mean" and "-std" 
#(btw I was not sure if this is enough, but I guess adding/removing criteria is just a matter of adding/removing conditions, so it should be ok)
# keep also all columns containing "_id" - aka subject_id or activity_id
cols <- names(ds)
colsToExtract <- c(grep("_id", cols), grep("-mean", tolower(cols)), grep("-std", tolower(cols)))

# as a result dsReduced data frame is created
dsReduced <- ds[, colsToExtract]

# step 3:
# in this step new dataset is created in order to merge dsReduced dataset and activity lables - idea is to replace IDs with activity names
dsReducedWActivityName <- merge(activity_labels, dsReduced, by="activity_id", all=TRUE)

# remove activity_id column
dsReducedWActivityName <- dsReducedWActivityName[, !colnames(dsReducedWActivityName) == "activity_id"]

# Step 4:
# replace "technical" names with "non-technical" names
tempNames <- names(dsReducedWActivityName)

tempNames <- gsub("-mean", "Mean", tempNames)
tempNames <- gsub("-std", "Std", tempNames)
tempNames <- gsub("[()]", "", tempNames)
tempNames <- gsub("[-]", "", tempNames)
tempNames <- gsub("[_]", "", tempNames)
tempNames <- gsub("^t", "time", tempNames)
tempNames <- gsub("^f", "frequency", tempNames)

colnames(dsReducedWActivityName) <- tempNames

# Step 5:
# use melt to create tidy data set - one variable per row
dsFinal <- melt(dsReducedWActivityName, id=c("activityname", "subjectid"))

# calculate mean for each variable and create dataset with means on every variable by activity and subject name
dsFinalMean <- dcast(dsFinal, activityname + subjectid ~ variable, mean)

write.table(dsFinalMean, "./tidydata.txt", append=FALSE)
