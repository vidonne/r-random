## Trying simple curve for the map

# Load packages
library(tidyverse)
library(rnaturalearth)
library(sf)

# Polygons
poly_sf <- ne_countries(returnclass = "sf") |>
  filter(
    region_un == "Americas"
  )

# Points coord
# Country list
coi <- c("ARG", "CHL", "COL", "BOL", "ECU", "COL", "PAN", "VEN", "BRA", "PER")

point_sf <- poly_sf |>
  st_centroid() |>
  filter(sov_a3 %in% coi) |>
  select(admin, adm0_a3) |>
  rename(
    country = admin,
    iso = adm0_a3
  )

point_coord <- point_sf |>
  st_coordinates()

point_nocoord <- point_sf |>
  st_drop_geometry()

point_df <- bind_cols(point_nocoord, point_coord)

View(point_df)

# Routes
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

# Join point coordinates with origin/dest of routes
orig_dest <- left_join(rel, point_df, by = c("origin" = "iso"))
orig_dest <- left_join(orig_dest, point_df, by = c("dest" = "iso"))

View(orig_dest)

# Map
proj_laea <- "+proj=laea +lon_0=-77.34 +lat_0=7.37 +datum=WGS84 +units=m +no_defs"

ggplot() +
  geom_sf(data = poly_sf) +
  geom_curve(
    data = orig_dest,
    aes(x = X.x, y = Y.x, xend = X.y, yend = Y.y, color = total),
    curvature = -0.2
  ) +
  coord_sf(
    crs = st_crs(proj_laea),
    default_crs = 4326
  ) +
  theme_void()

# Loosing multiple origin capabilities

