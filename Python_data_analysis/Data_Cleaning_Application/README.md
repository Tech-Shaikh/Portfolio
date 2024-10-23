# Data Cleaning Application - Project Documentation
## Overview
This Python script performs basic data cleaning operations such as removing duplicates and handling missing values on a dataset also allow users to choose a custom strategy, and better error handling for invalid file content. and save the cleaned data into new files. It is for the  people who regularly use data and discover that they need to clean it up some basic operation. In addition to processing CSV files, the program can also handle Excel 2007 (.xlsx) and older Excel 2003 (.xls) files. 

## Key Features
- File Format Support:
  - Handles CSV, Excel (.xlsx), and Excel (.xls) file formats.
  - Automatically detects the file format based on the provided file extension.
- Duplicate Handling:
  - Identifies and reports duplicate records in the dataset.
  - Saves duplicate records to a separate file (*_duplicate.csv).
  - Removes duplicate rows from the dataset.
- Missing Value Handling:
  - Numerical columns: Users can choose between filling missing values with mean, median, mode, or dropping rows entirely.
 - Categorical columns: Users can choose between dropping rows with missing values or filling with the mode (most frequent value).
- Cleaned Data Export:
 -- Exports cleaned data to a new CSV file (*_cleaned_data.csv).
- Error Handling:
  - Checks for valid file paths and formats.
 - Catches and reports errors when loading invalid or corrupted files.

## Usage Flow:
- The user is prompted to enter the file path and file name.
- The script validates the file format, checks if it’s a valid path, and loads the dataset.
- Duplicates are identified, reported, and saved to a separate file.
- The user is prompted to choose how to handle missing values for both numerical and categorical columns.
- The script processes the data accordingly and saves the cleaned dataset to a new file.
