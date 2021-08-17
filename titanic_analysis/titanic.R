##############################################
## Preamble: This is where we set-up 
## our working space
##############################################

## Set working directory
setwd('/Project SPARTA/titanic')

## Load the needed libraries
library(readr)
library(dplyr)
library(ggplot2)
library(ggtext)
library(caret)

## Read the data
train <- read_csv('train.csv')

##############################################
## EDA: This is where we get to know more 
## about our data
##############################################

## Print the first 10 rows of the train set
head(train, 10)

## Print the number of nulls in train set
sapply(train, m <- function(x) {mean(is.na(x))})
sapply(train, m <- function(x) {sum(is.na(x))})

## Drop unnecessary columns
d_cols <- c('Name', 'Ticket', 'Cabin')
train[, d_cols] <- list(NULL)

## Set default ggplot theme and settings
theme_set(theme_minimal())
theme_replace(plot.title = element_markdown(size = 20, face= "bold", hjust=0),
              plot.subtitle = element_markdown(size = 16, hjust=0),
              legend.position = 'none',
              plot.margin = margin(4,2,2,4, unit = 'mm'))

## Group by survived and passenger class
suv_by_class <- train %>%
        group_by(Pclass) %>%
        summarise(r=sum(Survived)/n())

## Create bar graph of survival rate per class
suv_by_class %>%
        ggplot(aes(x=Pclass, y=r)) + 
        geom_bar(stat='identity', fill=c('#00B0F0', 'grey30', 'grey30')) +
        coord_flip() +
        scale_x_continuous(minor_breaks = NULL) +
        scale_y_continuous(minor_breaks = NULL, limits = c(0, 1), breaks=seq(0, 1, 0.5)) +
        labs(x='Passenger Class', y='Survival%', 
             title='Survival rate is <span style="color:#00B0F0">higher for high class passengers (63%)</span>',
             subtitle='<b>While only 47% and 24% survived</b> from classes 2 and 3 respectively') +
        geom_text(aes(label=paste0(round(r, 2) * 100, '%')), hjust=-1)

## Save plot
ggsave('suv_by_class.svg', width=10.4, height=6.2)
ggsave('suv_by_class.png', width=10.4, height=6.2)

## Create boxplot of fare grouped by `Survived`
train %>%
        mutate(Survived = ifelse(Survived == 1, 'Survived', 'Didn\'t survive')) %>%
        ggplot(aes(x=Fare)) + 
        geom_boxplot(aes(fill=Survived), color='grey70') +
        theme(legend.position='bottom', legend.title = NULL) + 
        scale_fill_manual(values=c('#FF6363', '#00B0F0')) + 
        scale_x_continuous(minor_breaks=NULL) +
        scale_y_continuous(breaks=NULL, minor_breaks=NULL) +
        labs(title='Those people who paid <span style="color:#00B0F0">higher fares</span> had more chances of surviving',
             subtitle='While majority of those who didn\'t survive <span style="color:#FF6363"><b>had paid lower fares</b></span>')

## Save plot
ggsave('suv_by_fare.svg', width=10.4, height=6.2)
ggsave('suv_by_fare.png', width=10.4, height=6.2)

## Group by survived and passenger class
suv_by_sex <- train %>%
        group_by(Sex) %>%
        summarise(r=sum(Survived)/n())
        
## Create bar graph of survival rate per sex
suv_by_sex %>%
        ggplot(aes(x=Sex, y=r)) +
        geom_bar(stat='identity', fill=c('#FF6363','#00B0F0')) +
        coord_flip() +
        scale_y_continuous(minor_breaks = NULL, limits = c(0, 1), breaks=seq(0, 1, 0.5)) +
        labs(x='Sex', y='Survival%', 
             title='Survival rate is <span style="color:#FF6363">higher on females</span> than males',
             subtitle='Per the movie, <b>women and children got on to rubber boats first</b> before males') +
        geom_text(aes(label=paste0(round(r, 2) * 100, '%')), hjust=-1)

