---
title: "Tidy Data README"
author: "H. Dotson"
date: "July 21, 2015"
output: html_document
---
# Background
The [`run analysis.R` script](https://github.com/hildot/03GCDTidyData/blob/master/run_analysis.R) downloads and extracts the 
[original UCI HAR Dataset created by Anguita et al. (2012)](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
and creates a [tidy data frame](https://s3.amazonaws.com/coursera-uploads/user-49bc5d7654808cf1dbb403b3/975114/asst-3/432a3ec030a411e5a73b8fcd88c40806.txt) (180 rows, 68 columns) from it. 

# Required Packages
If you do not have `data.table`, `plyr`, and `dplyr` already, please install them before running the [`run analysis.R` script](https://github.com/hildot/03GCDTidyData/blob/master/run_analysis.R)

```
install.packages("data.table")
install.packages("plyr")
install.packages("dplyr")
```

# Using the R Script
The `run_analysis.R` script can be ran as is from R or R Studio, assuming you have installed the aforementioned packages to your machine already. The R script will automatically download a copy of the necessary files to your machine and create a tidy dataset on its own. 

# Original Data 
The [UCI HAR Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) include information recorded from the accelerometers (measuring acceleration) and gyroscopes (measuring angular velocity) of the Samsung Galaxy S smartphone. Each measurement criteria is referred to as a `feature` in this document and in the original data files. For further details about the dataset, please see [`Codebook.md`](https://github.com/hildot/03GCDTidyData/blob/master/Codebook.md). 

# Tidy Data
The [tidy data](https://s3.amazonaws.com/coursera-uploads/user-49bc5d7654808cf1dbb403b3/975114/asst-3/5ea5383030b811e5afb6036dd93d02fd.txt) (180 rows, 68 columns) cleans the [UCI HAR Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). The [tidy data](https://s3.amazonaws.com/coursera-uploads/user-49bc5d7654808cf1dbb403b3/975114/asst-3/432a3ec030a411e5a73b8fcd88c40806.txt) combines the eight original data files into one file that is ready for further analysis.  

The [tidy data](https://s3.amazonaws.com/coursera-uploads/user-49bc5d7654808cf1dbb403b3/975114/asst-3/432a3ec030a411e5a73b8fcd88c40806.txt) file omits measures that are not relevant to the study at hand and calculates means for each `subject's` readings for each `activity` completed. 

# Disclaimer 
The tidy data set and the `run_analysis.R` script have been created by the author, H. Dotson, to fulfil course requirements in "Getting and Cleaning Data", a Coursera class. At the conclusion of the course, this repository will be deleted from Github. 

# References
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

```{r, include = FALSE}
file.rename(from = "tidydatareadme.Rmd",
            to="README.md")
```