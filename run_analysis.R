library(dplyr)
library(data.table)

#download zip file and unzip 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#destination path
destfile <- paste0(getwd(),"/","dataweek4.zip")
#download zip file
download.file(url,destfile,method = "curl")
#unzip file
unzip("dataweek4.zip")


#now read in all the datasets we need to deal with
setwd("/Users/wenchen/Documents/Coursera/JHU_datascience/3_cleaningdata/UCI HAR Dataset/")
#Training files
train_data_x <- read.table("./train/X_train.txt",header = FALSE) 
train_data_y <- read.table("./train/y_train.txt") 
train_data_subject <- read.table("./train/subject_train.txt") 

# test data files 
test_data_x <- read.table("./test/X_test.txt") 
test_data_y <- read.table("./test/y_test.txt") 
test_data_subject <- read.table("./test/subject_test.txt") 

# features file 
features <- read.table("./features.txt") 

# activity names 
activity_labels <- read.table("./activity_labels.txt") 

#Merge train and test sets to create one set
joined_data <- rbind(train_data_x,test_data_x) 
joined_labels <- rbind(train_data_y,test_data_y) 
joined_subjects <- rbind(train_data_subject,test_data_subject) 

# Set the appropiate column names  
names(joined_data) <- features$V2    #or use features[[2]]
names(joined_labels) <- c("Activityid") 
names(joined_subjects) <- c("Subjects") 

#get only columns with mean() or std() in their names
means_and_stds_indices <- grep("(mean|std)\\(\\)",features[[2]]) 
# Extract relevant joined data from the indices  
means_and_stds_joined_data <- joined_data[means_and_stds_indices]  


# Tidy up the column names 
names(activity_labels) <- c("Activityid","Activityname") 


# Substitute the IDs with the merge function  
activities <- merge(activity_labels,joined_labels,"Activityid") 
#add these 2 colomns to means and stds dataset
means_and_stds_joined_data$activities <- activities[[2]] 
means_and_stds_joined_data$subjects <- joined_subjects[[1]] 


# Clean up the columnnames 
names(means_and_stds_joined_data) <- gsub("\\(\\)","",names(means_and_stds_joined_data)) 
names(means_and_stds_joined_data) <- gsub("-","",names(means_and_stds_joined_data)) 
#names(means_and_stds_joined_data) <- gsub("std","Std",names(means_and_stds_joined_data)) 
#names(means_and_stds_joined_data) <- gsub("mean","Mean",names(means_and_stds_joined_data)) 

# creates a second, independent tidy data set with the average of each variable for each activity and each subject
second_dataset <- ddply(means_and_stds_joined_data, .(subjects, activities), function(x) colMeans(x[, 1:66]))


# write out to file 
write.table(means_and_stds_joined_data, "clean_data.txt") 
write.table(second_dataset,"second_set.txt",row.name=FALSE) 

