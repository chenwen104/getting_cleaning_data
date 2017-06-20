

original data source:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

operations to clean up the data:
1. first read in all the following files:
x_train.txt
y_train.txt
subject_train.txt
x_test.txt
y_test.txt
subject_test.txt
features.txt
activity_labels.txt

2. merge test and train datasets into one table with rbind function
3. use grep to pull out colomns with mean() and std() in the name; that is to say, we only want the mean and standard deviation measurements from the table.

4. label the dataset with activity names
use merge to label each activities

5. clean up variable names with gsub

6. creates a second, independent tidy data set with the average of each variable for each activity and each subject
use ddply function 



