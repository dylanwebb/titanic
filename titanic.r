# train and test are available in the workspace
train_url <- "http://s3.amazonaws.com/assets.datacamp.com/course/Kaggle/train.csv"
train <- read.csv(train_url)

test_url <- "http://s3.amazonaws.com/assets.datacamp.com/course/Kaggle/test.csv"
test <- read.csv(test_url)

# Load in the packages
install.packages("randomForest")
library(randomForest)
install.packages("stringr")        
library(stringr)

# Creat new variable: Title which is the passengers title
Title <- str_match(train$Name, ".+, ([a-zA-Z\\.]+).+")
train_2 <- train
train_2$Title <- Title
test_2 <- test_2
test_2$Title < Title

# Set seed for reproducibility
set.seed(111)


# Apply the Random Forest Algorithm
my_forest <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title,
                          data = train, importance = TRUE, ntree = 1000)

# Make your prediction using the test set
my_prediction <- predict(my_forest, test)

# Create a data frame with two columns: PassengerId & Survived. Survived contains your predictions
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = my_prediction)

# Write your solution away to a csv file with the name my_solution.csv
write.csv(my_solution, file = "my_solution.csv", row.names = FALSE)