# Load packages
library(tidyverse)
library(rnaturalearth)
library(sf)
library(tmap)

# Polygons
poly_sf <- ne_countries(returnclass = "sf") |>
  filter(
    region_un == "Americas"
  )

coi <- c("ARG", "CHL", "COL", "BOL", "ECU", "COL", "PAN", "VEN", "BRA", "PER")

point_sf <- poly_sf |>
  st_centroid() |>
  filter(sov_a3 %in% coi) |>
  select(admin, adm0_a3) |>
  rename(
    country = admin,
    iso = adm0_a3
  )

tm_shape(poly_sf, projection = "+proj=laea +lon_0=-77.34 +lat_0=7.37 +datum=WGS84 +units=m +no_defs") +
  tm_fill() +
  tm_borders() +
  tm_shape(point_sf) +
  tm_dots()
