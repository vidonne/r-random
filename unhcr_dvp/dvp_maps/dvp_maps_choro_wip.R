# Load packages
library(unhcrthemes)
library(tidyverse)
library(scales)
library(sf)

# Load data
df <- read_csv("https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/choropleth_map.csv")
poly_url <- "https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_polygons_simplified.json"
line_url <- "https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_lines_simplified.json"

# Transform data

# Add CRS to poly
poly <- st_read(poly_url) |> 
  st_set_crs(4326) |> 
  left_join(df, by = c("color_code" = "iso3"))
  

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
          aes(fill = refugees),
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  coord_sf(crs = st_crs('ESRI:54030'),
           expand = FALSE) +
  scale_linetype_manual(values = c(1, 2, 3, 4)) +
  # scale_fill_unhcr_c(breaks = c(1e4, 1e5, 1e6),
  #                    palette = "pal_blue",
  #                    guide = "colorsteps",
  #                    labels = scales::label_number(
  #                     scale_cut = cut_short_scale())) +
  # scale_fill_fermenter(direction = 1,
  #                      breaks = c(1e4, 1e5, 1e6),
  #                      labels = scales::label_number(
  #                      scale_cut = cut_short_scale()),
  #                      na.value = unhcr_pal(n = 5, name = "pal_grey")[2]) +
  scale_fill_stepsn(n.breaks = 10, colors = hcl.colors(10)) +
  labs(
    title = "Global Refugee displacement by country of asylum | 2021",
    caption = "The boundaries and names shown and the designations used on this map do not imply official endorsement or acceptance by the United Nations.\nSource: UNHCR Refugee Data Finder\n© UNHCR, The UN Refugee Agency"
  ) #+
  theme_unhcr_map()