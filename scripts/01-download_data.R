#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto
# Author: Isha Juneja
# Date: 23 January 2024
# Contact: isha.juneja@mail.utoronto.ca 
# License: MIT
# Pre-requisites:None

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)


#### Download data ####

# get package
package <- show_package("b68cb71b-44a7-4394-97e2-5d2f41462a5d")
package

delay2023_packages <- 
  list_package_resources(package) |>
  filter(name == "ttc-streetcar-delay-data-2023") |>
  get_resource()


write_csv(
  x = delay2023_packages,
  file = "inputs/data/ttc-streetcar-delay-data-2023.csv"
)

head(delay2023_packages)

