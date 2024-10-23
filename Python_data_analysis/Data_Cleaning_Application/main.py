# Import necessary libraries
import pandas as pd  # For data manipulation
import numpy as np   # For numerical operations
import openpyxl      # For handling Excel files (.xlsx)
import xlrd          # For handling older Excel files (.xls)
import time          # For adding delays
import random        # For generating random time delays
import os            # For handling file path operations


def Data_Cleaning_Application(file_path, file_name):
    """
    Cleans the dataset provided by the user by removing duplicates and handling missing values.

    Parameters:
    file_path (str): Full path to the dataset (CSV, Excel file, or older Excel format .xls)
    file_name (str): Name of the dataset (used for saving output files)

    Steps performed:
    - Checks file existence and format (CSV/Excel/.xls)
    - Removes duplicates and saves duplicate records to a file
    - Offers options for handling missing values (fill with mean, median, or mode for numerical columns, or drop rows for categorical)
    - Saves cleaned data to a new file
    """
    
    # Acknowledgement and brief delay to simulate processing time
    print("Thank you for sharing the dataset!")
    sec = random.randint(1, 4)  # Random delay between 1 to 4 seconds
    print(f"Please wait {sec} seconds! Checking file format...")
    time.sleep(sec)
    
    # Check if the file path exists
    if not os.path.exists(file_path):
        print("Error: Please enter the correct file path!")
        return
    
    # Identify the file format and load the dataset
    try:
        if file_path.endswith('.csv'):
            print("File format detected: CSV")
            data = pd.read_csv(file_path, encoding_errors='ignore')
            
        elif file_path.endswith('.xlsx'):
            print("File format detected: Excel (.xlsx)")
            data = pd.read_excel(file_path)
            
        elif file_path.endswith('.xls'):
            print("File format detected: Excel (.xls)")
            data = pd.read_excel(file_path, engine='xlrd')
            
        else:
            print("Error: Unknown file format! Supported formats are CSV, Excel (.xlsx), and Excel (.xls)")
            return
    except Exception as e:
        print(f"Error loading file: {e}")
        return

    # Display dataset dimensions (rows and columns)
    print(f"Number of rows: {data.shape[0]} \nNumber of columns: {data.shape[1]}")

    # Cleaning Process Begins
    print("Starting data cleaning process...")

    # 1. Duplicate Handling
    total_duplicates = data.duplicated().sum()
    print(f"Total duplicate records: {total_duplicates}")

    if total_duplicates > 0:
        # Save duplicate records to a new CSV file
        duplicate_records = data[data.duplicated()]
        duplicate_records.to_csv(f'{file_name}_duplicate.csv', index=False)
        print(f"Duplicate records saved to '{file_name}_duplicate.csv'")

    # Remove duplicate records
    cleaned_data = data.drop_duplicates()

    # 2. Missing Data Handling
    total_missing_records = cleaned_data.isnull().sum().sum()
    column_wise_missing_values = cleaned_data.isnull().sum()

    print(f"Total missing records: {total_missing_records}")
    print(f"Column-wise missing values:\n{column_wise_missing_values}")

    # Prompt user to choose how to handle missing values for numerical and non-numerical columns
    print("\nHow would you like to handle missing values in numerical columns?")
    print("1. Fill with mean")
    print("2. Fill with median")
    print("3. Fill with mode")
    print("4. Drop rows with missing values")
    choice_numeric = input("Enter your choice (1/2/3/4): ")

    if choice_numeric not in ['1', '2', '3', '4']:
        print("Invalid choice! Defaulting to filling with mean.")
        choice_numeric = '1'

    print("\nHow would you like to handle missing values in non-numerical (categorical) columns?")
    print("1. Drop rows with missing values")
    print("2. Fill with most frequent value (mode)")
    choice_categorical = input("Enter your choice (1/2): ")

    if choice_categorical not in ['1', '2']:
        print("Invalid choice! Defaulting to dropping rows with missing values.")
        choice_categorical = '1'

    print("Handling missing values... Please wait.")
    sec = random.randint(1, 4)
    time.sleep(sec)

    for col in cleaned_data.columns:
        if cleaned_data[col].dtype in ('int64', 'float64'):
            # Handle numerical columns based on user choice
            if choice_numeric == '1':
                cleaned_data[col] = cleaned_data[col].fillna(cleaned_data[col].mean())
            elif choice_numeric == '2':
                cleaned_data[col] = cleaned_data[col].fillna(cleaned_data[col].median())
            elif choice_numeric == '3':
                cleaned_data[col] = cleaned_data[col].fillna(cleaned_data[col].mode()[0])
            elif choice_numeric == '4':
                cleaned_data.dropna(subset=[col], inplace=True)
        else:
            # Handle categorical columns based on user choice
            if choice_categorical == '1':
                cleaned_data.dropna(subset=[col], inplace=True)
            elif choice_categorical == '2':
                cleaned_data[col] = cleaned_data[col].fillna(cleaned_data[col].mode()[0])

    # Final status after cleaning
    print(f"Data cleaning completed! \nNumber of rows: {cleaned_data.shape[0]} \nNumber of columns: {cleaned_data.shape[1]}")

    # Save cleaned data to a new file
    cleaned_data.to_csv(f"{file_name}_cleaned_data.csv", index=False)
    print(f"Cleaned dataset saved as '{file_name}_cleaned_data.csv'. You can check it now!")


if __name__ == "__main__":
    # User Input for file path and file name
    print("Welcome to the Data Cleaning Master")
    file_path = input("Please enter the dataset path: ")
    file_name = input("Please enter the dataset name (without extension): ")

    # Call the Data Cleaning Application
    Data_Cleaning_Application('file_path', 'file_name')