library(RJSONIO)
library(httr)

fromJSON(content(GET("http://ckdpcrisk.org/lowgfrevents/lifetime1.php",
                     query = list(age=60, #30-85
                                  sex=1, #M F
                                  race=0, #Black White
                                  egfr=17, #15-30
                                  sbp=140, #90-180, by 5
                                  hx_cvd=0, #T/F
                                  diabetes=0, #T/F
                                  acr=100, #10, 30, 50, 80, 100, 150, 200, 250, 300, 500, 750, 1000, 1500, 2000, 3000, 4000, 5000, 10000
                                  smoking=0, #T F
                                  riskyrs=4) #2 4
),"text")) %>% as.data.frame()
