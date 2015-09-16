getting_and_cleaning_data
=========================

This project folder contains project course deliverables:
* run_analysis.R: script that creates tidy data from the original dataset
* Codebook.md: detailed description of created datasets and transformation steps to create these
* tidydata.txt: final tidy data set

## Installation

1. Create a new folder 
2. Download run_analysis.R into newly created folder

In order to run run_analysis.R script, install reshape2 package.

## Run the script

1. Change working directory to be newly created folder where you've donwnoaded the script
2. In RStudio/RConsole type source("run_analysis.R")

The script runs. It downloads all required files from the internet and creates tidydata.txt in your working directory.

You can view data frames that are created during script's execution:
* train_ds: training data set includes subject id, activity id and 561 measures 
* test_ds: testing data set includes subject id, activity id and 561 measures
* ds: combined data set, combining train_ds and test_ds
* dsReduced: data set with reduced set of columns - only activity id, subject id and 79 measures
* dsReducedWActivityName: merged data set with activity labels; activity labels replacing activity id
* dsFinal: "normalized" data set with subject/activity pair and variable and its value
* dsFinalMean: data set with subject/activity and calculated means for all variables in dsFinal dataset