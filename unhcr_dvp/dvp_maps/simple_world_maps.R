# Load packages
library(unhcrthemes)
library(tidyverse)
library(sf)


poly <- read_sf("maps/world_polygons_simplified.geojson")
line <- read_sf("maps/world_lines_simplified.geojson") |> 
  filter(type != "coastline")

centroid <- poly |> 
  st_centroid(of_largest_polygon = TRUE) %>% 
  mutate(lon = sf::st_coordinates(.)[,1],
         lat = sf::st_coordinates(.)[,2]) |> 
  select(iso3, lon, lat)

write_csv(centroid, "wrl_points.csv")

ggplot() +
  geom_sf(data = poly, color = "transparent") +
  geom_sf(data = line, aes(linetype = type), size = 0.1) +
  coord_sf(crs = "ESRI:54030") +
  scale_linetype_manual(values = c(2, 4, 3, 1)) +
  theme_unhcr_map()

