
setwd("C:/Users/LocalAdmin/Dropbox/TH Rosenheim/01 - Kurse/01 Business Analytics/thro_ba")

# Libraries ---------------------------------------------------------------
# Database
library(RSQLite)
library(DBI)

# Data Wrangling & Plotting
library(data.table)
library(tidyverse)


# Get Data ----------------------------------------------------------------
# CSV
csv_customer <- fread("thro_shpmt/customer.csv", sep=";", header= TRUE, encoding = 'Latin-1')
csv_plant <- fread("thro_shpmt/plant.csv", sep=";", header= TRUE, encoding = 'Latin-1')
csv_shipment <- fread("thro_shpmt/shipment.csv", sep=";", header= TRUE, encoding = 'Latin-1')

# SQLite
con <- dbConnect(RSQLite::SQLite(), "thro_shpm.db", encoding = "utf-8")

dbWriteTable(con, "customer", csv_customer)
dbWriteTable(con, "plant", csv_plant)
dbWriteTable(con, "shipment", csv_shipment)

customer <- dbGetQuery(con, "SELECT * FROM customer")
plant <- dbGetQuery(con, "SELECT * FROM plant")
shipment <- dbGetQuery(con, "SELECT * FROM shipment")
dbDisconnect(con)
class(plant)


# Data Wrangling & EDA ----------------------------------------------------
shpm <- shipment %>%
  inner_join(customer, by = c("Ship-to2" = "ID")) %>%
  inner_join(plant, by = c("Plant" = "ID"), suffix = c("_customer", "_plant")) %>%
  as_tibble() %>%
  mutate(del_date = dmy(Delivery_day))


head(shpm, 3)
glimpse(shpm)

eda_plants <- shpm %>% select(Plant) %>% distinct()

eda_plant_DE17 <- shpm %>% filter(Plant == 'DE17')

eda_shpm_to <- shpm %>% mutate(tons = GWkg/1000)

eda_temp <- eda_shpm_to %>%
  group_by(Plant) %>%
  summarise(to = sum(tons)) %>%
  ungroup()

eda_temp <- shpm %>%
  group_by(del_date) %>%
  summarise(pal = sum(Pallets, na.rm=TRUE)) %>%
  ungroup()

eda_temp <- shpm %>%
  group_by(del_date, Plant) %>%
  summarise(pal = sum(Pallets, na.rm=TRUE)) %>%
  ungroup()

sum(shpm$GWkg)
min(shpm$GWkg)
mean(shpm$GWkg)
max(shpm$GWkg)

eda_temp <- eda_shpm_to %>%
  group_by(Plant) %>%
  summarise(sum_to = sum(tons, na.rm=TRUE),
            min_to = min(tons, na.rm=TRUE),
            mean_to = mean(tons, na.rm=TRUE),
            max_to = max(tons, na.rm=TRUE)) %>%
  ungroup()


# Basics ------------------------------------------------------------------
1+1

my_var <- 1
my_var <- "shpm"

my_vec <- c(1,2,3,4,5)
class(my_vec)

# Loop
for (i in 1:10) {
  print(paste("Num:", i))
}

# If-Else
if (my_var == 1) {
  print("my_var = 1")
} else if (my_var > 1) {
  print("my_var > 1")
} else {
  print("my_var < 1")
}

# Functions
my_func <- function(my_arg) {
  paste0("Hallo ", my_arg) %>% print()
}

my_func("Florian")



# Data Viz ----------------------------------------------------------------

# Pallets per Day
data <- shpm %>%
  group_by(del_date) %>%
  summarise(pal = sum(Pallets, na.rm = TRUE)) %>%
  ungroup()

ggplot(data) +
  geom_line(aes(x=del_date, y=pal), color = "red") +
  theme_set(theme_bw()) +
  labs(x = "Date", y = "Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title = element_text(size = 12, face = 4, hjust = 1))

# Pallets per Day and Plant
data <- shpm %>%
  group_by(del_date, Plant) %>%
  summarise(pal = sum(Pallets, na.rm = TRUE)) %>%
  ungroup()

ggplot(data) +
  geom_line(aes(x=del_date, y=pal, color = Plant)) +
  theme_set(theme_bw()) +
  labs(x = "Date", y = "Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title = element_text(size = 12, face = 4, hjust = 1))

ggplot(data) +
  geom_line(aes(x=del_date, y=pal)) +
  theme_set(theme_bw()) +
  labs(x = "Date", y = "Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title = element_text(size = 12, face = 4, hjust = 1)) +
  facet_wrap(~ Plant, nrow = 1)

ggplot(data) +
  geom_point(aes(x=del_date, y=pal)) +
  theme_set(theme_bw()) +
  labs(x = "Date", y = "Pallets") +
  ggtitle("Pallets per Day") +
  theme(plot.title = element_text(size = 12, face = 4, hjust = 1)) +
  facet_wrap(~ Plant, nrow = 1) +
  geom_violin(aes(x=del_date, y=pal), fill = "gray80", alpha = 0.5)

