Data Scientist's Toolbox: Getting and Cleaning Data
Course Project

This data was extracted from the UCI Human Activity Recognition Data Set found here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Complete descriptions of the initial experiments and data processing are included within the zipped file.  

The tidy data set includes one .txt file, Course_Project_Tidy_Data.txt.  Each record in this data set includes: 
- Unique subject identifier
- Unique activity identifier
- Average (mean) values of 68 variables throught the conduct of the activity by the subject.  
Full description of all variables can be found in the code book, code_book.txt.  

The data set was obtained through use of the R script, run_analysis.R.  Its function is as follows: 

Assumptions: 
- Plyr and utils libraries are installed and loaded in RStudio
- Data is downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
- Data is extracted to the working directory, in the folder "UCI HAR Dataset"; if properly unzipped, it will contain two subfolders ("test" and "train") and several additional files.  

Steps in run_analysis.R: 
- Working directory is established and assigned to a variable (this will be used to return at the end of the code). 
- Descriptive files are read in; these include the variable names and the activity names; variable names are transformed from a data.frame to a vector, called variable_names. 
- Data is read in from "test" and "train" folders; each folder contains three files which are combined: a subject identifier file, activity identifier file, and observation data file.  As they are read in, each is assigned column names for all variables. The three files are combined using column binding (cbind).  
- Test and train data are merged into data.frame testAndTrain; this is CLASS PROJECT PART ONE.  
- The grep function is used with the variable.names vector to identify only the variables that are means and standard deviations.  These are identified by the descriptor mean() or std(); these are the variables defined within the original code book as mean value and standard deviation.  meanFreq() values were NOT included because they were not strictly a mean value, but a permutation of frequency components.  
- The cases of variables matching mean() or std() are used to subset the testAndTrain data into meanAndSDData; this is CLASS PROJECT PART TWO.  
- An additional column is appended to meanAndSDData; this column is activity_name.  It uses the activity_labels matrix read in at the beginning, and assigns a label based on the activity identifier in the second column of the meanAndSDData data.frame.  This is CLASS PROJECT PART THREE.  
- The column names are transformed into more readable and R-acceptable variable names; Hadley Wickham's style conventions found here: http://adv-r.had.co.nz/Style.html .  Each objectionable or incomplete term is corrected using the seek-and-replace function, sub().  This is CLASS PROJECT PART FOUR.  
- ddply was used to split the data by subject and activity, and take the mean of each variable for these cases.  Each column is labeled with the variable therein.  It is then exported as wide tidy data, where each row represents observations taken on a single subject and activity.  The new table is exported as Course_Project_Tidy_Data.txt .  This is CLASS PROJECT PART FIVE.  




