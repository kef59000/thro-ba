
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

Es wird eine ggplot-Grafik erzeugt basierend auf dem Datensatz "data". Ein Line-Chart wird erzeugt mit so vielen Linien, wie es verschiedene Plant-Einträge gibt: x-Achse = del_date, y-Achse = pal. Die x- und y-Achsen werden entsprechend beschriftet, der Titel angepasst und der Schriftgrad auf einen bestimmten Wert gesetzt.

### Fall 02

    shpm <- shipment %>%
        inner_join(customer, by = c("Ship-to2" = "ID")) %>%
        inner_join(plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
        as_tibble() %>%
        mutate(del_date = dmy(Delivery_day))

Der Datensatz "shipment" wird mit den Datensätzen "customer" und "plant" gejoint. Dabei werden die Join-Spalten und Spaltensuffixe spezifiziert. Der Datensatz wird als Tibble abgespeichert und es wird eine neue Spalte erzeugt, die die Delivery_day-Spalte in das ISO-Datumsformat bringt.

### Fall 03

    eda_temp <- eda_shpm_to %>%
        group_by(Plant) %>%
        summarise(to = sum(tons)) %>%
        ungroup()

Es wird für den Datensatz "eda_shpm_to" die Summe der tons-Spalte pro Plant berechnet und dem Objekt "eda_temp" zugewiesen.

### Fall 04

    for (i in 1:10) {
        print(paste("Num:", i))
    }

Eine Schleife wird durchlaufen. Diese schreibt in die Konsole die "Num: 1" bis "Num: 10".

### Fall 05

    my_func <- function(my_arg) {
        paste0("Hallo ", my_arg) %>% print()
    }

Es wird eine Funktion namens "my_func" angelegt. Diese empfängt ein Argument und schreibt in die Konsole "Hallo " gefolgt von dem übergebenem Argument.

### Fall 06

    ggplot(data) +
        geom_point(aes(x=del_date, y=pal)) +
        theme_set(theme_bw()) +
        labs(x = "Date", y = "Pallets") +
        ggtitle("Pallets per Day") +
        theme(plot.title = element_text(size = 12, face = 4, hjust = 1)) +
        facet_wrap(~ Plant, nrow = 1) +
        geom_violin(aes(x=del_date, y=pal), fill = "gray80", alpha = 0.5)

Auf Basis des data-Datensatzes wird eine ggplot-Grafik erzeugt. Diese besteht aus einem Punkt- und einem Violin-Plot. Pro "Plant" wird eine eigene Grafik erzeugt. Es erfolgen Spezifizierungen in Bezug auf die Achsenbeschriftungen, dem Grafik-Titel, dem generellen Erscheinungsbild und der Schriftart.

### Fall 07

    eda_temp <- eda_shpm_to %>%
        group_by(Plant) %>%
        summarise(  sum_to = sum(tons, na.rm=TRUE),
                    min_to = min(tons, na.rm=TRUE),
                    mean_to = mean(tons, na.rm=TRUE),
                    max_to = max(tons, na.rm=TRUE)) %>%
        ungroup()

Der Datensatz "eda_shpm_to" wird gruppiert und es wird pro "Plant" ausgegeben: die Summe der Tonnage, das Minimum der Tonnage, der Mittelwert und das Maximum der Tonnage.

### Fall 08

    max(shpm$GWkg)

Es wird das Maximum der Spalte "GWkg" des Datensatzes "shpm" augegeben.

### Fall 09

    head(shpm, 3)

Die ersten drei Zeilen des Datensatzes "shpm" werden ausgegeben.

### Fall 10

    csv_customer <- fread("thro_shpmt_csv/customer.csv", sep=";", header= TRUE, encoding = 'Latin-1')

Die Datei "customer.csv" wird eingelesen in das Objekt "csv_customer". Dabei wird spezifiziert, durch welches Symbol die Spalten getrennt sind, dass die Datei eine Header-Zeile besitzt und welches Encoding verwendet werden soll.

### Fall 11

    source('app_global.R')

Die Datei "app_global.R" wird aufgerufen.

### Fall 12

    shinyApp(ui = ui, server = server)

Die Shiny-App wird gestartet mit den entsprechenden ui- und server-Functions.

### Fall 13

    descriptive_analytics_UI <- function(id){
        ns <- NS(id)
        ...
    }

Die User-Interface spezifizierende Shiny Funktion wird angelegt. Dabei wird ein entsprechender Namespace "ns" übergeben.

### Fall 14

    box(title="Controls", status='primary', width=12, collapsible = TRUE, collapsed = FALSE,
        column(width=2, selectizeInput(ns("KArt"), label="Kunden: Art", choices = NULL, multiple=TRUE)))

Eine Box in einer Shiny-App wird angelegt. Dabei werden mehrere Parameter gesetzt, wie bspw. Titel und Breite. Innerhalb der Box befindet sich ein Dropdown-Menü, welches auch mit unterschiedlichen Parameter-Einstellungen belegt wird.

### Fall 15

    fluidRow(
        box(title="Customer Orders", status = "primary", width=8,
            plotlyOutput(ns("histo"))),
        box(title="Map", status = "primary", width=4,
            leafletOutput(ns('map')))
        )

Es wird eine responsive Zeile in einer Shiny-App angelegt. Diese beinhaltet zwei Boxen. Die erste Box beinhaltet eine Plotly-Grafik, vermutlich ein Histogramm. Die zweite Box beinhaltet eine Leaflet-Map.

### Fall 16

    output$box_pie <- renderUI({
        ns <- session$ns
        
        box(title="Customer Orders", status="primary", width=4,
            plotlyOutput(ns("pie")))
    })

Eine Box in einer Shiny-App wird serverseitig erzeugt. Dabei wird ein Namespace verwendet. Die Box beinhaltet eine Plotly-Grafik, vermutlich ein Pie-Chart.

### Fall 17

    selected <- reactiveValues( Kart = NULL,
                                Kgrp = NULL,
                                Ktyp = NULL)

Es werden drei reaktive Variablen angelegt und mit dem Wert "NULL" initialisiert.

### Fall 18

    observeEvent(eventExpr = input$KTyp, ignoreNULL = FALSE, ignoreInit = TRUE, {
        selected$Ktyp <- input$KTyp
        filter$Ktyp <- if(is.null(selected$Ktyp)) unique(customer$Ktyp) else selected$Ktyp
    })

Es wird eine observeEvent angelegt, welches auf Änderungen des Steuerelements "KTyp" reagiert. Bei Auslösen wird zunächst die Eingabe der Variable "selected$Ktyp" übergeben. Danach wird ausgewertet, ob und wenn, welche Werte übergeben worden sind. Dementsprechend wird die Variable "filter$Ktyp" entweder mit allen verfügbaren Werten belegt oder mit den ausgewählten.

### Fall 19

    data_filtered <- reactive({
        ...
    })

Ein reaktiver Datensatz namens "data_filtered" wird erzeugt.

### Fall 20

    DT::datatable(temp, filter = "top", options = list(pageLength = 5))

Eine datatable wird erzeugt. Als Datengrundlage dient der Datensatz "temp". Es werden Filter über den Spaltennamen platziert und es wird die Anzahl der gezeigten Zeilen spezifiziert.

### Fall 21

    leaflet(data=customer) %>%
        addProviderTiles(providers$OpenStreetMap.DE) %>%
        fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude))

