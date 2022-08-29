# Load packages
library(unhcrthemes)
library(tidyverse)
library(scales)
library(sf)

# Load data
df <- read_csv("https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/bubble_map.csv")
poly <- st_read("https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_polygons_simplified.json")
line <- st_read("https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_lines_simplified.json")

# Transform data

# Transform point to sf object
df <- df |> 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)
# Add CRS to poly
poly <- poly |> 
  st_set_crs(4326)

# Sort line type
line <- line |>
  mutate(
    type = as_factor(type) |>
      fct_relevel("solid", "dashed", "dotted", "dashed-dot")
  ) |> 
  st_set_crs(4326)

# Plot
ggplot() +
  geom_sf(data = poly,
          fill = unhcr_pal(n = 5, "pal_grey")[2],
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  geom_sf(data = df,
          aes(size = ref),
          shape = 21,
          fill = unhcr_pal(n = 1, "pal_blue"),
          color = unhcr_pal(n = 5, "pal_blue")[5],
          alpha = 0.3) +
  scale_linetype_manual(values = c(1, 2, 3, 4)) +
  scale_size_area(max_size = 12,
                  labels = scales::label_number(
                    scale_cut = cut_short_scale()
                  ),
                  breaks = c(1e5, 1e6, 5e6)) +
  labs(
    title = "Global Refugee displacement by country of origin | 2021",
    caption = "The boundaries and names shown and the designations used on this map do not imply official endorsement or acceptance by the United Nations.\nSource: UNHCR Refugee Data Finder\n© UNHCR, The UN Refugee Agency"
  ) +
  coord_sf(crs = st_crs('ESRI:54030'),
           expand = FALSE) +
  theme_unhcr_map()
 