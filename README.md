# Loan Approval Analysis and Prediction

## Overview
This project aims to analyze loan approval data and build a predictive model to determine whether a loan application will be approved or denied. The analysis includes exploratory data analysis (EDA) and the implementation of machine learning algorithms to predict loan approval outcomes.

## Features
The dataset contains the following features:

- **person_age**: Age of the loan applicant in years.
- **person_gender**: Gender of the loan applicant (male or female).
- **person_education**: Education level of the loan applicant (e.g., High School, Bachelor, Master).
- **person_income**: Annual income of the loan applicant (in USD).
- **person_emp_exp**: Number of years of employment experience of the applicant.
- **person_home_ownership**: Home ownership status of the applicant (e.g., RENT, OWN, MORTGAGE).
- **loan_amnt**: Amount of loan requested (in USD).
- **loan_intent**: The purpose or intent of the loan (e.g., PERSONAL, EDUCATION, MEDICAL).
- **loan_int_rate**: Interest rate of the loan (as a percentage).
- **loan_percent_income**: Loan amount as a percentage of the applicant's annual income.
- **cb_person_cred_hist_length**: Length of the applicant's credit history (in years).
- **credit_score**: Credit score of the applicant.
- **previous_loan_defaults_on_file**: Whether the applicant has previous loan defaults on record (Yes or No).
- **loan_status**: Target variable indicating whether the loan was approved (1) or denied (0).

## Installation
To run this project locally, ensure you have R and RStudio installed. You will also need to install the following R packages:

```r
install.packages(c("tidyverse", "caret", "rpart", "rpart.plot", "caTools"))
```
## Usage
Clone this repository or download the notebook file.
Place your dataset in the same directory as your R script or notebook.
Open RStudio and set your working directory to where your files are located.
Run the provided R script or notebook cells to perform EDA and build the predictive model.

## EDA Visualizations
The project includes various visualizations to explore relationships between features and loan approval outcomes, such as:
Gender distribution of applicants.
Age distribution of applicants.
Loan amount distribution.
Home ownership status analysis.

## License
This project is licensed under the MIT License 