Eine Leaflet-Karte wird erzeugt. Als Basemap dient die OpenStreetMap-Karte. Es wird auf den Kartenausschnitt fokusiert, der sämtlich Einträge des Datensatzes "customer" beinhaltet.

### Fall 22

    observe(
        leafletProxy("map", data = map_data()) %>%
        clearMarkers() %>% clearMarkerClusters() %>%
        addAwesomeMarkers(  clusterOptions = markerClusterOptions(),
                            lng = ~Longitude_customer, lat = ~Latitude_customer, popup = ~popup_content))

Ein Leaflet-Proxy wird erzeugt. Dieser ändert nicht die Karte(neinstellung) sondern nur die angezeigten Objekte. Letztere werden aus dem reaktiven Datensatz "map_data()" entnommen. Nach einer Änderung werden die alten Daten von der Karte gelöscht und die neuen angezeigt.

### Fall 23

    wdays <- seq(from=1, to=nrow(shpm_ts))

In der Variable "wdays" werden die Zahlen 1 bis "nrow(shpm_ts)" abgespeichert. Dabei repräsentiert "nrow(shpm_ts)" die Anzahl der Zeilen des Datensatzes shpm_ts.

### Fall 24

    fwrite(shpm_ts, 'lin_reg.csv', dec=",", sep=";")

