## merge the training and test set from the UCI Human Activity Recognition
## database that extracts only the measurements on the mean and standard deviation
## uses descriptive activity names to name the activities in the data set
## labels the data set with descriptive variable names
## and also creates a second data set with the average of each variable for each 
## activity and each subject

library(dplyr, warn.conflict = FALSE)
library(tidyr)

combineUCI <- function() {
        
        # import features.txt for names
        features <- read.table("./UCI HAR Dataset/features.txt",
                               header = FALSE,
                               stringsAsFactors = FALSE)
        
        # filter features.txt for columns containing mean() or std()
        features.keep <- filter(features, grepl("mean()|std()", features$V2))
        
        # import activity labels
        activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                                      header = FALSE,
                                      stringsAsFactors = FALSE)
        
        # Import test dataset
        test_data <- read.table("./UCI HAR Dataset/test/X_test.txt",
                                header = FALSE,
                                stringsAsFactors = FALSE)
        
        # narrow down test data set based on features.keep
        test_data <- select(test_data, features.keep$V1)
        names(test_data) <- features.keep$V2
        
        ## Import subject data for test dataset
        subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                              header = FALSE,
                              stringsAsFactors = FALSE)
        subject <- subject$V1
        
        activity <- read.table("./UCI HAR Dataset/test/y_test.txt",
                               header = FALSE,
                               stringsAsFactors = FALSE)
        
        # create activity variable and factor into labels
        activity <- factor(activity$V1, levels = activity_labels$V1, 
                           labels = activity_labels$V2)
        
        # add activity and subject to test_data
        test_data$subject <- subject
        test_data$activity <- activity
        
        ## import train data set
        
        train_data <- read.table("./UCI HAR Dataset/train/X_train.txt",
                                 header = FALSE,
                                 stringsAsFactors = FALSE)
        
        # narrow down test data set based on features.keep
        train_data <- select(train_data, features.keep$V1)
        names(train_data) <- features.keep$V2
        
        ## Import subject data for test dataset
        subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                              header = FALSE,
                              stringsAsFactors = FALSE)
        subject <- subject$V1
        
        activity <- read.table("./UCI HAR Dataset/train/y_train.txt",
                               header = FALSE,
                               stringsAsFactors = FALSE)
        
        # create activity variable and factor into labels
        activity <- factor(activity$V1, levels = activity_labels$V1, 
                           labels = activity_labels$V2)
        
        # add activity and subject to test_data
        train_data$subject <- subject
        train_data$activity <- activity
        
        # combine two data sets
        
        data <- tbl_df(rbind(test_data, train_data))
        
        data <- select(data, subject, activity, 1:79)
        
        # gather columns 3:81 together labeling the measurement
        tidy_data <- gather(data, key = observation, value = value, 3:81)
        # group data by subject and activity
        tidy_data <- group_by(tidy_data, subject, activity, observation)
        
        output <- summarise(tidy_data, mean(value))
        names(output) <- c("subject", 
                           "activity",
                           "observation",
                           "mean(observation)")
        # return data
        return(output)
}
# run function above to parse out tidy data set grouped by subject and activity

data <- combineUCI()

# write data as table to output.txt
write.table(data, file = "output.txt", row.names = FALSE)