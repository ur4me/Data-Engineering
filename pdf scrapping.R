Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_171') 

library(rJava) # load and attach 'rJava' no
library(tabulizer)
library(lubridate)
library(randomForest)
library(ggplot2)
library(stringr)




# call recent passenger history
report <- "http://www.queenstownairport.com/assets/documents/ZQN-monthly-passengers-2016-to-2018-Apr.pdf" 
lst <- extract_tables(report, encoding="UTF-8") 

# call past passenger history
recent <- data.frame(date = lst[[1]][,5], total =lst[[1]][,10])
recent <- recent[3:30,]
recent$date <- str_sub(recent$date,-6,-1)


# call recent passenger history
report <- "http://www.queenstownairport.com/assets/documents/ZQN-monthly-passengers-2011-to-2015.pdf" 
lst <- extract_tables(report, encoding="UTF-8") 

# call past passenger history
past <- data.frame(date = lst[[1]][,4], total =lst[[1]][,7])
past <- past[3:62,]

airport <- rbind(past,recent)


#change data type
airport$date <- paste0(paste(substr(airport$date,1,3),20),substr(airport$date,5,6))

airport$date <- paste('15', airport$date)

airport$date <- as.Date(airport$date,format='%d %B %Y')

airport$total <- as.numeric(as.character(gsub(",", "", airport$total)))


#save
#write.csv(airport, file = 'C:/Intercity/Data/airport.csv', row.names = F)


#using Ensemble
#feature engineering
#airport$week.in.year <- week(airport$date)
#airport$month <- month(airport$date)
#airport$day.of.week <- weekdays(as.Date(airport$date))
airport$day.in.year <- yday(airport$date)
#airport$day.of.week <- as.factor(airport$day.of.week)


#split
train <- airport[1:round(nrow(airport)*0.7), ]
test <- airport[(round(nrow(airport)*0.7)+1):nrow(airport), ]



#modeling
train$date2 <- as.numeric(train$date)^2
test$date2 <- as.numeric(test$date)^2

lm <- lm(total ~ date + date2, train)
train$OV <- train$total - predict(lm,train)


set.seed(1234)
rf <- randomForest(OV ~.,train%>%select(day.in.year, OV))

prediction <- predict(rf,test)+predict(lm,test)


rf1 <- randomForest(total ~., train%>%select(-OV,-date2))

prediction1 <- predict(rf1,test)

#plot
total <- test %>% select(date, total)
total$Airport_Passengers <- 'Actual' 

total1 <- total
total1$total <- prediction
total1$Airport_Passengers <- 'Prediction with ensemble model'

total2 <- total
total2$total <- prediction1
total2$Airport_Passengers <- 'Prediction with RF'



total <- rbind(total,total1,total2)


# Plot
ggplot(data=total, aes(x=date, y=total, group=Airport_Passengers, colour=Airport_Passengers)) +
  geom_line() 


#evalumation
mean(abs(test$total - prediction), na.rm=TRUE) #3332.974

rsq <- function(x, y) summary(lm(y~x))$r.squared
rsq(test$total, prediction) #0.94192

cor(prediction , test$total) #0.9705256