Der Datensatz "shpm_ts" wird in die Datei "lin_reg.csv" geschrieben. Dabei wird festgelegt, wie die Spalten getrennt sind und was der Dezimal-Separator ist.

### Fall 25

    lm <- lm(data = us_change, formula = Consumption ~ Income + Production + Savings + Unemployment)
    lm %>% summary()

Eine multiple lineare Regression wird auf den Datensatz "us_change" angewendet. "Consumption" ist die abhängige Variable und es gibt 4 unabhängige Variablen. Anschließend werden die wichtigsten Kennzahlen der Regressionsanalyse ausgegeben.

### Fall 26

    pred_02 <- predict(lm, newdata=new)

Das gefittete lm-Modell wird auf den Datensatz "new" angewendet um eine Prognose zu machen. Das Ergebnis wird in "pred_02" abgespeichert.

### Fall 27

    data %>%
        model(
            SES = ETS(obs ~ error("A") + trend("N") + season("N"))
        ) %>%
        forecast(h=5) %>%
        pull(.mean)

Es wird eine Exponentielle Glättung 1. Ordnung auf den Datensatz "data" angewendet und es werden die ersten 5 Prognosewerte ausgegeben.

### Fall 28

    fit <- aus_holidays %>%
        model(
            additive = ETS(Trips ~ error("A") + trend("A") + season("A")),
            multiplicative = ETS(Trips ~ error("M") + trend("A") + season("M"))
        )

Auf Basis des Datensatzes "aus_holidays" wird eine Exponentielle Glättung 3. Ordnung ausgeführt; einmal mit additivem und einemal mit multiplikativem Zusammenhang zwischen Trendmodell und Saisonalität.


### Fall 29

    obs <- c(106.8, 129.2, 153.0, 149.1, 158.3, 132.9, 149.8, 140.3, 138.3, 152.2, 128.1)
    zoo::rollapply(data=obs, width=3, FUN=mean)

Auf die Zahlenreihe "obs" wird ein gleitender Durschschnitt über 3 Beobachtungen ausgegeben.

### Fall 30

    shpm_ts <- shpm_ts %>%
        mutate( Di = ifelse(week_day == "Tuesday", 1,0),
                Mi = ifelse(week_day == "Wednesday", 1,0),
                Do = ifelse(week_day == "Thursday", 1,0),
                Fr = ifelse(week_day == "Friday", 1,0))

Es findet eine Dummy-Kodierung statt. Dabei wird die Spalte "week_day" ausgewertet und, je nachdem um welchen Wochentag es sich handelt, in die Spalten "Di", "Mi", "Do" und "Fr" eine 1 oder 0 gesetzt.


## Task 2: SQL-Statements

Das THRO-Verwaltungsprogramm ist ausgefallen und Sie können auf die Datenbank-Inhalte nur noch per SQL zugreifen. Geben Sie die SQL-Befehle (jeweils nur ein Befehl!) an, um die nachfolgenden Fragen zu beantworten. Ihnen steht der logische Entwurf der Datenbank zur Verfügung.

Logischer Entwurf:

    1. Student		(Matrikelnummer, Name, Wohnort, Jahr_der_Immatrikulation, Geschlecht)
    2. Zahlung		(ZahlungsID, Matrikelnummer, Semester, Beitrag)

1. Zeige mir den Namen des Studenten, der die letzte/höchste Matrikelnummer hat.
2. Wie viele Studenten sind weiblich, wie viele männlich?
3. Zeige an, wie viel die einzelnen Studenten (Name!) in Summe an Studiengebühren bezahlt haben.

Lösung:

    SELECT Name
    FROM Student
    WHERE Matrikelnummer = (SELECT max(Matrikelnummer) FROM Student)

    SELECT Geschlecht, count(*)
    FROM Student
    GROUP BY Geschlecht

    SELECT Name, sum(Beitrag)
    FROM Student INNER JOIN Zahlung
    ON Student.Matrikelnummer =  Zahlung.Matrikelnummer
    GROUP BY Name
