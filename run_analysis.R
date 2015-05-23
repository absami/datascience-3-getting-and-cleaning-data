# Project stats: RStudio Version 0.98.1103, OS is Ubuntu 15.04, R version 3.1.2


# Required packages: reshape
library(reshape)

# Uncomment if you wish to get rid of other variables in memory
rm(list = ls(all=TRUE))


# Please modify the path here if required.
#setwd("~/Desktop/coursera-getting-cleaning-data/project")

# Read in features.txt
features <- read.table("./UCI HAR Dataset/features.txt")

# Read in the files under 'test' directory
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")   
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")


# Change (column) variable names in y_test from V1 to Subject person
names(subject_test)[names(subject_test)=="V1"] <- "Subject"
# subject_test column is now ready to be 'bind' into the combined test data

##############################################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
##############################################################################################################################
# There are a total of six types of activities carried out by each subject. These activities are in the form of six levels,
# and are stored in the file 'activity_labels.txt'. I have manually created a little prettier names (without underscores and
# ALLCAPS) and used them as values to put in the 'Activity' column.
# Convert each value in y_test to its equivalent factor label.
y_test <- factor(y_test[, 1], levels=c(1,2,3,4,5,6), labels=c("Walking", "Walking-Upstairs", "Walking-Downstairs", "Sitting", "Standing", "Laying"))
# This results in x being an object of class factor. Now convert x to a 'character array'
y_test <- as.character(y_test)
# Then convert x to a dataframe
y_test <- data.frame(y_test)
# Change (column) variable names in y_test from V1 to Activity
names(y_test)[names(y_test)=="y_test"] <- "Activity"
# y_test column is now ready to be 'bind' into the combined test data

##############################################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
##############################################################################################################################
# Now we want to replace each column Vx with its equivalent feature name.
# There are a total of 561 feature names (as given by nrow(features))
i <- 1:nrow(features)
# Create a character array of feature columns
feature_cols <- paste("V", i, sep='')
# Find and replace each column name Vx, with its feature name as provided in the features.txt file
for (i in 1:nrow(features)) {
    #names(combined_test_data)[names(combined_test_data)==feature_cols[i]] <- as.character(features[i, 2])
    names(X_test)[names(X_test) == feature_cols[i]] <- as.character(features[i, 2])
}

# Finally combine the test data into one data frame
combined_test_data <- cbind(subject_test, y_test, X_test)

# Write the output into a separate file for test data
# write.table(combined_test_data, file = "combined_test_data.txt")

# remove data that may not be required again, to save memory
rm(X_test, subject_test, y_test, i)


# Similar operations for the training data
# Read in the files under 'train' directory
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(subject_train)[names(subject_train)=="V1"] <- "Subject"
y_train <- factor(y_train[, 1], levels=c(1,2,3,4,5,6), labels=c("Walking", "Walking-Upstairs", "Walking-Downstairs", "Sitting", "Standing", "Laying"))
y_train <- as.character(y_train)
y_train <- data.frame(y_train)
names(y_train)[names(y_train)=="y_train"] <- "Activity"
i <- 1:nrow(features)
feature_cols <- paste("V", i, sep='')
for (i in 1:nrow(features)) {
    names(X_train)[names(X_train) == feature_cols[i]] <- as.character(features[i, 2])
}

combined_train_data <- cbind(subject_train, y_train, X_train)
#write.table(combined_train_data, file = "combined_train_data.txt")
rm(X_train, subject_train, y_train, features, feature_cols, i)

##############################################################################################################################
# 1. Merges the training and the test sets to create one data set.
##############################################################################################################################
# Make a combined data variable and store it as such
combined_data <- rbind(combined_test_data, combined_train_data)

# Reordering the combined data by Subjects (volunteers), then by Activity
#newData <- combined_data[order(combined_data[,"Subject"]),]
combined_data <- combined_data[order(combined_data[,"Subject"], combined_data[,"Activity"]),]

#write.table(file = "./project/combined_data.txt", combined_data, row.names=FALSE)


##############################################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##############################################################################################################################
combined_data.names <- names(combined_data)
meanRelatedCols <- grep("mean()", combined_data.names)
stdRelatedCols <- grep("std()", combined_data.names)

data <- cbind(combined_data[, meanRelatedCols], combined_data[, stdRelatedCols])
final_data <- cbind(combined_data[,1:2], data)


# Creating subsetting vectors to use on data
x <- levels(factor(final_data[, "Subject"]))
y <- levels(final_data[, "Activity"])


# Create an empty data matrix to hold results
d <- data.frame()

# Calculate the desired data
for (i in x) {
    for (j in y) {
        print(i)
        k <- subset(final_data, (final_data[, "Subject"]== i & final_data[,"Activity"]==j))
        m <- data.frame(Subject=i, Activity=j, t(apply(k[3:ncol(k)], 2, mean)), check.names = FALSE)
        d <- rbind(d, m)
    }
}

##############################################################################################################################
# 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################################################################################################################
# This part of the code deals with 'tidying' the data
# Melt the data into skinny form where 
# 1. Each variable in one column
# 2. Each observation in its own row
# The column names are as follows:
# Subject    Activity    Feature.Names    Means
#d$rownames <- rownames(d)
dmelt <- melt(d, id=c(1, 2), measure.vars = c(3:length(names(d))))
# Rename the Columns
names(dmelt)[names(dmelt)=="variable"] <- "Feature.Name"
names(dmelt)[names(dmelt)=="value"] <- "Means"

# View the final output
View(dmelt)
# and also save it to a file.
write.table(file = "./tidy_data.txt", dmelt, row.names=FALSE)
cat(paste("tidy_data.txt generated at: ", getwd()))
# Removing variables that may not be required
rm(k, m)