## Save plot
ggsave('suv_by_sex.svg', width=10.4, height=6.2)
ggsave('suv_by_sex.png', width=10.4, height=6.2)

## Create boxplot of age grouped by `Survived`
train %>%
        mutate(Survived = ifelse(Survived == 1, 'Survived', 'Didn\'t survive')) %>%
        ggplot(aes(x=Age)) + 
        geom_boxplot(aes(fill=Survived), color='grey70') +
        theme(legend.position='bottom', legend.title = NULL) + 
        scale_fill_manual(values=c('#FF6363', '#00B0F0')) + 
        scale_x_continuous(minor_breaks=NULL) +
        scale_y_continuous(breaks=NULL, minor_breaks=NULL) +
        labs(title='The boxplots seem to show similar distribution with slight overlaps',
             subtitle='<span style="color:#00B0F0"><b>Majority of the survivors are younger</b></span> than those who didn\'t survive by a couple of years')

## Save plot
ggsave('suv_by_age.svg', width=10.4, height=6.2)
ggsave('suv_by_age.png', width=10.4, height=6.2)

## Perform t-test on age as comparison
train_t_test <- train %>%
        select(Survived, Age) %>%
        filter(!is.na(Age))

age_1 <- train_t_test %>%
        filter(Survived == 1) %>%
        select(Age)

age_0 <- train_t_test %>%
        filter(Survived == 0) %>%
        select(Age)

## In terms of mean, the difference 
## in means is not equal to 0
## This also proves that survivors are 
## younger than those who didn't survive
## by couple of years
t.test(x=age_0, y=age_1)

## In terms of statistical relevance
## based on logistic regression, Age is significant
summary(glm(Survived~Age, train_t_test, family='binomial'))$coef

## Group by survived and number of siblings/spouse
suv_by_sibsp <- train %>%
        group_by(SibSp) %>%
        summarise(r=sum(Survived)/n())

## Group by survived and number of parent/children
suv_by_parch <- train %>%
        group_by(Parch) %>%
        summarise(r=sum(Survived)/n())

## Group by survived and embarked
## NAs were replaced by mode ('S')
train %>% 
        mutate(Embarked = ifelse(is.na(Embarked), 'S', Embarked)) %>%
        group_by(Embarked) %>%
        summarise(r=sum(Survived)/n()) -> suv_by_emb

## SibSp survival rate
f1 <- suv_by_sibsp %>%
        ggplot(aes(x=SibSp, y=r)) + 
        geom_bar(stat='identity') +
        scale_x_continuous(minor_breaks = NULL, breaks=seq(0, 8, 1)) +
        scale_y_continuous(minor_breaks = NULL, limits = c(0, 1), breaks=seq(0, 1, 0.5)) +
        labs(x='Siblings/Spouse count', y='Survival%') + 
        geom_text(aes(label=paste0(round(r, 2) * 100, '%')), vjust=-1)

## Parch survival rate
f2 <- suv_by_parch %>%
        ggplot(aes(x=Parch, y=r)) + 
        geom_bar(stat='identity') +
        scale_x_continuous(minor_breaks = NULL, breaks=seq(0, 6, 1)) +
        scale_y_continuous(minor_breaks = NULL, limits = c(0, 1), breaks=seq(0, 1, 0.5)) +
        labs(x='Parent/Children count', y='Survival%') + 
        geom_text(aes(label=paste0(round(r, 2) * 100, '%')), vjust=-1)

## Embarked survival rate
f3 <- suv_by_emb %>%
        ggplot(aes(x=Embarked, y=r)) + 
        geom_bar(stat='identity') +
        scale_y_continuous(minor_breaks = NULL, limits = c(0, 1), breaks=seq(0, 1, 0.5)) +
        labs(x='Embarked', y='Survival%') + 
        geom_text(aes(label=paste0(round(r, 2) * 100, '%')), vjust=-1)

