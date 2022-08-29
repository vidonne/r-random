# Load packages
library(tidyverse)
library(unhcrdatapackage)
library(unhcrthemes)
library(httr2)
library(jsonlite)
library(readxl)
library(ggbraid)
library(scales)
library(ggtext)

# Forcibly displaced
glimpse(unhcrdatapackage::end_year_population_totals_long)
unique(unhcrdatapackage::end_year_population_totals_long$Population.type)

unhcr <- unhcrdatapackage::end_year_population_totals_long |>
    filter(
        Year >= 2012 & Year <= 2021,
        Population.type == "REF" |
        Population.type == "ASY" |
        Population.type == "VDA"
    )  |>
    group_by(Year, Population.type.label) |>
    summarise(total = sum(Value, na.rm = TRUE)) |>
    rename(year = Year, pop_type = Population.type.label)

# We start by creating a request that uses the base API url
api_ref <- request("https://api.unhcr.org/population/v1")
idmc_api <- api_ref |>
  # Then we add on the path
  req_url_path_append("idmc") |>
  # Add query parameters
  req_url_query(yearFrom = 2012, yearTo = 2021) |>
  req_perform() |>
  resp_body_json()

idmc <- bind_rows(idmc_api$items) |>
    select(year, total) |>
    mutate(pop_type = "IDPs") |>
    relocate(total, .after = pop_type)

unrwa_api <-  api_ref |>
  # Then we add on the path
  req_url_path_append("unrwa") |>
  # Add query parameters
  req_url_query(yearFrom = 2012, yearTo = 2021) |>
  req_perform() |>
  resp_body_json()

unrwa <- bind_rows(unrwa_api$items) |>
    select(year, total) |>
    mutate(pop_type = "Refugees under UNRWA's mandate") |>
    relocate(total, .after = pop_type)

estim <- tribble(
    ~year, ~pop_type, ~total,
    2022, "Latest available estimates", 101088700,
)

force_displ <- rbind(unhcr, idmc, unrwa, estim) |>
    mutate(pop_type = case_when(
        pop_type == "Refugees" ~ "Refugees under UNHCR's mandate",
        pop_type == "Venezuelans Displaced Abroad" ~ "Venezuelans displaced abroad",
        TRUE ~ pop_type
    )) |>
    mutate(pop_type = factor(pop_type,
                      levels = c("Latest available estimates", 
                      "Venezuelans displaced abroad", "Asylum-seekers", 
                      "Refugees under UNRWA's mandate",
                      "Refugees under UNHCR's mandate", "IDPs")))



# Demographics

dem_2021 <- unhcrdatapackage::demographics |> 
  filter(Year == 2021)

glimpse(dem_2021)

unhcrdatapackage::demographics |> 
  filter(Year == 2021) |> 
  mutate(ChildrenTotal = rowSums(across(Female04:Female1217), na.rm = TRUE) + rowSums(across(Male04:Male1217), na.rm = TRUE)) |> 
  select(Population.type, Population.type.label, FemaleTotal, ChildrenTotal, Total) |> 
  group_by(Population.type, Population.type.label) |> 
  summarise(f_total = sum(FemaleTotal, na.rm = TRUE),
            c_total = sum(ChildrenTotal, na.rm = TRUE),
            total = sum(Total, na.rm = TRUE),
            f_perc = f_total/total,
            c_perc = c_total/total) |>
  filter(Population.type != "HST",
         Population.type != "IDP") |> 
  select(Population.type, Population.type.label, f_perc, c_perc) |> 
  rename(pop_type_code = Population.type,
         pop_type_label = Population.type.label,
         female_perc = f_perc,
         children_perc = c_perc)
  

dem_table <- tribble(
  ~pop_group, ~female, ~children,
  "Refugees", "0.49", "0.49",
  "People refugee-like situations", "0.41", "0.52",
  "Palestine refugees under UNRWA's", "0.49", "0.31",
  "Venezuelans displaced abroad", "0.51", "0.28",
  "Asylum-seekers", "0.4", "0.25",
  "Internally displaced people", "0.5", "0.43",
  "Refugee returnees", "0.54", "0.58",
  "IDP returnees", "0.5", "0.58",
  "Stateless Persons", "0.52", "0.44",
  "Others of concern", "0.54", "0.28",
)

dem_plot <- tribble(
  ~age, ~group, ~male, ~female, ~malefill,
  "60+", "displ", 0.03, 0.03, "male_displ",
  "18-59", "displ", 0.27, 0.26, "male_displ",
  "0-17", "displ", 0.21, 0.20, "male_displ",
  "60+", "wp", 0.06, 0.07, "male_wp",
  "18-59", "wp", 0.29, 0.28, "male_wp",
  "0-17", "wp", 0.16, 0.15, "male_wp",
)

dem_wide <- dem_plot |>
  pivot_wider(names_from = group, values_from = c(male, female))

dem_plot 

