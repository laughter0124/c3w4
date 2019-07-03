library(dplyr)

# read original data

# read labelsa
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

# read training data
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# 1. Merges the training and the test sets to create one data set.
train<-cbind(subject_train, y_train, X_train)
test<-cbind(subject_test, y_test, X_test)
data<-rbind(train, test)
names(data)<-c("subjects", "activitylabels", as.character(features$V2))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selectdata<-data[,c(1,2,grep("mean|std",names(data)))]

# 3. Uses descriptive activity names to name the activities in the data set
selectdata$activitylabels<-activity_labels$V2[selectdata$activitylabels]

# 4. Appropriately labels the data set with descriptive variable names.
variablenames<-names(selectdata)
variablenames<-gsub("^t", "time", variablenames)
variablenames<-gsub("^f", "frequency", variablenames)
variablenames<-gsub("Acc", "Accelerometer", variablenames)
variablenames<-gsub("Gyro", "Gyroscope", variablenames)
variablenames<-gsub("Mag", "Magnitude", variablenames)
variablenames<-gsub("BodyBody", "Body", variablenames)
variablenames<-gsub("-mean", "Mean", variablenames)
variablenames<-gsub("-std", "STD", variablenames)
variablenames<-gsub("[\\(\\)-]", "", variablenames)
names(selectdata)<-variablenames

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#selectdata$subjects<-as.factor(selectdata$subjects)
groupdata<-group_by(selectdata,subjects,activitylabels)
meangroupdata<-summarise_each(groupdata, mean)
write.table(meangroupdata, "tidydata.txt")