## Visualize f1 and f2
ggpubr::ggarrange(f1, f2, f3, 
                  labels = c('SibSp Survival%', 'Parch Survival%', 'Embarked Survival%'),
                  nrow=3)

## Save plot
ggsave('suv_by_rest.svg', width=10.4, height=7)
ggsave('suv_by_rest.png', width=10.4, height=7)

##############################################
## Data cleaning: This is where we clean
## the data by handling missing values and 
## by doing some feature engineering
##############################################

## Handling missing age values
random_range_encoder <- function(rang) {
        
        ## This function encodes missing values
        ## with a random number based from the 
        ## minimum and maximum value of the 
        ## data.
        
        x_min <- min(rang, na.rm = T)
        x_max <- max(rang, na.rm = T)
        
        sapply(rang, imputer <- function(x) {
                if (is.na(x)) {
                        return(runif(1, x_min, x_max))
                } else {
                        return(x)
                }
        })
        
}

## Visualize the distribution of age 
## before imputation
q1 <- train %>% 
        ggplot(aes(x=Age)) + 
        geom_density(size=1, fill='steelblue')

## Setting seed for reproducibility
set.seed(123)

## Impute missing age values
train$Age <- random_range_encoder(train$Age)

## Visualize the distribution of age 
## after imputation
q2 <- train %>% 
        ggplot(aes(x=Age)) + 
        geom_density(size=1, fill='steelblue')

## Display both plots
ggpubr::ggarrange(q1, q2, labels=c('Before random imputation', 'After random imputation'))

## There maybe some changes but the distribution
## Still looked similar

## Save plot
ggsave('age_ba_impute.svg', width=10.4, height=6.2)
ggsave('age_ba_impute.png', width=10.4, height=6.2)

## Recode sex to binary
train$Sex <- ifelse(tolower(train$Sex) == 'female', 1, 0)

## Dummy variables for Embarked (reference='Q')
## Replace NA with mode='S'
train$Embarked <- ifelse(is.na(train$Embarked), 'S', train$Embarked)
train$emb_s <- ifelse(train$Embarked == 'S', 1, 0)
train$emb_c <- ifelse(train$Embarked == 'C', 1, 0)
train[, 'Embarked'] <- list(NULL)

## Change to factor
train$Survived <- factor(train$Survived)

## Remove PassengerId
train[, 1] <- list(NULL)

## Save a copy of complete cleaned data
train_set_0 <- train

## Data with personally selected features
d_cols <- c('Pclass', 'Parch', 'emb_s', 'emb_c')
train[, d_cols] <- list(NULL)

## Get feature importance
set.seed(123)
tr <- trainControl(method='repeatedcv', number=10, repeats=10)
rf_0 <- train(Survived~., data=train_set_0, method='rpart', trControl=tr)
rf_1 <- train(Survived~., data=train, method='rpart', trControl=tr)

vi_0 <- data.frame(
        vars=row.names(varImp(rf_0, scale=FALSE)$importance), 
        varImp(rf_0, scale=FALSE)$importance, 
        row.names = NULL)

vi_1 <- data.frame(
        vars=row.names(varImp(rf_1, scale=FALSE)$importance), 
        varImp(rf_1, scale=FALSE)$importance, 
        row.names = NULL)

v0 <- vi_0 %>% 
        ggplot(aes(x=reorder(vars, Overall), y=Overall)) +
        geom_bar(stat='identity') + 
        coord_flip() + 
        labs(x='variables')

v1 <- vi_1 %>%
        ggplot(aes(x=reorder(vars, Overall), y=Overall)) + 
        geom_bar(stat='identity') +
        coord_flip() +
        labs(x='variables')

ggpubr::ggarrange(v0, v1, nrow=2, labels=c('All features', 'Personally selected features'))

## Save plot
ggsave('var_imp.svg', width=10.4, height=6.2)
ggsave('var_imp.png', width=10.4, height=6.2)

## Final features
train <- train_set_0[, c('Survived', 'Sex', 'Pclass', 'Fare')]

