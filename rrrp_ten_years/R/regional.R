# Packages ----------------------------------------------------------------

# Load packages
library(here)
library(tidyverse)
library(unhcrthemes)
library(gt)
library(gtExtras)
library(patchwork)
library(readxl)
library(scales)
library(lubridate)


# Data --------------------------------------------------------------------

# Load data
# Excel path
reg_xls <- here::here("data", "regional.xlsx")

# Regional table
reg_tbl <- read_xlsx(reg_xls, sheet = "table")

# Regional funding
reg_fund <- read_xlsx(reg_xls, sheet = "fund")

# Regional pop
reg_pop <- read_xlsx(reg_xls, sheet = "pop")

# Regional partners
reg_partner <- read_xlsx(reg_xls, sheet = "partner")


# Funding plot ------------------------------------------------------------

# Format data
reg_fund_long <- reg_fund |> 
  pivot_longer(cols = c(funding_requested, funding_received),
               names_to = "funding_type",
               values_to = "usd_billion") |> 
  mutate(year_label = case_when(
    year == 2012 ~ "2012",
    year == 2021 ~ "2021",
    TRUE ~ stringr::str_sub(year, start = 3)))

# Plot
fund_plot <- ggplot(data = reg_fund_long,
       aes(x = year,
           y = usd_billion,
           color = funding_type)) +
  geom_line() +
  labs(title = "Inter-Agency funding requested and\nreceived across all plans | 2012-2021") +
  scale_y_continuous(limits = c(0, 12),
                     expand = expansion(0),
                     breaks = seq(0, 12, 2),
                     name = "USD Billion") +
  scale_x_continuous(breaks = seq(2012, 2021, 1),
                     labels = unique(reg_fund_long$year_label)) +
  scale_color_unhcr_d(direction = -1) +
  theme_unhcr(axis = "X", grid = "Y", legend = FALSE)


# Population plot ---------------------------------------------------------

reg_pop_long <- reg_pop |> 
  pivot_longer(cols = c(ref, host),
               names_to = "pop_type",
               values_to = "people_million")|> 
  mutate(year_label = case_when(
    year == 2012 ~ "2012",
    year == 2021 ~ "2021",
    TRUE ~ stringr::str_sub(year, start = 3)))

# Plot
pop_plot <- ggplot(data = reg_pop_long,
       aes(x = year,
           y = people_million,
           color = pop_type)) +
  geom_line() +
  labs(title = "Refugees and host communities\ntargeted across all plans | 2012-2021") +
  scale_y_continuous(limits = c(0, 25),
                     expand = expansion(0),
                     breaks = seq(0, 25, 5),
                     name = "Number of people (million)") +
  scale_x_continuous(breaks = seq(2012, 2021, 1),
                     labels = unique(reg_pop_long$year_label)) +
  scale_color_unhcr_d(direction = -1) +
  theme_unhcr(axis = "X", grid = "Y", legend = FALSE)


# Partner plot ------------------------------------------------------------

reg_partner_lab <- reg_partner |> 
  mutate(year_label = case_when(
    year == 2012 ~ "2012",
    year == 2021 ~ "2021",
    TRUE ~ stringr::str_sub(year, start = 3)))

# Plot
partner_plot <- ggplot(data = reg_partner_lab,
       aes(x = year,
           y = partner)) +
  geom_col(fill = unhcr_pal(n = 1, "pal_unhcr")) +
  labs(title = "Total number of partners across all plans\n| 2012-2021") +
  scale_y_continuous(limits = c(0, 600),
                     expand = expansion(0),
                     breaks = seq(0, 600, 100),
                     name = "Number of partners") +
  scale_x_continuous(breaks = seq(2012, 2021, 1),
                     labels = unique(reg_pop_long$year_label)) +
  theme_unhcr(axis = "X", grid = "Y", legend = FALSE)


# Table -------------------------------------------------------------------

reg_tbl |>
  select(-Index) |>
  mutate(avg_funded = avg_funded*100) |> 
  gt() |> 
  cols_label(
    Name = md("**PLAN NAME**<br>Type"),
    total_requested = "Requested"
  ) |> 
  fmt_currency(columns = total_requested,
               suffixing = TRUE,
               decimals = 1) |> 
  gt_plt_bar(column = avg_requested,
             width = 75,
             color = unhcr_pal(n = 1, "pal_unhcr"),
             keep_column = TRUE) |> 
  gt_plt_bar_pct(column = avg_funded,
                 scaled = TRUE) |> 
  fmt_markdown(columns = Name)


# Patchwork all -----------------------------------------------------------


(fund_plot | pop_plot | partner_plot)/tbl