ggplot(dem_plot) +
  geom_col(aes(-male, age, fill = malefill), position = "dodge",
           width = 0.3) +
  geom_col(aes(female, age, fill = group), position = "dodge",
           width = 0.3)

ggplot(dem_wide) +
  geom_col(aes(-male_wp, age),
           width = 0.3) +
  geom_col(aes(-male_displ, age), 
           width = 0.3) +
  geom_col(aes(female_wp, age), 
           width = 0.3) +
  geom_col(aes(female_displ, age), 
           width = 0.3)


# Solutions
# Solutions for refugees | 1990-2021
sol_ref <- unhcrdatapackage::solutions |> 
  filter(Year >= 1990 & Year <= 2021) |> 
  mutate(sol_ref = rowSums(across(RST:RET), na.rm = TRUE)) |> 
  group_by(Year) |> 
  summarise(sol_ref = sum(sol_ref, na.rm = TRUE)) |> 
  pivot_longer(cols = c(sol_ref), names_to = "pop_type", values_to = "total") 

# New refugee | 1990-2021
# URL of excel file
flow_url <- "https://unhcr-web.github.io/refugee-statistics/0002-Explainers/Data/UNHCR_Flow_Data.xlsx"
# Temp file creation and download with curl as readxl can't read online excel file
tf = tempfile(fileext = ".xlsx")
curl::curl_download(flow_url, tf)

# Load and arrange data
new_ref <- readxl::read_excel(tf, sheet = "DATA") |> 
  filter(Year >= 1990 & Year <= 2021,
         PT == "REF") |> 
  group_by(Year, PT) |> 
  summarise(total = sum(Count, na.rm = TRUE)) |> 
  arrange(Year) |> 
  mutate(pop_type = if_else(PT == "REF", "new_ref","")) |> 
  select(!PT)

# Solution for idps | 2009-2021
sol_idp <- unhcrdatapackage::solutions |> 
  filter(Year >= 2009 & Year <= 2021) |> 
  group_by(Year) |> 
  summarise(sol_idp = sum(RDP, na.rm = TRUE)) |> 
  pivot_longer(cols = c(sol_idp), names_to = "pop_type", values_to = "total") 

# New idps IDMC | 2009-2021
# Link to hDX csv
idmc_hdx <- read_csv("https://data.humdata.org/dataset/459fc96c-f196-44c1-a0a5-1b5a7b3592dd/resource/0fb4e415-abdb-481a-a3c6-8821e79919be/download/displacement_data.csv")

new_idp <- idmc_hdx |> 
  filter(ISO3 != "#country+code",
         Year >= 2009 & Year <= 2021) |> 
  group_by(Year) |> 
  summarise(new_idp = sum(as.integer(`Conflict Internal Displacements`), na.rm = TRUE)) |> 
  pivot_longer(cols = c(new_idp), names_to = "pop_type", values_to = "total") 

# Bind all data together
sol_vs_new <- rbind(sol_ref, new_ref, sol_idp, new_idp)

# Create wide version for area between lines
sol_vs_new_wide <- sol_vs_new |> 
  pivot_wider(names_from = pop_type, values_from = total)

# DF for labeling lines directly
sol_vs_new_label <- sol_vs_new |> 
  filter(Year == 2021) |> 
  mutate(label = case_when(
    pop_type == "sol_ref" ~ "Refugee<br>solutions",
    pop_type == "new_ref" ~ "New<br>recognitions",
    pop_type == "sol_idp" ~ "IDP returns",
    pop_type == "new_idp" ~ "New internal<br>displacements",
    TRUE ~ pop_type
  ))

ggplot() +
  geom_line(data = sol_vs_new, aes(x = Year, y = total, color = pop_type, group = pop_type)) +
  geom_braid(data = sol_vs_new_wide, aes(x = Year, ymin = new_ref, ymax = sol_ref, fill = new_ref < sol_ref), alpha = .3) +
  geom_braid(data = sol_vs_new_wide, aes(x = Year, ymin = new_idp, ymax = sol_idp, fill = new_idp < sol_idp), alpha = .3) +
  geom_richtext(data = sol_vs_new_label, aes(x = Year, y = total, color = pop_type, label = label),
                size = 8 / .pt, nudge_x = 1, ) +
  scale_x_discrete(breaks = scales::pretty_breaks(n = 10)) +
  scale_y_continuous(labels = scales::label_number(scale_cut = cut_short_scale()),
                     breaks = scales::pretty_breaks(n = 7),
                     limits = c(0, NA),
                     expand = expansion(c(0, 0.1))) +
  scale_color_unhcr_d(nmax = 4, order = c(2, 4, 4, 2)) +
  scale_fill_unhcr_d(nmax = 4, order = c(2,4))+
  labs(title = "Forced displacement outpaces the available solutions during the last decade",
       caption = "Source: UNHCR Global Trends 2021\n© UNHCR, The UN Refugee Agency") +
  coord_cartesian(clip = "off") +
  theme_unhcr(grid = "Y",
              axis_title = FALSE,
              legend = FALSE) +
  theme(plot.margin = margin(r = 50))
