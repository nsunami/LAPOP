# LAPOP - Ecuador Data Initial Inspection

# Load libraries
library(haven)
library(tidyverse)
library(purrr) # for a codebook


# Get Datasets from LAPOP Website (Focus on US-Ecuador)

# for 2016 (STATA Format)
# US Dataset
us2016_url <- "http://datasets.americasbarometer.org/database/files/2133069031United%20States%20LAPOP%20AmericasBarometer%202017%20V1.0_W.dta"
us2016 <- read_stata(us2016_url)
# Ecuador Dataset
ecuador2016_url <- "http://datasets.americasbarometer.org/database/files/1061044693Ecuador%20LAPOP%20AmericasBarometer%202016-17%20V1.0_W.dta"
ecuador2016 <- read_stata(ecuador2016_url)


# for 2014 (SPSS Format)
# US 
us2014_url <- "http://datasets.americasbarometer.org/database/files/68035371UnitedStates%20LAPOP%20AmericasBarometer%202014%20English%20v3.0_W.sav"
us2014 <- read_sav(us2014_url)
# Ecuador
ecuador2014_url <- "http://datasets.americasbarometer.org/database/files/698503995Ecuador%20LAPOP%20AmericasBarometer%202014%20Espanol%20v3.0_W.sav"
ecuador2014 <- read_sav(ecuador2014_url)
# Merge US and Ecuador Dataset (common variables only)
usecu2014 <- us2014 %>% bind_rows(ecuador2014)

## Create a codebook
# https://stackoverflow.com/questions/39671621/extract-the-labels-attribute-from-labeled-tibble-columns-from-a-haven-import-f
make_codebook <- function(tbl){
  n <- ncol(tbl)
  labels_list <- map(1:n, function(x) attr(tbl[[x]], "label") )
  # if a vector of character strings is preferable
  labels_vector <- map_chr(1:n, function(x) attr(tbl[[x]], "label") )
  vars_vector <- labels(tbl)[[2]]
  levels_vector <- lapply(lapply(tbl, table), length) %>% as_vector()
  return(tibble("var" = vars_vector, "label" = labels_vector, "levels" = levels_vector))
}

ecuador2014_codebook <- make_codebook(ecuador2014)
