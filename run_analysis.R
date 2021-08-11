# read all data, activity labels and column names

features <- read.table('raw_data/UCI HAR Dataset/features.txt')
activities <- read.table('raw_data/UCI HAR Dataset/activity_labels.txt')
test_subjects <- read.table('raw_data/UCI HAR Dataset/test/subject_test.txt')
test_data <- read.table('raw_data/UCI HAR Dataset/test/X_test.txt')
test_labels <- read.table('raw_data/UCI HAR Dataset/test/y_test.txt')
train_subjects <- read.table('raw_data/UCI HAR Dataset/train/subject_train.txt')
train_data <- read.table('raw_data/UCI HAR Dataset/train/X_train.txt')
train_labels <- read.table('raw_data/UCI HAR Dataset/train/y_train.txt')

# remove unneccessary columns with index numbers

column_names <- features[,2]
activity_names <- activities[,2]

# set_column_names of data files

names(test_data) <- column_names
names(train_data) <- column_names

# isolate mean and standard deviation columns

mean_or_std <- grepl('mean()', column_names, fixed=TRUE) | grepl('std()', column_names, fixed=TRUE)
selected_test_data <- test_data[,mean_or_std]
selected_train_data <- train_data[,mean_or_std]

# add subjects and labels to data frames

selected_test_data$Subject <- test_subjects[,1]
selected_test_data$Activity <- test_labels[,1]
selected_train_data$Subject <- train_subjects[,1]
selected_train_data$Activity<- train_labels[,1]

# merge test_data and train_data

all_data <- rbind(selected_test_data, selected_train_data)

# add label names to merged dataset

all_data$Activity <- factor(all_data$Activity)
levels(all_data$Activity) <- activity_names

# calculate averages grouped by activity and subject

sub <- match('Subject', names(all_data))
act <- match('Activity', names(all_data))
summary <- aggregate(all_data[,-c(sub, act)], list(Activity = all_data$Activity, Subject = all_data$Subject), mean)

# write csv of tidy datasets

write.csv(all_data, file='clean_data/tidy_full_data.csv')
write.csv(summary, file='clean_data/tidy_avg_data.csv')

