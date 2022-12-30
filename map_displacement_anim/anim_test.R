
# Setup -------------------------------------------------------------------

# Load packages
library(tidyverse)
library(gganimate)
library(rnaturalearth)
library(sf)


# Data --------------------------------------------------------------------

# Lambert asymuthal projection
proj_laea <- "+proj=laea +lon_0=-77.34 +lat_0=7.37 +datum=WGS84 +units=m +no_defs"

poly_sf <- ne_countries(continent = c("North America", "South America"), returnclass = "sf")

city_df <- read_csv(file = "routes.csv") 
  
city_df <- arrange(city_df, step)

stops_df <- read_csv(file = "routesid.csv")

stops_sf <- st_as_sf(stops_df, coords = c("lon", "lat"))
st_crs(stops_sf) <- 4326

route_sf <- group_by(stops_sf, order) |> 
  summarise(n = n()) |> 
  st_cast("LINESTRING")

arcs_sf <- st_segmentize(route_sf, dfMaxLength = 0.5)

# SF approach

ggplot() +
  geom_sf(data = poly_sf) +
  #geom_sf(data = stops_sf) +
  geom_sf(data = arcs_sf) +
  coord_sf(default_crs = sf::st_crs(4326),
           crs = st_crs(proj_laea),
           xlim = c(-60, -100),
           ylim = c(0, 20))

# Simple

# with path
city_df |> 
  ggplot(aes(x = lon, y = lat)) +
  geom_sf(data = poly_sf, inherit.aes = FALSE) +
  geom_path() +
  geom_point(aes(group = step)) +
  coord_sf(default_crs = sf::st_crs(4326),
           crs = st_crs(proj_laea),
           xlim = c(-60, -100),
           ylim = c(0, 20)) +
  theme_void() +
  transition_reveal(step)


city_df |> 
  ggplot(aes(x = lon, y = lat)) +
  geom_sf(data = poly_sf, inherit.aes = FALSE) +
  geom_point() +
  coord_sf(default_crs = sf::st_crs(4326),
           crs = st_crs(proj_laea),
           xlim = c(-60, -100),
           ylim = c(0, 20)) +
  theme_void() +
  transition_time(step) +
  shadow_trail(alpha = .5) #+
  #view_follow()

