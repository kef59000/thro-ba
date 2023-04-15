
# setwd("C:/Users/LocalAdmin/Dropbox/TH Rosenheim/01 - Kurse/01 Business Analytics/thro-ba")

source('app_global.R')

ui <- dashboardPage(skin="yellow",
                    dashboardHeader(title="TH-RO Analytics"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Descriptive Analytics", tabName="descriptive_analytics", icon=icon("dashboard"))
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName="descriptive_analytics", descriptive_analytics_UI("descriptive_analytics"))
                      )
                    )
                  )


server <- function(input, output){
  
  callModule(descriptive_analytics, "descriptive_analytics")
}

shinyApp(ui = ui, server = server)
