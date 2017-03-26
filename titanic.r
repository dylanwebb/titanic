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
library(rpart)

# Creat new variable: Title which is the passengers title
test$Survived <- NA
all_data <- rbind(train, test)
Title <- str_match(all_data$Name, ".+, ([a-zA-Z\\.]+).+")
all_data$Title <- as.factor(Title[ ,2])


# Fill in the NA values for all data
all_data$Embarked[c(62, 830)] <- "S"
all_data$Embarked <- factor(all_data$Embarked)
all_data$Fare[1044] <- median(all_data$Fare, na.rm = TRUE)
predicted_age <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title
                       , data = all_data[!is.na(all_data$Age),], method = "anova")
all_data$Age[is.na(all_data$Age)] <- predict(predicted_age
                                             , all_data[is.na(all_data$Age),])

# Split the data back into a train set and a test set
train <- all_data[1:891,]
test <- all_data[892:1309,]
test$Survived <- NULL

# Set seed for reproducibility
set.seed(111)

# Apply the Random Forest Algorithm
my_forest <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age 
                          + SibSp + Parch + Fare + Embarked + Title,
                          data = train, importance = TRUE, ntree = 1000)

# Make your prediction using the test set
my_prediction <- predict(my_forest, test)

# Create a data frame with two columns: PassengerId & predicted Survived.
my_solution <- data.frame(PassengerId = test$PassengerId, Survived = my_prediction)

# Write your solution away to a csv file with the name my_solution.csv
write.csv(my_solution, file = "my_solution.csv", row.names = FALSE)