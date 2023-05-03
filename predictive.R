
setwd("/Users/kefo395/Library/CloudStorage/Dropbox/Uni/TH Rosenheim/01 - Lehre/01 Business Analytics/thro-ba")

# Libraries ---------------------------------------------------------------

# Database
library(RSQLite)
library(DBI)

# Data Wrangling & Plotting
library(tidyverse)
library(data.table)

# Machine Learning
library(fpp3)


# Data Loading ------------------------------------------------------------

con <- dbConnect(RSQLite::SQLite(), "thro_shpm.db", encoding="utf-8")

db_customer <- dbGetQuery(con, "SELECT * FROM customer")
db_plant <- dbGetQuery(con, "SELECT * FROM plant")
db_shipment <- dbGetQuery(con, "SELECT * FROM shipment")

dbDisconnect(con)

shpm <- db_shipment %>%
  inner_join(db_customer, by = c("Ship-to2" = "ID")) %>%
  inner_join(db_plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
  as_tibble() %>%
  mutate(del_date = dmy(Delivery_day))





















