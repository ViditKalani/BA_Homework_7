library(tidyverse)
library(caret)
library(mlbench)
library(glmnet)
library(glmnetUtils)

# read_csv("/Users/vidit/Desktop/Masters/Sem_3/MSCS 6520/Homework7/spam_data.csv")

spam_data <- read_csv("/Users/vidit/Desktop/Masters/Sem_3/MSCS 6520/Homework7/spam_data.csv")

spam_data <- as.tibble(spam_data)
spam_data <- mutate(spam_data, label = as.factor(label))
head(spam_data)

set.seed(221)
trainIndex <- createDataPartition(spam_data$label, p = 0.8, list = FALSE, times = 1)

spam_data[trainIndex, ]
spamTrain <- spam_data[trainIndex, ]

spam_data[-trainIndex, ]
spamTest <- spam_data[-trainIndex, ]

preProcess(spamTrain, method = c("center", "scale"))
scaler <- preProcess(spamTrain, method = c("center", "scale"))

predict(scaler, spamTrain)
spamTrain <- predict(scaler, spamTrain)
predict(scaler, spamTest)
spamTest <- predict(scaler, spamTest)

# Round: 1

lr <- glmnet(label ~ .,
             data = spamTrain,
             family = "binomial",
             na.action = na.pass)
predictions <- predict(lr,
                       spamTest,
                       type = "class",
                       na.action = na.pass,
                       s = 0.01)
predictions1 <- predict(lr,
                        spamTest,
                        type = "response",
                        na.action = na.pass,
                        s = 0.01)

head(predictions)
head(predictions1)
confusionMatrix(as.factor(predictions),
                spamTest$label)


T <- spam_data$label
P <- sample(spam_data$label)

confusionMatrix(P, T)
prop.table(table(P,T))
           

