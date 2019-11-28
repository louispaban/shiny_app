IMDB Movies
========================================================
author: Adrien Mina, Louis Paban, Steven Tan
date: 28th of November
autosize: true

Our project features
========================================================

- Plot statistics of movies (budget,popularity,etc...)
- Search and filter 
- Get creative wordclouds associated to each movie director

Slide With Code
========================================================


```r
library(data.table)
library(shiny)
library(ggplot2)
library(dplyr)
library(wordcloud)
library(wordcloud2)
library(tm)
library(stringr)
library(tidyr)
movies <- read.csv("tmdb-movies.csv", stringsAsFactors = FALSE)
movies = subset(movies, select = -c(revenue,budget,imdb_id, homepage, tagline, overview, keywords) )
colnames(movies)[colnames(movies)=="budget_adj"] <- "budget"
colnames(movies)[colnames(movies)=="revenue_adj"] <- "revenue"
movies = movies[!(is.na(movies$genres) | movies$genres==""), ]

pop_outliers <- movies[movies$popularity <= 3, ]
summary(movies)
```

```
       id           popularity       original_title         cast          
 Min.   :     5   Min.   : 0.00006   Length:10843       Length:10843      
 1st Qu.: 10590   1st Qu.: 0.20825   Class :character   Class :character  
 Median : 20558   Median : 0.38456   Mode  :character   Mode  :character  
 Mean   : 65868   Mean   : 0.64746                                        
 3rd Qu.: 75182   3rd Qu.: 0.71535                                        
 Max.   :417859   Max.   :32.98576                                        
   director            runtime         genres         
 Length:10843       Min.   :  0.0   Length:10843      
 Class :character   1st Qu.: 90.0   Class :character  
 Mode  :character   Median : 99.0   Mode  :character  
                    Mean   :102.1                     
                    3rd Qu.:111.0                     
                    Max.   :900.0                     
 production_companies release_date         vote_count      vote_average  
 Length:10843         Length:10843       Min.   :  10.0   Min.   :1.500  
 Class :character     Class :character   1st Qu.:  17.0   1st Qu.:5.400  
 Mode  :character     Mode  :character   Median :  38.0   Median :6.000  
                                         Mean   : 217.8   Mean   :5.974  
                                         3rd Qu.: 146.0   3rd Qu.:6.600  
                                         Max.   :9767.0   Max.   :9.200  
  release_year      budget             revenue         
 Min.   :1960   Min.   :        0   Min.   :0.000e+00  
 1st Qu.:1995   1st Qu.:        0   1st Qu.:0.000e+00  
 Median :2006   Median :        0   Median :0.000e+00  
 Mean   :2001   Mean   : 17588266   Mean   :5.147e+07  
 3rd Qu.:2011   3rd Qu.: 20935298   3rd Qu.:3.388e+07  
 Max.   :2015   Max.   :425000000   Max.   :2.827e+09  
```

Plot example:Popularity of the different genres
========================================================

![plot of chunk unnamed-chunk-2](Pres-figure/unnamed-chunk-2-1.png)
