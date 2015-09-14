# 1. step: 
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

# X_train.txt contains a training set
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

# Step 2:
# keep only columns that contain mean and standard deviation
# in dataset names identify those which contain "-mean" and "-std" 
#(btw I was not sure if this is enough, but I guess adding/removing criteria is just a matter of adding/removing conditions, so it should be ok)
# keep all columns containing "_id" - aka subject_id or activity_id
cols <- names(ds)
colsToExtract <- c(grep("_id", cols), grep("-mean", tolower(cols)), grep("-std", tolower(cols)))

# as a result dsReduced data frame is created
dsReduced <- ds[, colsToExtract]

# Step 3:
# in this step new dataset is created in order to merge dsReduced dataset and activity lables - idea is to replace IDs with activity names
dsReducedWActivityName <- merge(dsReduced, activity_labels, by="activity_id", all.x=TRUE)

# remove activity_id column
dsReducedWActivityName <- dsReducedWActivityName[, !colnames(dsReducedWActivityName) == "activity_id"]

# Step 4:
# replace "techical" names with "non-technical names
tempNames <- names(dsReducedWActivityName)

for (i in 1:length(tempNames)) {
        tempNames[i] <- gsub("-mean", " Mean", tempNames[i])
        tempNames[i] <- gsub("-std", " Std.", tempNames[i])
        tempNames[i] <- gsub("[()]", "", tempNames[i])
        tempNames[i] <- gsub("[-]", " ", tempNames[i])
        tempNames[i] <- gsub("activity_name", "Activity", tempNames[i])
        tempNames[i] <- gsub("subject_id", "SubjectID", tempNames[i])
};

colnames(dsReducedWActivityName) <- tempNames

# Step 5:
# use melt to create tidy data set - one variable per row
dsFinal <- melt(dsReducedWActivityName, id=c("Activity", "SubjectID"))

# calculate mean for each variable and create dataset with means on every variable by activity and subject name
dsFinalMean <- dcast(dsFinal, Activity + SubjectID ~ variable, mean)

write.table(dsFinalMean, "./tidydata.txt", append=FALSE)
