# Load packages
library(unhcrthemes)
library(unhcrdatapackage)
library(tidyverse)
library(scales)
library(sf)
library(scatterpie)


# Create df with lat lon and Robinson trans -------------------------------

base_geo <- unhcrdatapackage::reference |> 
  select(iso_3, ctryname, Latitude, Longitude) |> 
  rename(iso3c = iso_3,
         name = ctryname,
         lon = Longitude,
         lat = Latitude) |> 
  filter(!is.na(iso3c),
         !is.na(lat))

coord_rob <- base_geo |> 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326) |> 
  st_transform(crs = 'ESRI:54030') |> 
  st_coordinates() |> 
  as_tibble() |> 
  rename(lon_rob = X,
         lat_rob = Y)

coord_df <- bind_cols(base_geo, coord_rob)


# Create population data and radius ---------------------------------------

base_pop <-unhcrdatapackage::end_year_population_totals_long |> 
  filter(Year == 2021,
         Population.type == "REF" | Population.type == "ASY" | Population.type == "VDA") |> 
  group_by(CountryOriginCode, Population.type) |> 
  summarise(pop_tot = sum(Value)) |> 
  pivot_wider(names_from = Population.type, values_from = pop_tot) |> 
  mutate(total = sum(across(REF:VDA), na.rm = TRUE)) |> 
  ungroup() |> 
  rename(iso3c = CountryOriginCode,
         ref = REF,
         asy = ASY,
         vda = VDA)

max_pop <- max(base_pop$total)


base_radius <- base_pop |> 
  mutate(
    radius = sqrt(total)/sqrt(max_pop)
  ) |> 
  replace_na(list(
    ref = 0,
    asy = 0,
    vda = 0
  ))



# Put coords and pop together ---------------------------------------------

df <- base_radius |> 
  left_join(coord_df, by = "iso3c") |> 
  relocate(ref:radius, .after = last_col())

# Load data geo data
poly_url <- "https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_polygons_simplified.json"
line_url <- "https://raw.githubusercontent.com/GDS-ODSSS/unhcr-dataviz-platform/master/data/geospatial/world_lines_simplified.json"

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


# Plot --------------------------------------------------------------------

# Plot radius
ggplot() +
  geom_sf(data = poly,
          fill = unhcr_pal(n = 5, "pal_grey")[2],
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  geom_scatterpie(data = df,
                  aes(x = lon_rob,
                      y = lat_rob,
                      r = radius * 1e6),
                  cols = c("ref", "asy", "vda"),
                  color = FALSE,
                  alpha = .7) +
  scale_fill_unhcr_d(palette = "pal_unhcr_poc", 
                     nmax = 9,
                     order = c(1, 3, 9),
                     label = c("Refugees", "Asylum-seekers", "Venezuelans displaced abroad")) +
  geom_scatterpie_legend(radius = df$radius * 1e6, x = 0, y = 0, n = 3,) +
  labs(
    title = "Global displacement across border by country of origin | 2021",
    caption = "The boundaries and names shown and the designations used on this map do not imply official endorsement or acceptance by the United Nations.\nSource: UNHCR Refugee Data Finder\n© UNHCR, The UN Refugee Agency"
  ) +
  coord_sf(crs = st_crs('ESRI:54030'),
           expand = FALSE) +
  theme_unhcr_map()

# Plot try with area calculation
ggplot() +
  geom_sf(data = poly,
          fill = unhcr_pal(n = 5, "pal_grey")[2],
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  geom_scatterpie(data = df,
                  aes(x = lon_rob,
                      y = lat_rob,
                      r = sqrt(total/pi) * 700),
                  cols = c("ref", "asy", "vda"),
                  color = FALSE,
                  alpha = .7) +
  
  scale_fill_unhcr_d(palette = "pal_unhcr_poc", 
                     nmax = 9,
                     order = c(1, 3, 9),
                     label = c("Refugees", "Asylum-seekers", "Venezuelans displaced abroad")) +
  labs(
    title = "Global displacement across border by country of origin | 2021",
    caption = "The boundaries and names shown and the designations used on this map do not imply official endorsement or acceptance by the United Nations.\nSource: UNHCR Refugee Data Finder\n© UNHCR, The UN Refugee Agency"
  ) +
  coord_sf(crs = st_crs('ESRI:54030'),
           expand = FALSE) +
  theme_unhcr_map()


# Plot normal total
ggplot() +
  geom_sf(data = poly,
          fill = unhcr_pal(n = 5, "pal_grey")[2],
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  geom_scatterpie(data = df,
                  aes(x = lon,
                      y = lat,
                      r = total / 1e6),
                  cols = c("ref", "asy", "vda"),
                  color = FALSE,
                  alpha = .7) 

ggsave("pie_size.svg", path = "maps/")


max_symbol_size <- 2.8
max_value <- 6988776
afg_value <- 2975725

(sqrt(afg_value)/sqrt(max_value)) * max_symbol_size

ggplot() +
  geom_sf(data = poly,
          fill = unhcr_pal(n = 5, "pal_grey")[2],
          color = "transparent") +
  geom_sf(data = line,
          aes(linetype = type),
          color = "white",
          size = .25,
          show.legend = FALSE) +
  geom_scatterpie(data = df,
                  aes(x = lon_rob,
                      y = lat_rob,
                      r = radius * 1e6),
                  cols = c("ref", "asy", "vda"),
                  color = FALSE,
                  alpha = .7) +
  coord_sf(crs = st_crs('ESRI:54030'))

ggsave("pie_radius.svg", path = "maps/")

max_radius <- 4.216
(sqrt(afg_value)/sqrt(max_value)) * max_radius

ggplot(data = filter(poly, iso3 == "IRQ")) +
  geom_sf()
           