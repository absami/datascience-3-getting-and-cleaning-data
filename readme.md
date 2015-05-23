### Introduction
The data (located in the tidy_data.txt) is generated as an exercise for tidy data generation in the course "Getting and Cleaning data" offered by the faculty at Biostatistics at the Johns Hopkins Bloomberg School of Public Health. 


### Explanation of run_analysis.R script
As a requirement of the course project, a data cleaning script named `run_analysis.R` is created. In the first part, merging of data from the test and train dataset has been carried out. Data is read from the test and train datasets, and merged using the `rbind` commands. Activity names are read in from `activity_labels.txt` and appended to the data against its label. At various points in the discussion forum, it was pointed out by the CTAs, as well as it was my personal opinion too that the feature names found in the file `features.txt` are quite descriptive already and can make good variable names. Therefore I used the feature names in `features.txt` as variable names in the data.

Later, measurements related to the mean and standard deviation are extracted from the data. For each subject, and each activity carried out by that subject, the average of each variable is calculated. Data is then melted into a long format with "Each variable in one column" and "Each observation in its own row" rule. Finally, data is stored in the file `tidy_data.txt` using the `write.table` command with `row.names = FALSE` option.

### How to run the script
1. Download the UCI HAR Data set from here:
   [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
2. Unzip the downloaded dataset to your home directory. If you wish to select some other path, feel free to modify the run_analysis.R script.
3. Clone this repo.
4. Only one external package is required, namely the `reshape` package. You can install `reshape` package using

   install.packages("reshape")

5. Run the file, `run_analysis.R` using your preferred method / IDE. The script will take some time to work with the data and as a result, a file named `tidy_data.txt` is generated in the user's home directory.


### Output of the script
At the end of the script run, a file named `tidy_data.txt` is generated in the home directory by default. The script will also notify you of the path where the file has been saved.
Intermediate variables that may not be required anymore are cleaned off the workspace using `rm` commands. Some variables are delibrately left for user review. These variables are
`data`       - The original data
`final_data` - Original data with Subject and Activity variables appended
`d`          - 180 observations of 81 variables. Mean and Standard Deviation related data
`dmelt`      - Melted data from `d`, with four variable columns: Subject  |  Activity  |  Feature.Names  |  Means

### Citations
Data tidying concepts as found in the following document have been applied to clean the data
[http://vita.had.co.nz/papers/tidy-data.pdf](http://vita.had.co.nz/papers/tidy-data.pdf)

### Notes
The project is created in RStudio Version 0.98.1103, OS is Linux Ubuntu 15.04, R version 3.1.2.

