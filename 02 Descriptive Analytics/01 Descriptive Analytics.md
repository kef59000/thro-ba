
# Descriptive Analytics

## Task 1: Explaining Source Code
Betrachten Sie die folgenden Programm-Code-Ausschnitte und erklären Sie, was in den einzelnen Fällen passiert.

### Fall 01

    ggplot(data) +
        geom_line(aes(x=del_date, y=pal, color = Plant)) +
        theme_set(theme_bw()) +
        labs(x = "Date", y = "Pallets") +
        ggtitle("Pallets per Day") +
        theme(plot.title = element_text(size = 12, face = 4, hjust = 1))

### Fall 02

    shpm <- shipment %>%
        inner_join(customer, by = c("Ship-to2" = "ID")) %>%
        inner_join(plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
        as_tibble() %>%
        mutate(del_date = dmy(Delivery_day))

### Fall 03

    eda_temp <- eda_shpm_to %>%
        group_by(Plant) %>%
        summarise(to = sum(tons)) %>%
        ungroup()

### Fall 04

    for (i in 1:10) {
        print(paste("Num:", i))
    }

### Fall 05

    my_func <- function(my_arg) {
        paste0("Hallo ", my_arg) %>% print()
    }

### Fall 06

    ggplot(data) +
        geom_point(aes(x=del_date, y=pal)) +
        theme_set(theme_bw()) +
        labs(x = "Date", y = "Pallets") +
        ggtitle("Pallets per Day") +
        theme(plot.title = element_text(size = 12, face = 4, hjust = 1)) +
        facet_wrap(~ Plant, nrow = 1) +
        geom_violin(aes(x=del_date, y=pal), fill = "gray80", alpha = 0.5)

### Fall 07

    eda_temp <- eda_shpm_to %>%
        group_by(Plant) %>%
        summarise(  sum_to = sum(tons, na.rm=TRUE),
                    min_to = min(tons, na.rm=TRUE),
                    mean_to = mean(tons, na.rm=TRUE),
                    max_to = max(tons, na.rm=TRUE)) %>%
        ungroup()

### Fall 08

    max(shpm$GWkg)

### Fall 09

    head(shpm, 3)

### Fall 10

    csv_customer <- fread("thro_shpmt_csv/customer.csv", sep=";", header= TRUE, encoding = 'Latin-1')

### Fall 11

    source('app_global.R')

### Fall 12

    shinyApp(ui = ui, server = server)

### Fall 13

    descriptive_analytics_UI <- function(id){
        ns <- NS(id)
        ...
    }

### Fall 14

    box(title="Controls", status='primary', width=12, collapsible = TRUE, collapsed = FALSE,
        column(width=2, selectizeInput(ns("KArt"), label="Kunden: Art", choices = NULL, multiple=TRUE)))

### Fall 15

    fluidRow(
        box(title="Customer Orders", status = "primary", width=8,
            plotlyOutput(ns("histo"))),
        box(title="Map", status = "primary", width=4,
            leafletOutput(ns('map')))
        )

### Fall 16

    output$box_pie <- renderUI({
        ns <- session$ns
        
        box(title="Customer Orders", status="primary", width=4,
            plotlyOutput(ns("pie")))
    })

### Fall 17

    selected <- reactiveValues( Kart = NULL,
                                Kgrp = NULL,
                                Ktyp = NULL)

### Fall 18

    observeEvent(eventExpr = input$KTyp, ignoreNULL = FALSE, ignoreInit = TRUE, {
        selected$Ktyp <- input$KTyp
        filter$Ktyp <- if(is.null(selected$Ktyp)) unique(customer$Ktyp) else selected$Ktyp
    })

### Fall 19

    data_filtered <- reactive({
        ...
    })

### Fall 20

    DT::datatable(temp, filter = "top", options = list(pageLength = 5))

### Fall 21

    leaflet(data=customer) %>%
        addProviderTiles(providers$OpenStreetMap.DE) %>%
        fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))

### Fall 22

    observe(
        leafletProxy("map", data = map_data()) %>%
        clearMarkers() %>% clearMarkerClusters() %>%
        addAwesomeMarkers(  clusterOptions = markerClusterOptions(),
                            lng = ~Longitude_customer, lat = ~Latitude_customer, popup = ~popup_content))

### Fall 23

    wdays <- seq(from=1, to=nrow(shpm_ts))

### Fall 24

    fwrite(shpm_ts, 'lin_reg.csv', dec=",", sep=";")

### Fall 25

    lm <- lm(data = us_change, formula = Consumption ~ Income + Production + Savings + Unemployment)
    lm %>% summary()

### Fall 26

    pred_02 <- predict(lm, newdata=new)

### Fall 27

    data %>%
        model(
            SES = ETS(obs ~ error("A") + trend("N") + season("N"))
        ) %>%
        forecast(h=5) %>%
        pull(.mean)

### Fall 28

    fit <- aus_holidays %>%
        model(
            additive = ETS(Trips ~ error("A") + trend("A") + season("A")),
            multiplicative = ETS(Trips ~ error("M") + trend("A") + season("M"))
        )

### Fall 29

    obs <- c(106.8, 129.2, 153.0, 149.1, 158.3, 132.9, 149.8, 140.3, 138.3, 152.2, 128.1)
    zoo::rollapply(data=obs, width=3, FUN=mean)

### Fall 30

    shpm_ts <- shpm_ts %>%
        mutate( Di = ifelse(week_day == "Tuesday", 1,0),
                Mi = ifelse(week_day == "Wednesday", 1,0),
                Do = ifelse(week_day == "Thursday", 1,0),
                Fr = ifelse(week_day == "Friday", 1,0))

## Task 2: SQL-Statements

Das THRO-Verwaltungsprogramm ist ausgefallen und Sie können auf die Datenbank-Inhalte nur noch per SQL zugreifen. Geben Sie die SQL-Befehle (jeweils nur ein Befehl!) an, um die nachfolgenden Fragen zu beantworten. Ihnen steht der logische Entwurf der Datenbank zur Verfügung.

Logischer Entwurf:

    1. Student		(Matrikelnummer, Name, Wohnort, Jahr_der_Immatrikulation, Geschlecht)
    2. Zahlung		(ZahlungsID, Matrikelnummer, Semester, Beitrag)

1. Zeige mir den Namen des Studenten, der die letzte/höchste Matrikelnummer hat.
2. Wie viele Studenten sind weiblich, wie viele männlich?
3. Zeige an, wie viel die einzelnen Studenten (Name!) in Summe an Studiengebühren bezahlt haben.
