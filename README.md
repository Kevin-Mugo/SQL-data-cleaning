# SQL-data-cleaning
This repository shows a step by step data cleaning from on a dataset using SQL

## Introduction

This repository contains the code and documentation for the data cleaning process on a layoffs dataset. The primary goal of this project is to clean and enhance the dataset by removing duplicates , standardizing the data , handling null values and dropping irrelevant rows and columns for further EDA processes.

## Dataset Source and Overview

The layoffs dataset used in this project was obtained from kaggle notebooks. It consists of  attributes such as company , location , industry ,total_laid,date , stage country and funds_raised .

The  dataset contains 2k+ records of layoffs data. Each record represents a layoff instance.

## Issues Found in the Data

During the initial exploration and analysis of the  dataset, several issues were identified, including:

- **Duplicate values:** There were 5 rows of  duplicates.
- **Missing values:** The 'Percenatge_laid_off' , 'Total_laid_off' , and 'country' columns had missing values that required careful handling and computation.
- **Inconsistent formatting:** This was observed across different 'industry' and 'country' making it necessary to standardize the data for consistency.

## Tools Used

For the data cleaning project, the following tools and libraries were used:

- **SQL:** for data cleaning tasks.
- **MySQL workbench :** instrumental in SQL development and modelling.

## Data Cleaning Process

The data cleaning process involved the following steps:

1. **Data Import:** The dataset was in a csv format , I Imported to the the SQL database.
   
2. **Data Understanding:** The dataset was thoroughly examined to understand the structure, columns, and their meanings. The dataset  had a data dictionary attached from the  online source, This helped me gain an understanding of what all the columns represented.

3. **Data Staging:** I created a data staging area  to avoid working with the original dataset.

4. **Handling duplicates:** By utilizing SQL window functions , CTEs and the ROWNUMBER() function I partioned all the entries and identified 5 duplicate columns. I handled this y dropping them.
   
5. **Handling missing values:** The "industry" column had a null values for various corresponding companies ie Some of company 'Airbnb' had missing industry , this would be filled with the correspondent "Travel" industry like any other rows. The same was identified for 'Transportation' and "Consumer" industries and necessary updates performed.
   
6. **Standardizing data:**
 Perfoming a check on all companies there were whitespaces , I removed using the TRIM() function. 
 Inconsistent formatting issues in the "Cryptocurrency" industry which had 3 different indusrty , which I handled by concatenating into one industry I named as Crypto.
 There was also two instances of United States in country due to one having a fullstop and one not having . I also handled this with advanced TRIM() function and utilizing the "trailing 
 "argument to remove the fullstop and have a single entry for that.
 Having imported the data from a csv file, the "date" column was a "text" format rather than "date" format. I handled this to make it suitable for time series analysis.

7. **Validation and quality checks:** The cleaned dataset underwent rigorous validation to ensure the quality, accuracy, and integrity of the data.

## Documentation

For detailed information about the data cleaning process, please refer to the SQL file provided in this repository.





