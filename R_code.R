#https://www.kaggle.com/code/wiramahatvavirya/loan-approval-analysis-prediction/notebook

# Load necessary libraries
library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)
library(caTools)


# Function to install and load required packages
install_and_load_packages <- function(packages) {
  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg)
    }
    library(pkg, character.only = TRUE)
  }
}

# Define required packages
required_packages <- c("tidyverse", "caret", "rpart", "rpart.plot", "caTools")
install_and_load_packages(required_packages)

# Create a sample dataset named df
set.seed(123) # For reproducibility
n <- 1000 # Number of observations

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Load dataset from the same folder
df <- read.csv("loan_data.csv")

df <- data.frame(
  person_age = sample(18:70, n, replace = TRUE),
  person_gender = sample(c("male", "female"), n, replace = TRUE),
  person_education = sample(c("High School", "Bachelor", "Master"), n, replace = TRUE),
  person_income = sample(30000:120000, n, replace = TRUE),
  person_emp_exp = sample(0:40, n, replace = TRUE),
  person_home_ownership = sample(c("RENT", "OWN", "MORTGAGE"), n, replace = TRUE),
  loan_amnt = sample(5000:50000, n, replace = TRUE),
  loan_intent = sample(c("PERSONAL", "EDUCATION", "MEDICAL"), n, replace = TRUE),
  loan_int_rate = runif(n, 3.5, 15), # Interest rate between 3.5% and 15%
  loan_percent_income = runif(n, 5, 50), # Loan amount as a percentage of income
  cb_person_cred_hist_length = sample(1:30, n, replace = TRUE),
  credit_score = sample(300:850, n, replace = TRUE),
  previous_loan_defaults_on_file = sample(c("Yes", "No"), n, replace = TRUE),
  loan_status = sample(c(0, 1), n, replace = TRUE) # Target variable (0 or 1)
)

# Data Preprocessing
df <- df %>%
  mutate(isLoanOriginated = ifelse(loan_status == 1, TRUE, FALSE)) %>%
  select(-loan_status)

# Convert categorical variables to factors
df <- df %>%
  mutate(across(where(is.character), as.factor))

# Exploratory Data Analysis (EDA)

## Gender Distribution
ggplot(df %>% group_by(person_gender) %>% summarise(Count=n()), aes(x=person_gender, y=Count)) +
  geom_bar(stat='identity', fill='blue') +
  labs(title='Gender Distribution of Loan Applicants', x='Gender', y='Count') +
  theme_minimal()

## Age Distribution
ggplot(df, aes(x=person_age)) +
  geom_histogram(binwidth=5, fill='green', color='black') +
  labs(title='Age Distribution of Loan Applicants', x='Age', y='Count') +
  theme_minimal()

## Loan Amount Distribution
ggplot(df, aes(x=loan_amnt)) +
  geom_histogram(binwidth=1000, fill='orange', color='black') +
  labs(title='Loan Amount Distribution', x='Loan Amount (USD)', y='Count') +
  theme_minimal()

## Home Ownership Status
ggplot(df %>% group_by(person_home_ownership) %>% summarise(Count=n()), aes(x=person_home_ownership, y=Count)) +
  geom_bar(stat='identity', fill='purple') +
  labs(title='Home Ownership Status of Loan Applicants', x='Home Ownership Status', y='Count') +
  theme_minimal()

# Split the dataset into training and testing sets
set.seed(3000)
split <- sample.split(df$isLoanOriginated, SplitRatio=0.7)
Train <- subset(df, split == TRUE)
Test <- subset(df, split == FALSE)

# Build a CART model
loanTree <- rpart(isLoanOriginated ~ ., method="class", data=Train,
                  control=rpart.control(minbucket=5))

# Visualize the decision tree
prp(loanTree)

# Predict on the test set
predictions <- predict(loanTree, newdata=Test, type="class")

# Ensure both predictions and Test$isLoanOriginated are factors with the same levels
predictions <- factor(predictions, levels=c(TRUE, FALSE))
Test$isLoanOriginated <- factor(Test$isLoanOriginated, levels=c(TRUE, FALSE))

# Evaluate the model's performance using confusion matrix
confusionMatrix(predictions, Test$isLoanOriginated)

# Feature importance using caret's train function with XGBoost
fitControl <- trainControl(method="cv", number=10)
xgbGrid <- expand.grid(nrounds=100,
                       max_depth=3,
                       eta=.05,
                       gamma=0,
                       colsample_bytree=.8,
                       min_child_weight=1,
                       subsample=1)

set.seed(13)
df$isLoanOriginated <- as.factor(df$isLoanOriginated)

loanXGB <- train(isLoanOriginated ~ ., data=df,
                 method="xgbTree",
                 trControl=fitControl,
                 tuneGrid=xgbGrid)

# Variable importance plot
importance <- varImp(loanXGB)
varImportance <- data.frame(Variables=row.names(importance[[1]]),
                            Importance=round(importance[[1]]$Overall,2))

ggplot(varImportance, aes(x=reorder(Variables, Importance), y=Importance)) +
  geom_bar(stat='identity', colour="white", fill="blue") +
  coord_flip() +
  labs(x='Variables', title='Relative Variable Importance') +
  theme_bw()

