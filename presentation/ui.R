library(shinydashboard)
library(shiny)
library(DT)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = "black",
          dashboardHeader(title = "Pump-and-Dump"),
          
          dashboardSidebar(
            sidebarUserPanel("Mike Stukalo", image = "avatar.png"),
            sidebarMenu(
              menuItem("About", tabName = "about", icon = icon("book")),
              
              menuItem("Web Scraping", tabName = "scrape", icon = icon ("copy"),
                       menuSubItem("Raw data", tabName = "raw"),
                       menuSubItem("Data Cleaning", tabName = "dc"),
                       menuSubItem("Final Dataset", tabName = "final_df")
                       ),
              
              menuItem("Word Clouds", tabName = "clouds", icon = icon ("cloud")),
                       
              menuItem("Comments and Price", tabName = "comment", icon = icon("bar-chart")),
              
              menuItem("Logistic regression", tabName = "logit", icon = icon ("laptop")),
              
              menuItem("The Author", tabName = "author", icon = icon("user"))
              )
          ),  
            
          
          dashboardBody(
            tabItems(
            
            # About page
            tabItem(tabName = "about",
                    fluidPage(
                      fluidRow(
                      column(6, h1("Pump and Dump practice"))
                      ),
                      fluidRow(
                      column(6, 
                             p('"Pump and dump" (P&D) is a form of securities fraud that involves 
                              artificially inflating the price of an owned stock through 
                              false and misleading positive statements, in order to sell the cheaply 
                              purchased stock at a higher price. Once the operators of the scheme "dump" 
                              sell their overvalued shares, the price falls and investors lose their money. 
                              This is most common with small cap cryptocurrencies and very small corporations, 
                              i.e. "microcaps"'),
                             p(tags$b("Wikipedia", align = "right" ))
                      )),
                      tabsetPanel(
                        tabPanel("Past", uiOutput("video")),
                        tabPanel("Present", img(src="reddit.png"))
                                 )
                      )
                    ),
            
            # Raw data page
            tabItem(tabName = "raw",
                    fluidPage(
                      fluidRow(
                        column(6, htmlOutput("raw"))
                      ),
                      fluidRow(
                        div(tableOutput("raw_table"))
                      )
                    )
                    ),
            
            # Data cleaning page
            tabItem(tabName = "dc",
                    fluidPage(
                      fluidRow(
                        column(6, htmlOutput("cleaning"))),
                      fluidRow(column(3, h3("Raw data")),
                               column(1, div()),
                               column(3, h3("Clean data"))
                              ),
                      fluidRow(column(3, div(tableOutput("init"))),
                               column(1, img(src="arrow.png", width = 50)),
                               column(3, div(tableOutput("clean")))
                               )  
                      )
                    ),
            
            # Final dataset
            tabItem(tabName = "final_df", 
                    fluidPage(fluidRow(h2("Final Dataset")),
                              fluidRow(div(DT::dataTableOutput("final")))
                              )
                    ),
            
            # Word clouds
            tabItem(tabName = "clouds",
                    fluidPage(fluidRow(h2("Word Clouds")),
                              fluidRow(selectInput("wordcloud", "Select stock performance",
                                                   c("Up"="wc_up.png", "Down"="wc_down.png", 
                                                     "Prior to Up" = "wc_pre_up.png", "Prior to Down" = "wc_pre_down.png")
                                           )),
                              fluidRow(imageOutput("wordcloud"))
                              )
                              
                    ),
            
            # Comments and price
            tabItem(tabName = "comment",
                    fluidPage(fluidRow(h2("Reddit comments and the stock price")),
                              fluidRow(selectInput("ticker", "Select ticker", tickers)),
                              fluidRow(plotlyOutput("comm"))
                      
                            )
              
                    ),
            
            # Logistic regressions
            tabItem(tabName="logit",
                    fluidPage(fluidRow(h2("Logistic Regression")),
                              
                      tabsetPanel(
                        tabPanel("Specification 1", br(), br(),
                                fluidRow(htmlOutput("l1")),
                                fluidRow(column(6, verbatimTextOutput("log1")))
                                ),
                      tabPanel("Specification 2", br(), br(),
                               fluidRow(htmlOutput("l2")),
                               fluidRow(column(6, verbatimTextOutput("log2")))
                              ),
                        tabPanel("Specification 3", br(), br(),
                              fluidRow(htmlOutput("l3")),
                              fluidRow(column(6, verbatimTextOutput("log3")))
                                ),
                        tabPanel("Specification 4", br(), br(),
                              fluidRow(htmlOutput("l4")),
                              fluidRow(column(6, verbatimTextOutput("log4")))
                                )   
                              )
                            )
                      ),
            
            ##### My CV Page
            tabItem(tabName = "author", 
                    fluidRow(column(3,h3("About Me"))),
                    fluidRow(column(1, div(img(src="avatar.png", height=120))),
                             column(1,div(
                               fluidRow(actionButton(inputId="li", label = "", icon = icon("linkedin"),
                                                     onclick ="location.href='https://www.linkedin.com/in/mstukalo/';")),
                               fluidRow(actionButton(inputId="gh", label = "", icon = icon("github"),
                                                     onclick ="location.href='https://github.com/mikestukalo';")), br(),
                               fluidRow(actionButton(inputId="cv", label = "Resume", icon = icon("file"),
                                                     onclick ="location.href='https://www.dropbox.com/s/gbfdkcp9fe0wx5z/Stukalo_resume.pdf?dl=0';"))
                             )
                             )
                    ),
                    fluidRow(column(6, 
                                    div(br(),br(),
                                        p("Dr. Mikhail Stukalo has over 15 years of experience in financial markets."),
                                        p("Prior to obtaining his Doctoral degree Mikhail Stukalo was a Director and a Partner at 
                                        Svarog Capital, a Russian private equity and venture capital fund with over $250 million AuM. 
                                        As a part of his involvement with Svarog Capital, Dr. Stukalo supervised the fund’s portfolio 
                                        investments by sitting on the Board of Directors of various companies, ranging from start-ups 
                                        to multibillion-dollar enterprises. Also, he made a number of successful private investments as 
                                        an early-stage investor in start-ups. His prior career included a number of managerial positions 
                                        in investment banking and M&A advisory companies."),
                                        p("Currently, Mikhail is a Data Science Fellow with NYC Data Science Academy"),
                                        p("Dr. Stukalo earned his MBA degree from London Business School and a Doctor of Philosophy in 
                                        Business degree from Georgia State University. He is a CFA and a CAIA charter holder. 
                                        He also holds a Certificate in Quantitative Finance (CQF) from Fitch Learning, London.")
                                        
                                        
                                    )))
            )
            )
            )
            
          )
            
)        

