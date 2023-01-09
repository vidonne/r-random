# Load packages
library(tidyverse)
library(edgebundle)
library(igraph)
library(rnaturalearth)
library(sf)

# Polygons
poly_sf <- ne_countries(returnclass = "sf") |>
  filter(
    region_un == "Americas",
    !(adm0_a3 %in% c("CAN", "GRL", "USA"))
  )
glimpse(poly_sf)
View(poly_sf)

# Country list
coi <- c("ARG", "CHL", "COL", "BOL", "ECU", "COL", "PAN", "VEN", "BRA", "PER")

# Centroids
point_sf <- poly_sf |>
  st_centroid() |>
  filter(sov_a3 %in% coi) |>
  select(admin, adm0_a3) |>
  rename(
    country = admin,
    iso = adm0_a3
  )

View(point_sf)
# Relations
rel <- data.frame(
  origin = c(
    "ARG", "CHL", "BOL", "BRA", "PER", "ECU"
  ),
  dest = c(
    "CHL", "PER", "PER", "PER", "ECU", "COL"
  ),
  total = c(
    10, 15, 5, 10, 45, 60
  )
) |>
  mutate(id = paste(origin, "-", dest))
View(rel)

rel_long <- pivot_longer(rel,
  cols = 1:2,
  names_to = "orgdest",
  values_to = "iso"
)

point_coord <- point_sf |>
  st_coordinates()

point_nocoord <- point_sf |>
  st_drop_geometry()

point_df <- bind_cols(point_nocoord, point_coord)

rel_long <- left_join(rel_long, point_df, by = c("iso" = "iso"))

rel_sf <- st_as_sf(rel_long, coords = c("X", "Y"))

routes_sf <- group_by(rel_sf, id) |>
  summarise(total = mean(total)) |>
  st_cast("LINESTRING")
st_crs(routes_sf) <- 4326
View(routes_sf)

# Plots
proj_laea <- "+proj=laea +lon_0=-77.34 +lat_0=7.37 +datum=WGS84 +units=m +no_defs"

ggplot() +
  geom_sf(data = poly_sf) +
  geom_sf(data = routes_sf, aes(linewidth = total)) +
  geom_sf(data = point_sf) +
  coord_sf(crs = st_crs(proj_laea)) +
  theme_void()

library(tmap)

tm_shape(poly_sf,
  # projection = "+proj=laea +lon_0=-77.34 +lat_0=7.37 +datum=WGS84 +units=m +no_defs",
  bbox = c(-85, -40, -50, 10)
) +
  tm_fill() +
  tm_borders() +
  tm_shape(routes_sf) +
  tm_lines() +
  tm_shape(point_sf) +
  tm_dots()
