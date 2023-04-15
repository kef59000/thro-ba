
# Libraries ---------------------------------------------------------------
# Database access
library(RSQLite)
library(DBI)

# Data Wrangling & Plotting
library(tidyverse)

# Shiny
library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

# Maps
library(leaflet)


# Database Connection -----------------------------------------------------
con <- dbConnect(RSQLite::SQLite(), "thro_shpm.db")


# Master Data -------------------------------------------------------------
customer <- dbGetQuery(con, "SELECT * FROM customer") %>% as_tibble()
plant <- dbGetQuery(con, "SELECT * FROM plant") %>% as_tibble()


# Modules -----------------------------------------------------------------
source('app_descriptive.R')