##############################################
## Modeling: This is where we develop
## the model that we will use in 
## predicting passenger survival
##############################################

## Segregate the survivors from those who 
## didn't make it 
suv_0 <- filter(train, Survived == 0)
suv_1 <- filter(train, Survived == 1)

## Set seed for reproducibility
set.seed(123)

## Perform undersampling since we have
## less survivors
suv_0_part <- sample(1:dim(suv_0)[1], dim(suv_1)[1])
suv_0_sam <- suv_0[suv_0_part, ]
suv_0_rem <- suv_0[-suv_0_part, ] ## we'll use this later

## Merge the two dataframes
equal_data <- rbind(suv_1, suv_0_sam)

## Set seed for reproducibility
set.seed(123)

## Create data partition
train_index <- createDataPartition(equal_data$Survived, p=0.8, list=FALSE)
train_data <- equal_data[train_index, ]
val_data <- equal_data[-train_index, ]

## Define train control
tr <- trainControl(method='repeatedcv', number=10, repeats=10)

## Build logistic regression
logit <- train(Survived~., data=train_data, method='glm', family='binomial')

## Accuracy on training data
confusionMatrix(data=predict(logit), reference=train_data$Survived)

## Accuracy on validation
confusionMatrix(data=predict(logit, newdata=val_data[, -1]), reference=val_data$Survived)

## Build decision tree (for classification, outcome must be a factor)
tree <- train(Survived~., data=train_data, method='treebag', trControl=tr)

## Accuracy on training data (for classification, outcome must be a factor)
confusionMatrix(data=predict(tree), reference=train_data$Survived)

## Accuracy on validation data (for classification, outcome must be a factor)
confusionMatrix(data=predict(tree, newdata=val_data[, -1]), reference=val_data$Survived)

## Build random forest (for classification, outcome must be a factor)
set.seed(123)
rf <- train(Survived~., data=train_data, method='rpart', trControl=tr)

## Accuracy on training data (for classification, outcome must be a factor)
confusionMatrix(data=predict(rf), reference=train_data$Survived)

## Accuracy on validation data (for classification, outcome must be a factor)
confusionMatrix(data=predict(rf, newdata=val_data[, -1]), reference=val_data$Survived)

##############################################
## Testing: This is where we make our 
## Kaggle submission
##############################################

## Read test data
test <- read_csv('test.csv')

## Select and pre-process the features
test <- test %>% 
        select(PassengerId, Sex, Pclass, Fare) %>%
        mutate(Sex = ifelse(tolower(Sex) == 'female', 1, 0),
               Fare = ifelse(is.na(Fare), median(Fare, na.rm=T), Fare))

## Predict values
test$logit_pred <- as.numeric(as.character(predict(logit, newdata=test[, -1])))
test$tree_pred <- as.numeric(as.character(predict(tree, newdata=test[, -1])))
test$rf_pred <- as.numeric(as.character(predict(rf, newdata=test[, -1])))
test <- test %>% 
        mutate(ensemble_predict = ifelse((logit_pred + tree_pred + rf_pred)>2, 1, 0))

## Create CSV file for logistic regression predictions
test %>%
        mutate(Survived = logit_pred) %>%
        select(PassengerId, Survived) %>%
        write_csv(file='logit_predictions.csv', col_names = TRUE)

## Create CSV file for decision tree predictions
test %>%
        mutate(Survived = tree_pred) %>%
        select(PassengerId, Survived) %>%
        write_csv(file='tree_predictions.csv', col_names = TRUE)

## Create CSV file for random forest predictions
test %>%
        mutate(Survived = rf_pred) %>%
        select(PassengerId, Survived) %>%
        write_csv(file='rf_predictions.csv', col_names = TRUE)

## Create CSV file for ensemble predictions
test %>%
        mutate(Survived = ensemble_predict) %>%
        select(PassengerId, Survived) %>%
        write_csv(file='ensemble_predictions.csv', col_names = TRUE)
