Presentation
========================================================
author: Steven TAN, Adrien MINA, Louis PABAN
date: 01/12/2019
autosize: true

Links
========================================================

- R Presentation : http://rpubs.com/Steven_tan/shinyapps
- Github : https://github.com/louispaban/shiny_app
- Shinyapps : https://steventan.shinyapps.io/Shiny/

Our application
========================================================

Dataset : IMDB Movies

- Statistics
- Search Table
- Wordcloud

Slide With Code
========================================================


```r
library(shiny)
library(ggplot2)
library(dplyr)
library(wordcloud)
library(wordcloud2)
library(tm)
library(stringr)
library(tidyr)
library(knitr)

movies <- read.csv("D:/ECE ING5/Data Analytics/Shiny/tmdb-movies.csv", stringsAsFactors = FALSE)
movies = subset(movies, select = -c(revenue,budget,imdb_id, homepage, tagline, overview, keywords) )
colnames(movies)[colnames(movies)=="budget_adj"] <- "budget"
colnames(movies)[colnames(movies)=="revenue_adj"] <- "revenue"
movies$genres <- str_replace_all(movies$genres, '\\|', '\n')
movies$production_companies <- str_replace_all(movies$production_companies, '\\|', '\n')
movies$cast <- str_replace_all(movies$cast, '\\|', '\n')
movies = movies[!(is.na(movies$genres) | movies$genres==""), ]

pop_outliers <- movies[movies$popularity <= 3, ]

movies = movies %>% 
  mutate(director = strsplit(as.character(director), "\\|")) %>% 
  unnest(director)

separate_movies = separate_rows(movies, genres, convert = TRUE)
separate_movies = separate_rows(separate_movies, director, convert = TRUE)
count_genres <- count(separate_movies, genres)
```

Statistics
========================================================

![plot of chunk unnamed-chunk-2](StevenTAN_AdrienMINA_LouisPABAN-figure/unnamed-chunk-2-1.png)![plot of chunk unnamed-chunk-2](StevenTAN_AdrienMINA_LouisPABAN-figure/unnamed-chunk-2-2.png)![plot of chunk unnamed-chunk-2](StevenTAN_AdrienMINA_LouisPABAN-figure/unnamed-chunk-2-3.png)

Search Table
========================================================

```
# A tibble: 5 x 14
      id popularity original_title cast  director runtime genres
   <int>      <dbl> <chr>          <chr> <chr>      <int> <chr> 
1 135397      33.0  Jurassic World "Chr~ Colin T~     124 "Acti~
2  76341      28.4  Mad Max: Fury~ "Tom~ George ~     120 "Acti~
3 262500      13.1  Insurgent      "Sha~ Robert ~     119 "Adve~
4 140607      11.2  Star Wars: Th~ "Har~ J.J. Ab~     136 "Acti~
5 168259       9.34 Furious 7      "Vin~ James W~     137 "Acti~
# ... with 7 more variables: production_companies <chr>, release_date <chr>,
#   vote_count <int>, vote_average <dbl>, release_year <int>, budget <dbl>,
#   revenue <dbl>
```

Wordcloud
========================================================
![plot of chunk unnamed-chunk-4](StevenTAN_AdrienMINA_LouisPABAN-figure/unnamed-chunk-4-1.png)

