#### Preamble ####
# Purpose: Simulates TTC StreetCar Delay by the hour of the day
# Author: Isha Juneja
# Date: 22 January 2024 
# Contact: isha.juneja@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(ggplot2)

#### Simulate data: TTC StreetCar Delay by the hour of the day ####

# The following simulation is based on the code from: 
#https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate


# No delay: 0 - 5 minutes
# Small delay: 6 - 15 mins
# Big delay: 16 mins or more

simulated_data <-
  tibble(
    # Randomly sample the eleven TTC Streetcar lines
    StreetcarLine = sample(
      x = c("501", "503", "504", "505", "506", "507", "508", "509", "510", "511", "512"),
      size = 75,
      replace = TRUE
    ),
    
    # Randomly pick an option, with replacement, 24 times
    Hour = sample(
      x = c("0:00","1:00","2:00","3:00","4:00","5:00", "6:00","7:00","8:00",
            "9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00",
            "17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00"),
      size = 75,
      replace = TRUE
    ),
    
    # Randomly pick a delay
    MinDelay = as.integer(runif(n = 75, min = 0, max = 30))
  )

simulated_data <-
simulated_data %>%
  mutate(TypeofDelay = case_when(MinDelay <= 5 ~ "No delay",
                                     MinDelay <= 15 ~ "Small delay",
                                     MinDelay <= 30 ~ "Big delay"))


NoDelay <-
simulated_data |> filter(TypeofDelay == "No delay") %>% group_by(Hour) %>% tally()
# Sorting the x-axis according to hour
NoDelay <- NoDelay[order(strptime(NoDelay$Hour, format="%H:%M")),]


SmallDelay <-
  simulated_data |> filter(TypeofDelay == "Small delay") %>% group_by(Hour) %>% tally()
# Sorting the x-axis according to hour
SmallDelay <- SmallDelay[order(strptime(SmallDelay$Hour, format="%H:%M")),]


BigDelay <-
  simulated_data |> filter(TypeofDelay == "Big delay") %>% group_by(Hour) %>% tally()
# Sorting the x-axis according to hour
BigDelay <- BigDelay[order(strptime(BigDelay$Hour, format="%H:%M")),]


#### Graph of TTC StreetCar Delay by the hour of the day ####

# No Delay Barplot
ggplot(NoDelay[order(NoDelay$Hour),], aes(x=Hour, y=n)) + 
  geom_bar(stat = "identity", width=0.2) 

# Small Delay Barplot
ggplot(SmallDelay[order(SmallDelay$Hour),], aes(x=Hour, y=n)) + 
  geom_bar(stat = "identity", width=0.2) 

# Big Delay Barplot
ggplot(BigDelay[order(BigDelay$Hour),], aes(x=Hour, y=n)) + 
  geom_bar(stat = "identity", width=0.2) 



#### Data Validation ####

# Check that we have categorized three type of delays correctly
simulated_data$TypeofDelay |>
  unique() == c( "Small delay", "No delay", "Big delay")

simulated_data$TypeofDelay |>
  unique() |>
  length() == 3

# Check minimum amount of delay
simulated_data$MinDelay |> min() == 0

#Check that the Streetcar Line Numbers are in range
simulated_data$StreetcarLine |> min() == 501
simulated_data$StreetcarLine |> max() == 512

#Check the representation of Hour
simulated_data$Hour |> class() == "character"

