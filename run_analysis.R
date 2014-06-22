run_analysis <- function() 	{

## Establish initial directory
hd <- getwd()

## Move into data location
setwd("UCI HAR Dataset")

## Read in the activity labels and variable names
activity_labels <- read.table("activity_labels.txt")
variable_matrix <- read.table("features.txt")
variable_names <- variable_matrix$V2


## Read in "test" data
UHD <- getwd()
setwd("test")
testSubjects <- read.table("subject_test.txt")
colnames(testSubjects) <- "subject_id"
testData <- read.table("X_test.txt")
colnames(testData) <- variable_names
testActivity <- read.table("y_test.txt")
colnames(testActivity) <- "activity_id"
setwd(UHD)

## Read in "training" data
setwd("train")
trainSubjects <- read.table("subject_train.txt")
colnames(trainSubjects) <- "subject_id"
trainData <- read.table("X_train.txt")
colnames(trainData) <- variable_names
trainActivity <- read.table("y_train.txt")
colnames(trainActivity) <- "activity_id"
setwd(UHD)

## CLASS PROJECT PART ONE: 
## Merge the training and test sets to create one data set.  
## First, combine the test data, using column binding: 
testComplete <- cbind(testSubjects, testActivity, testData)
## Second, combine the training data, using column binding: 
trainComplete <- cbind(trainSubjects, trainActivity, trainData)
## Third, combine the test data with the training data, using row binding: 
testAndTrain <- rbind(testComplete, trainComplete)

## CLASS PROJECT PART TWO: 
## Extracts only the measurements on the mean and standard deviation for each
## measurement. 
## First, establish which data we are interested in finding--only means and standard
## deviations.  From the features_info.txt file, we know that these have the label 
## mean() or std() so we can use grep to create a vector of only the columns in which
## we are interested.  We must be cautious--use fixed=TRUE to avoid the meanFreq() 
## data, and get only the mean() and std() data. 
m <- "mean()"
s <- "std()"
f <- grep(m, variable_names, fixed = TRUE)
g <- grep(s, variable_names, fixed = TRUE)
h <- c(f, g)
originalCols <- sort(h)
## desiredCols is a vector giving which columns, from the original data sets, are  
## the desired means and standard deviations.  Because we have added two columns in 
## front of that data set, we must add two to each value in originalCols, and add the
## first two columns, for the subject and activity numbers.  
shiftCols <- originalCols+2
desiredCols <- c(1, 2, shiftCols)
## Now, subset the full data set by desiredCols.  
meanAndSDdata <- testAndTrain[,desiredCols]

## CLASS PROJECT PART THREE: 
## Uses descriptive activity names to name the activities in the data set. 
## In the above massive data frame, meanAndSDdata, the second column (presently
## meanAndSDdata$V1.1, because we have not renamed columns yet) has a variable for
## the activity code.  We will add a column to meanAndSDdata, and use the V1.1 
## value to select an activity from the activity_labels data frame above (where 
## activity_labels$V2 has the actual names).  
meanAndSDdata$activity_name <- activity_labels$V2[meanAndSDdata$activity_id]

## CLASS PROJECT PART FOUR: 
## Appropriately labels the data set with descriptive variable names.  
## When initially read in, the data was given its original labels from the 
## features.txt file.  Using sub() and gsub(), we will transform these as described
## in the code book.
initialNames <- colnames(meanAndSDdata)
names2 <- sub("^t", "time_", initialNames)
names3 <- sub("^f", "freq_", names2)
## Note that there appears to be an error in several variables--"BodyBody" instead of
## "Body".  This seek and replace fixes that, and the seek/replaces continue. 
names4 <- sub("BodyBody", "Body", names3)
names5 <- sub("Body", "body_", names4)
names6 <- sub("Gravity", "grav_", names5)
names7 <- sub("Acc", "acc_", names6)
names8 <- sub("Gyro", "gyr_", names7)
names9 <- sub("Jerk", "jerk_", names8)
names10 <- sub("Mag", "mag_", names9)
names11 <- sub("-mean\\(\\)", "mean", names10)
names12 <- sub("-std\\(\\)", "stdv", names11)
names13 <- sub("-X", "_x", names12)
names14 <- sub("-Y", "_y", names13)
names15 <- sub("-Z", "_z", names14)
colnames(meanAndSDdata) <- names15


## CLASS PROJECT PART FIVE: 
## Create a second, independent tidy data set with the average of each variable
## for each activity and each subject.
newData <- ddply(meanAndSDdata, c("subject_id", "activity_name"), summarize, 
	mean_time_body_acc_mean_x = mean(time_body_acc_mean_x), 	mean_time_body_acc_mean_y = mean(time_body_acc_mean_y), 
	mean_time_body_acc_mean_z = mean(time_body_acc_mean_z), 	mean_time_body_acc_stdv_x = mean(time_body_acc_stdv_x), 
	mean_time_body_acc_stdv_y = mean(time_body_acc_stdv_y), 	mean_time_body_acc_stdv_z = mean(time_body_acc_stdv_z), 
	mean_time_grav_acc_mean_x = mean(time_grav_acc_mean_x), 	mean_time_grav_acc_mean_y = mean(time_grav_acc_mean_y), 
	mean_time_grav_acc_mean_z = mean(time_grav_acc_mean_z), 	mean_time_grav_acc_stdv_x = mean(time_grav_acc_stdv_x), 
	mean_time_grav_acc_stdv_y = mean(time_grav_acc_stdv_y), 	mean_time_grav_acc_stdv_z = mean(time_grav_acc_stdv_z), 
	mean_time_body_acc_jerk_mean_x = mean(time_body_acc_jerk_mean_x),
	mean_time_body_acc_jerk_mean_y = mean(time_body_acc_jerk_mean_y),
	mean_time_body_acc_jerk_mean_z = mean(time_body_acc_jerk_mean_z),
	mean_time_body_acc_jerk_stdv_x = mean(time_body_acc_jerk_stdv_x),
	mean_time_body_acc_jerk_stdv_y = mean(time_body_acc_jerk_stdv_y), 
	mean_time_body_acc_jerk_stdv_z = mean(time_body_acc_jerk_stdv_z), 
	mean_time_body_gyr_mean_x = mean(time_body_gyr_mean_x), 	mean_time_body_gyr_mean_y = mean(time_body_gyr_mean_y), 
	mean_time_body_gyr_mean_z = mean(time_body_gyr_mean_z), 	mean_time_body_gyr_stdv_x	= mean(time_body_gyr_stdv_x),
	mean_time_body_gyr_stdv_y	= mean(time_body_gyr_stdv_y),	mean_time_body_gyr_stdv_z	= mean(time_body_gyr_stdv_z),
	mean_time_body_gyr_jerk_mean_x	= mean(time_body_gyr_jerk_mean_x),
	mean_time_body_gyr_jerk_mean_y	= mean(time_body_gyr_jerk_mean_y),
	mean_time_body_gyr_jerk_mean_z	= mean(time_body_gyr_jerk_mean_z),
	mean_time_body_gyr_jerk_stdv_x	= mean(time_body_gyr_jerk_stdv_x),
	mean_time_body_gyr_jerk_stdv_y	= mean(time_body_gyr_jerk_stdv_y),
	mean_time_body_gyr_jerk_stdv_z	= mean(time_body_gyr_jerk_stdv_z),
	mean_time_body_acc_mag_mean	= mean(time_body_acc_mag_mean),	mean_time_body_acc_mag_stdv	= mean(time_body_acc_mag_stdv),
	mean_time_grav_acc_mag_mean	= mean(time_grav_acc_mag_mean),	mean_time_grav_acc_mag_stdv	= mean(time_grav_acc_mag_stdv),
	mean_time_body_acc_jerk_mag_mean	= mean(time_body_acc_jerk_mag_mean),
	mean_time_body_acc_jerk_mag_stdv	= mean(time_body_acc_jerk_mag_stdv),
	mean_time_body_gyr_mag_mean	= mean(time_body_gyr_mag_mean),	mean_time_body_gyr_mag_stdv	= mean(time_body_gyr_mag_stdv),
	mean_time_body_gyr_jerk_mag_mean	= mean(time_body_gyr_jerk_mag_mean),
	mean_time_body_gyr_jerk_mag_stdv	= mean(time_body_gyr_jerk_mag_stdv),
	mean_freq_body_acc_mean_x	= mean(freq_body_acc_mean_x),	mean_freq_body_acc_mean_y	= mean(freq_body_acc_mean_y),
	mean_freq_body_acc_mean_z	= mean(freq_body_acc_mean_z),	mean_freq_body_acc_stdv_x	= mean(freq_body_acc_stdv_x),
	mean_freq_body_acc_stdv_y	= mean(freq_body_acc_stdv_y),	mean_freq_body_acc_stdv_z	= mean(freq_body_acc_stdv_z),
	mean_freq_body_acc_jerk_mean_x	= mean(freq_body_acc_jerk_mean_x),
	mean_freq_body_acc_jerk_mean_y	= mean(freq_body_acc_jerk_mean_y),
	mean_freq_body_acc_jerk_mean_z	= mean(freq_body_acc_jerk_mean_z),
	mean_freq_body_acc_jerk_stdv_x	= mean(freq_body_acc_jerk_stdv_x),
	mean_freq_body_acc_jerk_stdv_y	= mean(freq_body_acc_jerk_stdv_y),
	mean_freq_body_acc_jerk_stdv_z	= mean(freq_body_acc_jerk_stdv_z),
	mean_freq_body_gyr_mean_x	= mean(freq_body_gyr_mean_x),	mean_freq_body_gyr_mean_y	= mean(freq_body_gyr_mean_y),
	mean_freq_body_gyr_mean_z	= mean(freq_body_gyr_mean_z),	mean_freq_body_gyr_stdv_x	= mean(freq_body_gyr_stdv_x),
	mean_freq_body_gyr_stdv_y	= mean(freq_body_gyr_stdv_y),	mean_freq_body_gyr_stdv_z	= mean(freq_body_gyr_stdv_z),
	mean_freq_body_acc_mag_mean	= mean(freq_body_acc_mag_mean),
	mean_freq_body_acc_mag_stdv	= mean(freq_body_acc_mag_stdv),
	mean_freq_body_acc_jerk_mag_mean	= mean(freq_body_acc_jerk_mag_mean),
	mean_freq_body_acc_jerk_mag_stdv	= mean(freq_body_acc_jerk_mag_stdv),
	mean_freq_body_gyr_mag_mean	= mean(freq_body_gyr_mag_mean),	mean_freq_body_gyr_mag_stdv	= mean(freq_body_gyr_mag_stdv),
	mean_freq_body_gyr_jerk_mag_mean	= mean(freq_body_gyr_jerk_mag_mean),
	mean_freq_body_gyr_jerk_mag_stdv	= mean(freq_body_gyr_jerk_mag_stdv))

##Return to original working directory
setwd(hd)

## Export the new tidy data set to a .txt file. 
write.table(newData, "Course_Project_Tidy_Data.txt")

}