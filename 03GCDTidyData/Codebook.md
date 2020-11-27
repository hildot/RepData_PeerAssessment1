---
title: "tidydatacodebook"
author: "H. Dotson"
date: "July 22, 2015"
output: html_document
---
# Tidy Data Codebook Information
The [`run analysis.R` script](https://github.com/hildot/03GCDTidyData/blob/master/run_analysis.R) downloads and extracts the 
[original UCI HAR Dataset created by Anguita et al. (2012)](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
and creates a [tidy data frame](https://s3.amazonaws.com/coursera-uploads/user-49bc5d7654808cf1dbb403b3/975114/asst-3/5ea5383030b811e5afb6036dd93d02fd.txt) (180 rows, 68 columns) from it. 

# Required Packages
If you do not have `data.table`, `plyr`, and `dplyr` already, please install them before running the [`run analysis.R` script](https://github.com/hildot/03GCDTidyData/blob/master/run_analysis.R)

```
install.packages("data.table")
install.packages("plyr")
install.packages("dplyr")
```

# Background 
The following files from the original  were included in development of the tidy dataset:  

* __features.txt__ (561 rows, 2 cols): A list of all features (see Original Features subheading)
* __activity_labels.txt__ (6 rows, 2 cols): The name of the activity the subject was participating in at the time of reading. Activities includ
* __train/X_train.txt__ (7352 rows, 561 cols): Data containing the readings from the training sample.
* __train/y_train.txt__ (7352 rows, 1 col): Numeric labels for the activities participants engaged in corresponding to the Xtrain data.
* __train/subject_train.txt__ (7352 rows, 1 col): Rows contain subject identifier for each activity performed in Xtrain data.
* __test/X_test.txt__ (2947 rows, 561 cols): Data containing the readings from the test sample.
* __test/y_test.txt__ (2947 rows, 1 col): Numeric labels for activities participants engaged in corresponding to the ytest data. 
* __test/subject_test.txt__ (2947 rows, 1 col): Rows contain subject identifier for each activity performed in the ytest data. 

## Original Features 
The original data include information 33 unique features: 

* `tBodyAcc-XYZ:`          time domain signals of body acceleration at X, Y, and Z axes
* `tGravityAcc-XYZ:`       time domain signals of gravity acceleration at X, Y, and Z axes
* `tBodyAccJerk-XYZ:`      time domain signals of body acceleration jerks at X, Y, and Z axes
* `tBodyGyro-XYZ:`         time domain signals of body velocity at X, Y, and Z axes
* `tBodyGyroJerk-XYZ:`     time domain signals of body velocity jerks at X, Y, and Z axes
* `tBodyAccMag:`           time domain signals of body acceleration magnitude
* `tGravityAccMag:`        time domain signals of gravity acceleration magnitude
* `tBodyAccJerkMag:`       time domain signals of body acceleration jerk magnitude
* `tBodyGyroMag:`          time domain signals of body velocity magnitude
* `tBodyGyroJerkMag:`      time domain signals of body velocity jerk magnitude 
* `fBodyAcc-XYZ:`          frequency domain signals body acceleration at X, Y, and Z axes,
* `fBodyAccJerk-XYZ:`      frequency domain signals of body acceleration jerks at X, Y, and Z axes
* `fBodyGyro-XYZ:`         frequency domain signals of body velocity at X, Y, and Z axes
* `fBodyAccMag:`           frequency domain signals of body acceleration magnitude
* `fBodyAccJerkMag:`       frequency domain signals of body acceleration jerk magnitude
* `fBodyGyroMag:`          frequency domain signals of body velocity magnitude
* `fBodyGyroJerkMag:`      frequency domain signals of body velocity jerk magnitude. 

The following variables were estimated using the signals in the original data. A total of 561 feature variables were estimated: 

* `mean():`           Mean value
* `std():`            Standard deviation
* `mad():`            Median absolute deviation 
* `max():`            Largest value in array
* `min():`            Smallest value in array
* `sma():`            Signal magnitude area
* `energy():`         Energy measure. Sum of the squares divided by the number of values. 
* `iqr():`            Interquartile range 
* `entropy():`        Signal entropy
* `arCoeff():`        Autorregresion coefficients with Burg order equal to 4
* `correlation():`    correlation coefficient between two signals
* `maxInds():`        index of the frequency component with largest magnitude
* `meanFreq():`       Weighted average of the frequency components to obtain a mean frequency
* `skewness():`       skewness of the frequency domain signal 
* `kurtosis():`       kurtosis of the frequency domain signal 
* `bandsEnergy():`    Energy of a frequency interval within the 64 bins of the FFT of each window.
* `angle():`          Angle between two vectors.

# Tidy Data Background
The final tidied data is a wide dataset that includes **180 rows and 68 columns**.  

The first column (`Subject`) includes the subject's unique identifier. `Subject` is an integer variable ranging from `1` to `30`.  

The second column (`Activity`) reports the specific activity the respondent was engaged for the subsequent group meaned readings. `Activity` is a factor variable (1 = WALKING, 2 = WALKING UPSTAIRS, 3 = WALKING DOWNSTAIRS, 4 = SITTING, 5 = STANDING, 6 = LAYING).  

Each `Subject` appears six times in the `Activity` column, because each `Subject` has a `feature` reading for **each activity** they engaged in.  

The subsequent columns report *the grouped mean readings of the* `features` that each `Subject` completed when engaged in the specific `Activity` listed.  

## Example
Rows 1 - 6 contain data for `Subject` = 1. Row 1 reports `Subject` = 1's average readings for each `feature` when `Activity` = 1 (walking). Row 2 reports `Subject` = 1's average readings `Activity = 1` (walking upstairs). The subsequent columns report the mean reading for each `feature` of *subject's activity*.

## Tidy Data Summary
The tidy data set:  
1. pastes the descriptive `Activity` labels found in `activity_labels.txt` to the numeric activity files (`y_train.txt`, `y_test.txt`).  
2. combines the `Subject` identifier files (`subject_train.txt` and `subject_test.txt` [final column 1]) to the descriptive `Activity` files (`y_train.txt` and `y_test.txt` [final column 2]) to the numeric `feature` output found in (`X_train.txt` and `X_test.txt` [remaining columns]); resulting in two files: one for the original `train` data [7352, 563] and another for the original `test` data [2947, 563].  
3. row bind the `train` data to the `test` data [10299, 563].  
4. selects only `feature` analyses relevant to the study at hand: `mean` and `std` (see below for more information) [10299, 68]  
5. melt data to facilitate calculation of grouped means [679734, 4]  
6. alter `feature` labels for clarity  
7. filter rows that contain only `mean` [339867, 4]   
8. filter rows that contain only `std` [339867, 4]  
9. cast `mean` data [180, 35]  
10. cast `std` data [180, 35]  
11. join `mean` and `std` data into one tidy data frame [180, 68]  

## Note about Feature Selection
When selecting columns to include in the tidy dataset, I only included columns for *subject identifier*, *activity*, and columns *containing the words* `mean` *or* `std` (shorthand for standard deviation). I specifically chose to omit columns that *contained the words* `angle` *or* `meanFreq`. Observe code `lines 88:98` in for limiting `feature` selection: 

```{r eval = FALSE}
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
```

I did not include columns for angled means, because the angle measurement was taken *after* the intial mean was calculated. In my view, angled values did not represent what was asked for in the assginment.  

I did not include meanFreqs columns, because these are not simple arithmetic means. Mean frequencies are weighted averages of frequencies, which in my view, did not represent what was asked for in the assignment. 

# Format for Feature Variable Labels in Tidy Data

All `feature` variables are labeled using the same common criteria:

1. The text `Group.` at the beginning to note that the data reported in the tidy data are grouped means.  
2. The letter `t` or `f`, denoting whether the variable examines time or frequency domain signals.  
3. The description of the measurement (e.g., `BodyAcc.`, `BodyGyroMag`) used in the original data file.  
4. The word `mean` or `std`, denoting whether the original variable measured the mean of the `feature` or the standard deviation.  
5. If necessary, `.X`, `.Y`, `.Z`, denoting the axis of the original measurement.  

# Disclaimer 
The tidy data set and the `run_analysis.R` script have been created by the author, H. Dotson, to fulfil course requirements in "Getting and Cleaning Data", a Coursera class. At the conclusion of the course, this repository will be deleted from Github. 

# References
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

```{r, include = FALSE}
file.rename(from = "Codebook.Rmd",
            to="Codebook.md")
```