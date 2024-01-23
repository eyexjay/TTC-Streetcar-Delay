#### Preamble ####
# Purpose: Cleans the raw TTC Streetcar Delay data and categorizes each type of delay
# Author: Isha Juneja
# Date: 23 January 2024
# Contact: isha.juneja@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 01-download_data.R

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)


readr::read_csv("inputs/data/ttc-streetcar-delay-data-2023.csv")

#### Clean data ####
raw_data <- read_csv(file="inputs/data/ttc-streetcar-delay-data-2023.csv", show_col_types=FALSE)

raw_data <-select(raw_data, Line, Time, `Min Delay`)

cleaned_data <-
  raw_data |>
  rename(
    StreetcarLine = Line,
    Hour = Time,
    MinDelay = `Min Delay`
  )


cleaned_data <-
  cleaned_data %>%
  mutate(TypeofDelay = case_when(MinDelay <= 5 ~ "No delay",
                                 MinDelay <= 15 ~ "Small delay",
                                 MinDelay <= 30 ~ "Big delay"))


NoDelay <-
  cleaned_data |> filter(TypeofDelay == "No delay") %>% group_by(Hour) %>% tally()

SmallDelay <-
  cleaned_data |> filter(TypeofDelay == "Small delay") %>% group_by(Hour) %>% tally()

BigDelay <-
  cleaned_data |> filter(TypeofDelay == "Big delay") %>% group_by(Hour) %>% tally()


cleaned_data

#### Save data ####
write_csv(cleaned_data, "outputs/data/cleaned_ttc-streetcar-delay-2023_data.csv")
