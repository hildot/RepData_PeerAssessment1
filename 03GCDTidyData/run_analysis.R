# Check for directory and download files to working directory. Remove tmp vector
if(!file.exists("UCI HAR Dataset")){dir.create("UCI HAR Dataset")}
if(!file.exists("UCI HAR Dataset/test/")){dir.create("UCI HAR Dataset/test/")}
if(!file.exists("UCI HAR Dataset/train/")){dir.create("UCI HAR Dataset/train")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./UCI HAR Dataset.zip", mode = "wb")
unzip("UCI HAR Dataset.zip")
rm(fileUrl)

library(data.table)
# Load activity_labels.txt. File includes 6 rows, 2 columns. 
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                              colClasses = "character")
# Create a vector that includes the activity labels and the number to which 
#    they correspond.
activity2 <- as.vector(activity.labels[,"V2"])

# Remove activity.labels from workspace. 
rm(activity.labels)

# Load features.txt. File includes 561 rows, 2 columns. 
features <- read.table("./UCI HAR Dataset/features.txt")
# Create a vector that includes the feature labels and the number to which they correspond.
features2 <- as.vector(features[,"V2"])

# Remove features from workspace.
rm(features)

# Load the test and training datafiles. Apply features2 vector to create 
#    descriptive column names matching the original authors' column names. 
#    x.train includes 7352 rows, 561 columns.
#    x.test includes 2947 rows, 561 columns.
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features2)
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features2)

# Remove features2 vector from workspace.
rm(features2)

# Load the test and training label datafiles. Label column as "Activity". 
#    y.train includes 7352 rows, 1 column.
#    y.test includes 2947 rows, 1 column.
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")

# Apply activity2 vector as labels to variable "Activity" in y.train and y.test.
y.train$Activity <- factor(y.train$Activity,
                           levels = c(1, 2, 3, 4, 5, 6), 
                           labels = activity2)
y.test$Activity <- factor(y.test$Activity,
                          levels = c(1, 2, 3, 4, 5, 6), 
                          labels = activity2)

# Remove activity2 vector from workspace. 
rm(activity2)

# Load subject identifier files. Label column "Subject". 
#    subject.train includes 7352 rows, 1 column.
#    subject.test includes 2947 rows, 1 column. 
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "Subject")
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "Subject")

# Column bind the train subject identifier file to the train activity label file,
#    then the train data files. sub.y.x.train includes 7352 rows, 563 cols
sub.y.x.train <- cbind(subject.train, y.train, x.train)

# Remove subject.train, y.train, and x.train from workspace.
rm(subject.train, y.train, x.train)

# Column bind the test subject identifier file to the test activity label file,
#    then the test data files. sub.y.x.test includes 2947 rows, 563 columns. 
sub.y.x.test <- cbind(subject.test, y.test, x.test)

# Remove subject.test, y.test, and x.test from workspace.
rm(subject.test, y.test, x.test)

# Row bind sub.y.x.train to sub.y.x.test. Test data appears below training data,
#    starting at row 7353. test.train contains 10299 rows and 563 columns.
test.train <- rbind(sub.y.x.train, sub.y.x.test)

# Remove sub.y.x.train and sub.y.x.test from workspace.
rm(sub.y.x.train, sub.y.x.test)

library(plyr)
library(dplyr)

# Select columns that include subject identifiers (+1 col), activities (+1 col),
#    means (+ 53 cols) and standard deviations (+33 cols). Col count: 88
#    In addition, omit columns that include "angle" and "meanFreq", because:  
#         1) "angle": angle() was calculated on select previously 
#              calculated means. No standard deviation col. (-7 cols). 
#         2) "meanFreq": meanFreqs are weighted averages of frequencies, not
#             simple arithmetic means. No standard deviation col. (-13 cols).
#    Data frame cut.test.train contains 10299 rows, 68 columns. 

cut.test.train <- select(test.train, Subject, Activity, contains("mean"), 
                         contains("std"), -contains("angle"), -contains("meanFreq"))

# Remove test.train from workspace. 
rm(test.train)

# Melt data to reshape. melt.test.train contains 679,734 rows and 4 columns. 
melt.test.train <- melt(cut.test.train, id.vars = c("Subject", "Activity"), 
                        variable.name = "Feature", 
                        value.name = "Value")

# Remove cut.test.train from workspace. 
rm(cut.test.train)

# Alter Feature labels for readability. 
melt.test.train$Feature <- gsub("^", "Group.", melt.test.train$Feature)
melt.test.train$Feature <- gsub("...X", ".X", melt.test.train$Feature)
melt.test.train$Feature <- gsub("...Y", ".Y", melt.test.train$Feature)
melt.test.train$Feature <- gsub("...Z", ".Z", melt.test.train$Feature)

# Filter melt.test.train data. Includes only rows that report means.
#    filter.mean includes 339867 rows, 4 columns.
filter.mean <- filter(melt.test.train, grepl("mean", Feature))

# Filter melt.test.train data. Includes only rows that report standard deviations.
#    filter.std includes 339867 rows, 4 columns.
filter.std <- filter(melt.test.train, grepl("std", Feature)) 

# Remove melt.test.train from workspace.
rm(melt.test.train)

# Use dcast to reshape filter.mean. wide.mean calculates mean _mean_ value
#    for each subject based on the activity they were engaged in and the
#    feature being measured. wide.mean contains 180 rows and 35 columns. 
wide.mean <- dcast(filter.mean, Subject + Activity ~ Feature, fun.aggregate = mean)

# Use dcast to reshape filter.std. wide.std calculates mean _std_ value
#    for each subject based on the activity they were engaged in and the
# feature being measured. wide.std contains 180 rows and 35 columns. 
wide.std <- dcast(filter.std, Subject + Activity ~ Feature, fun.aggregate = mean)

# Remove filter.mean and filter.std from workspace.
rm(filter.mean, filter.std)

# Join wide.mean and wide.std. Join is preferable to merge() as it does not 
#    reorder the data. File containes 180 rows, 68 columns.
tidy.wide <- join(wide.mean, wide.std, type = "full")

# Remove wide.mean and wide.std from workspace.
rm(wide.mean, wide.std)

# Save tidy data.
write.table(tidy.wide, file = "tidydata.txt", row.names = FALSE)