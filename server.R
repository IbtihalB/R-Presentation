library(RColorBrewer)
shinyServer(function(input, output, session) {
  datos <-read.csv("StudentsPerformance.csv",dec = ",")
  
  select.1var.h <- reactive({
    res <- datos[,input$hcol]
    res
  })
  output$RawData <- DT::renderDataTable(
    DT::datatable({
      datos
    },
    options = list(lengthMenu=list(c(5,15,20),c('5','15','20')),pageLength=10,
                   initComplete = JS(
                     "function(settings, json) {",
                     "$(this.api().table().header()).css({'background-color': 'moccasin', 'color': '1c1b1b'});",
                     "}"),
                   columnDefs=list(list(className='dt-center',targets="_all"))
    ),
    filter = "top",
    selection = 'multiple',
    style = 'bootstrap',
    class = 'cell-border stripe',
    rownames = FALSE,
    colnames = c("gender","race ethnicity","parental level of education","lunch","test preparation course","math score","reading score","writing score")
    ))
  output$histo <- renderPlot({
    data <- select.1var.h()
    hist(data,
         probability = TRUE,
         breaks = as.numeric(input$n_breaks),
         xlab = colnames(data),
         ylab = "Densité de fréquence",
         main = "Fréquence des scores des matières",,col = brewer.pal(n = 5, name = "Dark2"))
    if (input$density) {
      dens <- density(data, adjust = input$bw_adjust)
      lines(dens, col = "#66CDAA", lwd=5)
    }
    
  })
  
  select.2var <- reactive({
    res <- datos[, c(input$xcol,input$ycolb,input$qua)]
    res
  })
  
  output$plot1 <- renderPlot({
    data <- select.2var()
    critère_qualitatif <- factor(data[,3])
    
    ggplot(data = data, aes(x = data[,1] , y= data[,2])) +
      geom_point(aes(colour =critère_qualitatif)) +
      labs(x = colnames(data)[1] , y = colnames(data)[2])+ 
      theme_minimal () 
  })
  
  select.1var <- reactive({
    res <- datos[,input$zcol]
    res
  })
  select.3var <- reactive({
    res <- datos[,input$ycol]
    res
  })
  output$boxplot <- renderPlot({
    data <- select.1var()
    data2<- select.3var()
    ggplot(datos, aes(x = data2 , y= data)) +
      geom_boxplot(aes(fill =data2)) +
      labs(x =colnames(data2), y =colnames(data)) +
      theme_minimal ()+ scale_color_brewer(palette = "Dark2")
  })
  select.4var <- reactive({
    res <- datos[,input$zcolbar]
    res
  })
  output$barplot <- renderPlot({
    data<- select.4var()
    tab.eff <- table(data)
    tab.freq <- prop.table(tab.eff) 
    coul <- brewer.pal(5, "Dark2")
    barplot(tab.freq,xlab=colnames(data),ylab="Fréquence",main = "Distrubtion des notes",col = brewer.pal(n = 5, name = "Dark2"))

    
  })
  
  select.espece <- reactive({
    res <- input$esp
    res
  })
  
  output$correlation1 <- renderPlot({
    espe <- select.espece()
    idx <- which(datos$gender==espe)
    mat.cor <- cor(x = datos[idx,6:8])
    corrplot(mat.cor , type = "upper", order = "hclust", tl.col = "black" , tl.srt =40)
  })
  select.espece1 <- reactive({
    res <- input$par
    res
  })
  
  output$correlation2 <- renderPlot({
    espe <- select.espece1()
    idx <- which(datos$parental.level.of.education==espe)
    mat.cor <- cor(x = datos[idx,6:8])
    corrplot(mat.cor , type = "upper", order = "hclust", tl.col = "black" , tl.srt =45)
  })
  select.espece2 <- reactive({
    res <- input$eth
  })
  output$correlation3 <- renderPlot({
    espe <- select.espece2()
    idx <- which(datos$race.ethnicity==espe)
    mat.cor <- cor(x = datos[idx,6:8])
    corrplot(mat.cor , type = "upper", order = "hclust", tl.col = "black" , tl.srt =45)
  })
  
  output$summary <- renderPrint({summary(datos)})
  
  output$bTable <- DT::renderDataTable({datos})    
}
)
