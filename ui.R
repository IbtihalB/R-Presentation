library(markdown)
library(corrplot)
library(ggplot2)
library(DT)
library(shinythemes)
library("png")


datos <-read.csv("StudentsPerformance.csv",dec = ",")

shinyUI(fluidPage(theme = shinytheme("flatly"),

           navbarPage("La Performance des étudiants en Exams",
           # ACCUEIL
           tabPanel("Contexte",
                    fluidRow(
                             column(
                               
                               
                               br(),
                               p(" Cet ensemble de données comprend les notes obtenues par 
                                 les élèves d'une école publique des États-Unis dans diverses 
                                 matières (mathématiques, lecture, écriture).Et ceci pour comprendre 
                                 l'influence du background des parents, de la préparation aux tests... , 
                                 sur les performances des élèves", 
                                 style="text-align:justify;color:black;background-color:#DCDCDC;padding:15px;border-radius:10px"),
                               br(),
                               
                               width=8),
                             column(
                               br(),
                               p("Pour consulter la source de données, veuillez cliquer sur ",
                                 br(),
                                 a(href="https://www.kaggle.com/spscientist/students-performance-in-exams", "Here",target="_blank"),style="background-color:#808B96;color:black;border-radius:10px;padding:20px;"),
                               
                               width=4)),
                    
                    hr(),

           
                    mainPanel(
                      
                        tags$ul(                      

                        tags$li("Nombre d'individus : 1000"),
                        tags$li("Nombre de variables : 3 quantitatives et 5 qualitatives"),
                        style="background-color:#DCDCDC;padding:25px;border-radius:10px"),
                        
                        tags$li("Variables Qualitatives:"),tags$ul(
                                  tags$li("gender"),
                                  tags$li("race ethnicity"),
                                  tags$li( "parental level of education"),
                                  tags$li("lunch"),
                                  tags$li("test preparation course"),style="background-color:#DCDCDC;padding:23px;border-radius:10px"),
                        tags$li("Variables Quantitatives:"),
                                  tags$ul(
                                  tags$li("math score"),
                                  tags$li("reading score"),
                                  tags$li( "writing score"),style="background-color:#DCDCDC;padding:23px;border-radius:10px"),
                        
                    ),
                      
                    
           ),
           # Barplot
           
           tabPanel("Barplot",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('zcolbar', 'Variable 1', names(datos)[1:5]),
                        
                      ),
                      mainPanel(
                        plotOutput("barplot")
                      )
                    )
           ),
           
           
           # HISTOGRAMMES
           tabPanel("Histogramme",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('hcol', 'Variable', names(datos)[6:8]),
                        selectInput(inputId = "n_breaks",
                                    label = "Nombre de classes :",
                                    choices = 1:50,
                                    selected = 10),
                        checkboxInput(inputId = "density",
                                      label = strong("Estimateur à noyau de la densité"),
                                      value = FALSE),
                        conditionalPanel(condition = "input.density == true",
                                         sliderInput(inputId = "bw_adjust",
                                                     label = "Largeur de la fenetre :",
                                                     min = 0.2, max = 2, value = 1, step = 0.2),
                        ),
                      ),
                      mainPanel(
                        plotOutput(outputId = "histo"),
                      )
                    )
           ),
           
           # BOITES A MOUSTACHES
           tabPanel("Boxplot",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('zcol', 'Variable 1', names(datos)[6:8]),
                        selectInput('ycol', 'Variable 2', names(datos)[1:5]),
                        
                      ),
                      mainPanel(
                        plotOutput("boxplot")
                      )
                    )
           ),

           # BIPLOT
           tabPanel("Biplot",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('xcol', 'Variable 1', names(datos)[6:8]),
                        selectInput('ycolb', 'Variable 2', names(datos)[6:8]),
                        selectInput('qua', 'Variable 3', names(datos)[1:5]),
                        
                      ),
                      mainPanel(
                        plotOutput("plot1")
                      )
                    )
           ),
           
           # CORRELATION
           tabPanel("Corrélation1",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('esp', 'Gender', factor(datos$gender), selected = 1),
                      ),
                      mainPanel(
                        plotOutput("correlation1")
                      )
                    ),
           ),
           # CORRELATION2
           tabPanel("Corrélation2",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('par', 'Parental education', factor(datos$parental.level.of.education), selected = 1),
                      ),
                      mainPanel(
                        plotOutput("correlation2")
                      )
                    ),
           ),
           # CORRELATION3
           tabPanel("Corrélation3",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('eth', 'ethnicity', factor(datos$race.ethnicity), selected = 1),
                      ),
                     
                      mainPanel(
                        plotOutput("correlation3")
                      )
                    ),
           ),
           
           # STATISTIQUES DESCRIPTIVES
           tabPanel("Statistiques descriptives",
                    verbatimTextOutput("summary")
           ),
           # DATA
           tabPanel("Données",
                    fluidRow(column(DT::dataTableOutput("RawData"),
                                    width = 12))
                    
           )
)))

