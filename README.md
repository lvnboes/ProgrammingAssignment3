---
output: html_document
---
# ProgrammingAssignment3

# read all data, labels and column names

'''{r}
features <- read.table('raw_data/UCI HAR Dataset/features.txt')
labels <- read.table('raw_data/UCI HAR Dataset/activity_labels.txt')
test_subjects <- read.table('raw_data/UCI HAR Dataset/test/subject_test.txt')
test_data <- read.table('raw_data/UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table('raw_data/UCI HAR Dataset/test/y_test.txt')
train_subjects <- read.table('raw_data/UCI HAR Dataset/train/subject_train.txt')
train_data <- read.table('raw_data/UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table('raw_data/UCI HAR Dataset/train/y_train.txt')
'''

# remove unneccessary columns with index numbers

'''{r}
column_names <- features[,2]
label_names <- labels[,2]
'''

# set_column_names of data files

'''{r}
names(test_data) <- column_names
names(train_data) <- column_names
'''

# isolate mean and standard deviation columns

'''{r}
mean_or_std <- grepl('mean()', column_names, fixed=TRUE) | grepl('std()', column_names, fixed=TRUE)
selected_test_data <- test_data[,mean_or_std]
selected_train_data <- train_data[,mean_or_std]
'''

# add subjects and labels to data frames

'''{r}
selected_test_data$Subjects <- test_subjects[,1]
selected_test_data$Labels <- test_labels[,1]
selected_train_data$Subjects <- train_subjects[,1]
selected_train_data$Labels<- train_labels[,1]
'''

# merge test_data and train_data

'''{r}
all_data <- rbind(selected_test_data, selected_train_data)
'''

# add label names to merged dataset

'''{r}
all_data$Labels <- factor(all_data$Labels)
levels(all_data$Labels) <- label_names
'''

# calculate averages grouped by activity and subject

'''{r}
sub <- match('Subjects', names(all_data))
lab <- match('Labels', names(all_data))
summary <- aggregate(all_data[,-c(sub, lab)], list(Labels = all_data$Labels, Subjects = all_data$Subjects), mean)
'''

# write csv of tidy datasets

'''{r}
write.csv(all_data, file='clean_data/tidy_full_data.csv')
write.csv(summary, file='clean_data/tidy_avg_data.csv')
'''