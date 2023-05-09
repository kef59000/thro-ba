
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


# Plotting time series data -----------------------------------------------

shpm_ts <- shpm %>%
  group_by(del_date) %>%
  summarise(TO_total = sum(GWkg, na.rm = TRUE)/1000) %>%
  ungroup() %>%
  arrange(del_date)


ggplot(shpm_ts, aes(x=del_date, y=TO_total)) +
  geom_line() +
  geom_point() +
  theme_set(theme_bw()) +
  labs(title = "Shipments",
       subtitle = paste0("Calendar Year(s): ", unique(year(shpm_ts$del_date))),
       x = "Delivery Date",
       y = "Tonnage Delivered")


# Simple linear regression ------------------------------------------------

wdays <- seq(from=1, to=nrow(shpm_ts))
shpm_ts <- cbind(shpm_ts, wdays)

lm <- lm(data = shpm_ts, formula = TO_total ~ wdays)
lm %>% summary()

# TO_total = 1346.5182 - 0.3215 * wdays

fwrite(shpm_ts, 'lin_reg.csv', dec=",", sep=";")








