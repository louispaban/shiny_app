library(data.table)

## Data formatting
movies <- read.csv("tmdb-movies.csv", stringsAsFactors = FALSE)
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


server <- function(input, output) {
  
  output$slider <- renderUI({
    sliderInput("slider", "Slider", min = 0,
                max = input$num, value = 0)
  })
  
  filter_director <- reactive({
    movie_temp = movies %>%
      filter(director == input$directorInput)
    separate_movies = separate_rows(movie_temp, genres, convert = TRUE)
    separate_movies = separate_rows(separate_movies, director, convert = TRUE)
    count_genres <- count(separate_movies, genres)
  })
  
  filtered <- reactive({
    if (is.null(input$budgetInput) | is.null(input$popularityInput) | is.null(input$voteInput) | is.null(input$revenueInput)) {
      return(NULL)
    }

    movies %>%
      filter(budget >= input$budgetInput[1],
             budget <= input$budgetInput[2],
             popularity >= input$popularityInput[1],
             popularity <= input$popularityInput[2],
             vote_average >= input$voteInput[1],
             vote_average <= input$voteInput[2],
             revenue >= input$revenueInput[1],
             revenue <= input$revenueInput[2]
      )
  })

  
  filter_search <- reactive({
    
    if(input$choice == "Director" && !is.null(input$choice)){
      if (!is.null(input$res_choice) && input$res_choice != "") {
        head(movies %>% filter(director %like% input$res_choice),100)
      }
      else{
        head(movies,150)
      }
    }
    
    else if(input$choice == "Title" && !is.null(input$choice)){
      if (!is.null(input$res_choice) && input$res_choice != "") {
        head(movies %>% filter(original_title %like% input$res_choice),100)
      }
      else{
        head(movies,150)
      }
    }
    else if(input$choice == "Year" && !is.null(input$choice)){
      if (!is.null(input$res_choice) && input$res_choice != "") {
        head(movies %>% filter(release_year == input$res_choice),100)
      }
      else{
        head(movies,150)
      }
    }
    
  })
  
  output$resultsChoice <- renderUI({
    selectInput("choice", "Search on",
                choices = list("Director","Title","Year"))
  })
  
  output$rev_bu <- renderPlot({
    if (is.null(filtered())) {
      return()
    }

    ggplot(filtered(), aes(x = budget,y = revenue)) + geom_point()
  })
  
  output$pop_rate <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    
    ggplot(filtered(), aes(x = popularity,y = vote_average)) + geom_point()
  })
  
  output$rate_genres <- renderPlot({
    if (is.null(separate_rows(pop_outliers, genres, convert = TRUE))) {
      return()
    }
    
    ggplot(separate_rows(pop_outliers, genres, convert = TRUE), aes(x = popularity,color = genres)) + geom_histogram(fill="white", position="dodge") + theme(legend.position="top")
  })
  
  output$results <- renderTable({
    filter_search()
  })
  
  output$nb_results <- renderText({
    if(!is.null(nrow(filter_search())))
      paste(nrow(filter_search()) , " resultats correspondent a votre recherche")
  })
  
  output$popularityOutput <- renderUI({
    sliderInput("popularityInput", "Popularity", min = 0,
                max = 35, value = c(2, 20))
  })
  
  output$revenueOutput <- renderUI({
    sliderInput("revenueInput", "Revenue", min = 0,
                max = 1063171911, value = c(250000000, 500000000))
  })
  
  output$budgetOutput <- renderUI({
    sliderInput("budgetInput", "Budget ($)", min = 0,
                max = 425000000, value = c(10000000,300000000), pre = "$")
  })
  
  output$voteOutput <- renderUI({
    sliderInput("voteInput", "Rating", min = 0,
                max = 10, value = c(2,8))
  })
  
  output$max <- renderUI({
    sliderInput("max",
                "Maximum Number of Words:",
                min = 1,  max = 50,  value = 100)
  })
  
  output$cloud <- renderPlot({
    wordcloud(words = filter_director()$genres, freq = filter_director()$n, min.freq = 1, max.words=input$max,
              colors = brewer.pal(8, "Dark2"))
  })
  
  output$director <- renderUI({
    selectInput("directorInput", "Director",
                sort(unique(movies$director))
                )
  })
}
