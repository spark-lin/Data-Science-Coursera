## CodeBook.md
### UCI-Run Analysis

1-Set Working Directory  

  1.1-Downloads required data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
  1.2-Unzip downloaded dataset to data directory
  
  1.3-Load required packages


2-Merging the trainning and the test sets to create one dataset

  2.1- Read files 
  
    2.1.1-Read the training tables (load X_train.txt, y_train.txt, subject_train.txt)
    
    2.1.2-Read testing tables (load X_test.txt, y_test.txt, subject_test.txt)
    
    2.1.3-Read the features (load features.txt)
    
    2.1.4-Read activity labels


  2.2-Rename columns names
  2.3- Merge data into one dataset - MergeAll


3-Extracts only the measurements on the mean and standard deviation for each measurement

  3.1-Read column names
  
  3.2- Rename dataset into required ID, mean and std
  
  3.3- Create subset from MergeAll


4-Use variable means sorted by subject and activity to create datatable - subset_ActivityNames 


5-Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

  5.1-Create second tify dataset -TidyData
  
  5.2-Write and save clear and tidy data into TidyData.txt and save it in working directory




