library(shiny)
library(ggplot2)
library(dplyr)
library(wordcloud)
library(wordcloud2)
library(tm)
library(stringr)
library(tidyr)
ui <- fluidPage(titlePanel("IMDB Movies"),
                  tabsetPanel(type = "tabs",
                              tabPanel("Plot",
                                      sidebarPanel(
                                        
                                        uiOutput("popularityOutput"),
                                        uiOutput("budgetOutput"),
                                        uiOutput("voteOutput"),
                                        uiOutput("revenueOutput")
                                      ),
                                      mainPanel(
                                         plotOutput("rate_genres"),
                                         plotOutput("rev_bu"),
                                         plotOutput("pop_rate")
                                        
                                      )
                              ),
                              tabPanel("Search",
                                       sidebarPanel(
                                         uiOutput("resultsChoice"),
                                         textInput("res_choice", "Enter your text :")
                                       ),
                                       mainPanel(
                                         
                                         textOutput("nb_results"),
                                         tableOutput("results")
                                       )
                              ),
                              tabPanel("Cloud",
                                       sidebarLayout(
                                         sidebarPanel(
                                           uiOutput("max"),
                                           uiOutput("director")
                                         ),
                                         
                                         mainPanel(
                                           plotOutput("cloud")
                                         )
                                       )),
                              tabPanel("Help",
                                       h1("Plot tab"),
                                       h3("Use the sliders to filter the points plot, the histogram plot is not reactive."),
                                       br(),
                                       br(),
                                       h1("Search tab"),
                                       h3("Select the feature you want to filter by in the list and then type in the search bar, with respect with case sensitivity."),
                                       br(),
                                       br(),
                                       h1("Cloud tab"),
                                       h3("You can either select from the list or type the director and this will display the genres corresponding to his/her films. You can also use the slider to filter the maximum words to display.")
                                       )
                  ),

)

