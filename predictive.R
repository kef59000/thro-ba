
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

new <- data.frame(wdays = c(253, 254, 255))
pred_01 <- predict(lm, newdata = new)
pred_01

ggplot(shpm_ts, aes(x=del_date, y=TO_total)) +
  geom_line() +
  geom_point() +
  geom_line(y=fitted(lm), color="red")


# Multiple linear regression ----------------------------------------------

us_change

us_change %>% fwrite('us_change.csv', sep=";", dec=",")

lm <- lm(data = us_change, formula = Consumption ~ Income + Production + Savings + Unemployment)
lm %>% summary()

new <- data.frame(Income = c(1,2,3),
                  Production = c(1,2,3),
                  Savings = c(1,2,3),
                  Unemployment = c(1,2,3))

pred_02 <- predict(lm, newdata=new)
pred_02


# Multiple regression with Dummy variables --------------------------------

shpm_ts <- shpm_ts %>%
  mutate(week_day = weekdays(del_date))

shpm_ts <- shpm_ts %>%
  mutate(Di = ifelse(week_day == "Tuesday", 1,0),
         Mi = ifelse(week_day == "Wednesday", 1,0),
         Do = ifelse(week_day == "Thursday", 1,0),
         Fr = ifelse(week_day == "Friday", 1,0)) %>%
  select(2:3, 5:8)

shpm_ts %>% fwrite('dummy.csv', sep=";", dec=",")

lm <- lm(data=shpm_ts, formula = TO_total ~ wdays + Di + Mi + Do + Fr)
lm %>% summary()

ggplot(data=shpm_ts, aes(x=wdays)) +
  geom_line(aes(y=TO_total)) +
  geom_line(aes(y=fitted(lm)), color="red")



# TS: Moving Averages -----------------------------------------------------

obs <- c(106.8, 129.2, 153.0, 149.1, 158.3, 132.9, 149.8, 140.3, 138.3, 152.2, 128.1)
zoo::rollapply(data=obs, width=3, FUN=mean)



# TS: EXPO-1 --------------------------------------------------------------

obs <- c(134.5, 106.8, 129.2, 153.0, 149.1, 158.3, 132.9, 149.8, 140.3, 138.3, 152.2, 128.1)

data <- tibble(idx = seq(from=1, to=length(obs)),
               obs = obs) %>%
  as_tsibble(index=idx)

data %>%
  model(
    SES = ETS(obs ~ error("A") + trend("N") + season("N"))
  ) %>%
  forecast(h=5) %>%
  pull(.mean)



# TS: EXPO-2 --------------------------------------------------------------

obs <- c(26.8, 39.2, 72.3, 71.3, 83.2, 92.9, 121.9, 112.1, 115.8, 154.2, 175.2)

data <- tibble(idx = seq(from=1, to=length(obs)),
               obs = obs) %>%
  as_tsibble(index=idx)

data %>%
  model(
    Holt = ETS(obs ~ error("A") + trend("A") + season("N"))
  ) %>%
  forecast(h=5) %>%
  pull(.mean)



# TS: EXPO-3 --------------------------------------------------------------

aus_holidays <- tourism %>%
  filter(Purpose == 'Holiday') %>%
  summarise(Trips = sum(Trips)/1e3)


fit <- aus_holidays %>%
  model(
    additive = ETS(Trips ~ error("A") + trend("A") + season("A")),
    multiplicative = ETS(Trips ~ error("M") + trend("A") + season("M"))
  )

fc <- fit %>%
  forecast(h="3 years")
fc

fc %>%
  autoplot(aus_holidays, level = NULL) +
  labs(title="Australian domestic tourism",
       y = "Overnight trips (millions)") +
  guides(colour = guide_legend("Forecast"))

