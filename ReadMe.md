---
title: "ReadMe"
author: "lvnboes"
date: "11/08/2021"
output: html_document
---

Below, I will display my script to clean the data up in short chunks and explain what ever chunk of code does.


```{r read}
features <- read.table('raw_data/UCI HAR Dataset/features.txt')
labels <- read.table('raw_data/UCI HAR Dataset/activity_labels.txt')
test_subjects <- read.table('raw_data/UCI HAR Dataset/test/subject_test.txt')
test_data <- read.table('raw_data/UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table('raw_data/UCI HAR Dataset/test/y_test.txt')
train_subjects <- read.table('raw_data/UCI HAR Dataset/train/subject_train.txt')
train_data <- read.table('raw_data/UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table('raw_data/UCI HAR Dataset/train/y_train.txt')
```

The chunk of code above simply reads all the necessary data files.


```{r read}
column_names <- features[,2]
label_names <- labels[,2]
```

The features and labels columns both contain a superfluous index column. In the code chunk above, I save the second column with respectively the feature names (i.e. the column names of the eventual data set) and the label names to separate variables.


```{r read}
names(test_data) <- column_names
names(train_data) <- column_names
```

In the code above, I set the names of the columns in both the test_data data frame and the train_data data frame with the names I got from the features file.


```{r read}
mean_or_std <- grepl('mean()', column_names, fixed=TRUE) | grepl('std()', column_names, fixed=TRUE)
selected_test_data <- test_data[,mean_or_std]
selected_train_data <- train_data[,mean_or_std]
```

Above, I Index the column names that include 'mean()' or 'std()' to extract only the measurements that contain means and standard deviations and then use that index to select only the relevant columns and save them to separate variables


```{r read}
selected_test_data$Subjects <- test_subjects[,1]
selected_test_data$Labels <- test_labels[,1]
selected_train_data$Subjects <- train_subjects[,1]
selected_train_data$Labels<- train_labels[,1]
```

Then, I add the subject and label columns of both the test and train data sets to their respective data frames.


```{r read}
all_data <- rbind(selected_test_data, selected_train_data)
```

The line of code above joins both data frames.


```{r read}
all_data$Labels <- factor(all_data$Labels)
levels(all_data$Labels) <- label_names
```

Once both data sets are joined, I transform the Labels column to a factor and swap the numerical labels for meaningful ones.


```{r read}
sub <- match('Subjects', names(all_data))
lab <- match('Labels', names(all_data))
summary <- aggregate(all_data[,-c(sub, lab)], list(Labels = all_data$Labels, Subjects = all_data$Subjects), mean)
```

The code above groups the complete data set by Label and Subject, calculates the averages for these groups and saves the results to a new summary data frame.


```{r read}
write.csv(all_data, file='clean_data/tidy_full_data.csv')
write.csv(summary, file='clean_data/tidy_avg_data.csv')
```

Finally, both the tidy dataset containing all the data and the tidy dataset with the summarised average data are written to separate csv-files.




