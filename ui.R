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
                                       )
                  ),

)

