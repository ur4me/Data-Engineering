
#retrieve cliflo weather data
weather <- data.frame(date = seq(as.Date('2017-05-01'), Sys.Date(),by = 1))

weather$maxtempC   <- as.numeric('')
weather$mintempC   <- as.numeric('')
weather$windspeedKmph   <- as.numeric('')
weather$winddirDegree   <-as.numeric('')
weather$weatherCode   <- as.numeric('')
weather$weatherDesc   <- as.character('')
weather$precipMM  <- as.numeric('')
weather$humidity   <- as.numeric('')
weather$visibility   <- as.numeric('')
weather$pressure   <- as.numeric('')
weather$cloudcover   <- as.numeric('')
weather$HeatIndexC   <- as.numeric('')
weather$WindGustKmph   <- as.numeric('')





for(n in 1:as.integer((Sys.Date()- as.Date('2017-05-01'))/30)){
  r <- GET(paste0(paste0(paste0("http://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=03e3833270494f358a940750182805&q=-36.818,174.935&tp=24&format=json&date=",as.Date('2017-05-01')+30*(n-1)),
                         "&enddate="),as.Date('2017-05-01')+30*n))
  
  
  
  content <- content(r)
  
  
  for(i in 1:30) {
    
    weather$date[i+30*(n-1)] <- content$data$weather[[i]]$date
    weather$maxtempC[i+30*(n-1)]   <- content$data$weather[[i]]$maxtempC
    weather$mintempC[i+30*(n-1)]   <- content$data$weather[[i]]$mintempC
    weather$windspeedKmph[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$windspeedKmph
    weather$winddirDegree[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$winddirDegree
    weather$weatherCode[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$weatherCode
    weather$weatherDesc[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$weatherDesc[[1]]$`value`
    weather$precipMM[i+30*(n-1)]  <- content$data$weather[[i]]$hourly[[1]]$precipMM
    weather$humidity[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$humidity
    weather$visibility[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$visibility
    weather$pressure[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$pressure
    weather$cloudcover[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$cloudcover
    weather$HeatIndexC[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$HeatIndexC
    weather$WindGustKmph[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$WindGustKmph 
    
  }
}



n = as.integer((Sys.Date()- as.Date('2017-05-01'))/30) + 1


#add extra
r <- GET(paste0(paste0(paste0("http://api.worldweatheronline.com/premium/v1/past-weather.ashx?key=03e3833270494f358a940750182805&q=-36.818,174.935&tp=24&format=json&date=",as.Date('2017-05-01')+30*(n-1)),
                       "&enddate="),Sys.Date()))



content <- content(r)




for(i in 1:as.numeric(Sys.Date() - (as.Date('2017-05-01')+30*(n-1)) +1)) {
  
  weather$date[i+30*(n-1)] <- content$data$weather[[i]]$date
  weather$maxtempC[i+30*(n-1)]   <- content$data$weather[[i]]$maxtempC
  weather$mintempC[i+30*(n-1)]   <- content$data$weather[[i]]$mintempC
  weather$windspeedKmph[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$windspeedKmph
  weather$winddirDegree[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$winddirDegree
  weather$weatherCode[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$weatherCode
  weather$weatherDesc[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$weatherDesc[[1]]$`value`
  weather$precipMM[i+30*(n-1)]  <- content$data$weather[[i]]$hourly[[1]]$precipMM
  weather$humidity[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$humidity
  weather$visibility[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$visibility
  weather$pressure[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$pressure
  weather$cloudcover[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$cloudcover
  weather$HeatIndexC[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$HeatIndexC
  weather$WindGustKmph[i+30*(n-1)]   <- content$data$weather[[i]]$hourly[[1]]$WindGustKmph 
  
}


weather <- type.convert(weather)
weather$date <- as.Date(weather$date)




#forecast
r <- GET("http://api.worldweatheronline.com/premium/v1/weather.ashx?key=03e3833270494f358a940750182805&q=-36.818,174.935&tp=24&format=json&mca=no")
content <- content(r)


