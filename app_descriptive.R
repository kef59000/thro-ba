
descriptive_analytics_UI <- function(id){
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width=12, verbatimTextOutput(ns("report_info")))),
    fluidRow(
      box(title="Controls", status='primary', width=12, collapsible = TRUE, collapsed = FALSE,
          column(width=2, selectizeInput(ns("KArt"), label="Kunden: Art", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KGrp"), label="Kunden: Gruppe", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KTyp"), label="Kunden: Typ", choices = NULL, multiple=TRUE)),
          column(width=3, sliderInput(ns("Bestellvolumen"), "Bestellvolumen [to]", min=0, max=9999, value=9999/2, step=100)))),
    fluidRow(
      uiOutput(ns("box_pie")),
      uiOutput(ns("box_tbl"))
    ),
    fluidRow(
      box(title="Customer Orders", status = "primary", width=8,
          plotlyOutput(ns("histo"))),
      box(title="Map", status = "primary", width=4,
          leafletOutput(ns('map')))
    )
  )
}


descriptive_analytics <- function(input, output, session){
  
  # Info Box ----------------------------------------------------------------
  output$report_info <- renderText({
    HTML(
      "This report analyzes the order volumes of different customers in the distribution network of an existing manufacturer of fast-moving consumer goods.")
  })
  
  
  # Controls ----------------------------------------------------------------
  updateSelectizeInput(session, "KArt", label="Kunden: Art", choices = unique(customer$Kart), server=TRUE)
  updateSelectizeInput(session, "KGrp", label="Kunden: Gruppe", choices = unique(customer$Kgruppe), server=TRUE)
  updateSelectizeInput(session, "KTyp", label="Kunden: Typ", choices = unique(customer$Ktyp), server=TRUE)

  
  
  # Box: Table & Pie --------------------------------------------------------
  output$box_pie <- renderUI({
    ns <- session$ns
    
    box(title="Customer Orders", status="primary", width=4,
        plotlyOutput(ns("pie")))
  })
  
  
  output$box_tbl <- renderUI({
    ns <- session$ns
    
    box(title="Customer Orders", status="primary", width=8,
        dataTableOutput(ns("table")))
  })
  


  # Get & Prepare Data ------------------------------------------------------
  selected <- reactiveValues(Kart = NULL,
                             Kgrp = NULL,
                             Ktyp = NULL)
  
  filter <- reactiveValues(Kart = unique(customer$Kart),
                           Kgrp = unique(customer$Kgruppe),
                           Ktyp = unique(customer$Ktyp))
  
  
  observeEvent(eventExpr = input$KArt, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$Kart <- input$KArt
    filter$Kart <- if(is.null(selected$Kart)) unique(customer$Kart) else selected$Kart
  })
  
  observeEvent(eventExpr = input$KGrp, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$Kgrp <- input$KGrp
    filter$Kgrp <- if(is.null(selected$Kgrp)) unique(customer$Kgruppe) else selected$Kgrp
  })
  
  observeEvent(eventExpr = input$KTyp, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$Ktyp <- input$KTyp
    filter$Ktyp <- if(is.null(selected$Ktyp)) unique(customer$Ktyp) else selected$Ktyp
  })
  
  
  data_filtered <- reactive({
    
    strSQL <- 'SELECT "Ship-to2" AS CUSTOMER_ID, sum(GWkg)/1000 AS SUM_TO
              FROM shipment
              GROUP BY "Ship-to2"'
    
    cust_id_filtered_1 <- dbGetQuery(con, strSQL) %>%
      filter(SUM_TO <= input$Bestellvolumen) %>%
      pull(CUSTOMER_ID)
    
    cust_id_filtered_2 <- customer %>%
      filter(ID %in% cust_id_filtered_1,
             Kart %in% filter$Kart, Kgruppe %in% filter$Kgrp, Ktyp %in% filter$Ktyp) %>%
      pull(ID)
    
    
    strSQL <- paste0('SELECT * ',
                     'FROM shipment ',
                     'WHERE "Ship-to2" IN (', paste(cust_id_filtered_2, collapse = ','), ')')
    
    recset <- dbGetQuery(con, strSQL) %>%
      inner_join(customer, by = c("Ship-to2" = "ID")) %>%
      inner_join(plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
      as_tibble() %>%
      mutate(del_date = dmy(Delivery_day))
  })
  
  

  # Analyze Data ------------------------------------------------------------
  
  # Pie
  output$pie <- renderPlotly({
    
    data <- data_filtered() %>%
      group_by(Kart) %>%
      summarise(tons = sum(GWkg)/1000) %>%
      ungroup()
    
    plot <- ggplot(data=data, aes(x=Kart, y=tons)) +
      geom_bar(stat="identity")
    
    ggplotly(plot)
    })
  
  
  # Table
  output$table <- renderDataTable({
    
    temp <- data_filtered() %>%
      select(del_date, Plant, Kname, KPlz, Kort, GWkg)
    
    DT::datatable(temp, filter = "top", options = list(pageLength = 5))
  })
  
  
  # Histogram
  output$histo <- renderPlotly({
    
    data <- data_filtered() %>%
      mutate(week = week(del_date)) %>%
      group_by(week) %>%
      summarise(tons = sum(GWkg)/1000) %>%
      ungroup()
    
    fit <- lm(tons ~ week, data = data)
    
    plot_ly(x = ~week) %>%
      add_trace(data=data, y= ~tons, type='bar', name='Order volume',
                hoverinfo='text', text= ~format(round(tons,0), nsmall=0, big.mark='.', decimal.mark=',')) %>%
      add_lines(y = fitted(fit), name = 'Regression Line') %>%
      layout(title='', showlegend=T)
    })
  
  
  # Map
  output$map <- renderLeaflet({
    
    leaflet(data=customer) %>%
      addProviderTiles(providers$OpenStreetMap.DE) %>%
      fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))
    })
  
  
  map_data <- reactive({
    
    temp <- data_filtered() %>%
      group_by(`Ship-to2`, Kname, Kstrasse, KPlz, Kort, Kart, Latitude_customer, Longitude_customer) %>%
      summarise(Pallets = sum(Pallets), GWkg = sum(GWkg)) %>%
      ungroup() %>%
      mutate(popup_content = paste(sep='<br/>',
                                   paste0('<b>',Kname,'</b>'), Kstrasse, KPlz, Kort,
                                   Kart, round(GWkg/1000, digits=0)))
    })
  
  
  observe(
    leafletProxy("map", data = map_data()) %>%
      clearMarkers() %>% clearMarkerClusters() %>%
      addAwesomeMarkers(clusterOptions = markerClusterOptions(),
                        lng = ~Longitude_customer, lat = ~Latitude_customer, popup = ~popup_content))
  
}