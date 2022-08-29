# load library
library(colorspace)
library(unikn)

blue_main <- "#0072BC"
darkblue_main <- "#18375F"
green_main <- "#00B398"
red_main <- "#EF4A60"
yellow_main <- "#FAEB00"


# colorspace approach 30%
blue_pal_30 <- c(colorspace::darken(blue_main, 0.3),
              blue_main,
              colorspace::lighten(blue_main, 0.3),
              colorspace::lighten(blue_main, 0.6),
              colorspace::lighten(blue_main, 0.9))

darkblue_pal_30 <- c(
                  darkblue_main, 
                  colorspace::lighten(darkblue_main, 0.3),
                  colorspace::lighten(darkblue_main, 0.6),
                  colorspace::lighten(darkblue_main, 0.9),
                  colorspace::lighten(darkblue_main, 0.95))

green_pal_30 <- c(colorspace::darken(green_main, 0.3),
               green_main,
               colorspace::lighten(green_main, 0.3),
               colorspace::lighten(green_main, 0.6),
               colorspace::lighten(green_main, 0.9))

red_pal_30 <- c(colorspace::darken(red_main, 0.3),
             red_main,
             colorspace::lighten(red_main, 0.3),
             colorspace::lighten(red_main, 0.6),
             colorspace::lighten(red_main, 0.9))

yellow_pal_30 <- c(
                colorspace::darken(yellow_main, 0.6),
                colorspace::darken(yellow_main, 0.3),
                yellow_main,
                colorspace::lighten(yellow_main, 0.3),
                colorspace::lighten(yellow_main, 0.6))

unikn::seecol(list(blue_pal_30, darkblue_pal_30, green_pal_30, red_pal_30, yellow_pal_30),
              title = "30% on both side. Blue, red and green start in 2nd position, \ndarblue first (last one 95%) and yellow on the 3rd position")

# colorspace approach 25%
blue_pal_25 <- c(colorspace::darken(blue_main, 0.25),
                 blue_main,
                 colorspace::lighten(blue_main, 0.25),
                 colorspace::lighten(blue_main, 0.5),
                 colorspace::lighten(blue_main, 0.75),
                 colorspace::lighten(blue_main, 0.85))

darkblue_pal_25 <- c(
  darkblue_main, 
  colorspace::lighten(darkblue_main, 0.25),
  colorspace::lighten(darkblue_main, 0.5),
  colorspace::lighten(darkblue_main, 0.75),
  colorspace::lighten(darkblue_main, 0.9))

green_pal_25 <- c(colorspace::darken(green_main, 0.25),
                  green_main,
                  colorspace::lighten(green_main, 0.25),
                  colorspace::lighten(green_main, 0.5),
                  colorspace::lighten(green_main, 0.75),
                  colorspace::lighten(green_main, 0.85))

red_pal_25 <- c(colorspace::darken(red_main, 0.25),
                red_main,
                colorspace::lighten(red_main, 0.25),
                colorspace::lighten(red_main, 0.5),
                colorspace::lighten(red_main, 0.75),
                colorspace::lighten(red_main, 0.85))

yellow_pal_25 <- c(
  colorspace::darken(yellow_main, 0.5),
  colorspace::darken(yellow_main, 0.25),
  yellow_main,
  colorspace::lighten(yellow_main, 0.25),
  colorspace::lighten(yellow_main, 0.5),
  colorspace::lighten(yellow_main, 0.75))

unikn::seecol(list(blue_pal_25, darkblue_pal_25, green_pal_25, red_pal_25, yellow_pal_25),
              title = "25% on both side. Blue, red and green start in 2nd position (last one 85%), \ndarblue first and yellow on the 3rd position")

# colorspace approach 20%
blue_pal_20 <- c(colorspace::darken(blue_main, 0.20),
                 blue_main,
                 colorspace::lighten(blue_main, 0.20),
                 colorspace::lighten(blue_main, 0.4),
                 colorspace::lighten(blue_main, 0.6),
                 colorspace::lighten(blue_main, 0.8))

darkblue_pal_20 <- c(
  darkblue_main, 
  colorspace::lighten(darkblue_main, 0.20),
  colorspace::lighten(darkblue_main, 0.4),
  colorspace::lighten(darkblue_main, 0.6),
  colorspace::lighten(darkblue_main, 0.8),
  colorspace::lighten(darkblue_main, 0.9))

green_pal_20 <- c(colorspace::darken(green_main, 0.20),
                  green_main,
                  colorspace::lighten(green_main, 0.20),
                  colorspace::lighten(green_main, 0.4),
                  colorspace::lighten(green_main, 0.6),
                  colorspace::lighten(green_main, 0.8))

red_pal_20 <- c(colorspace::darken(red_main, 0.20),
                red_main,
                colorspace::lighten(red_main, 0.20),
                colorspace::lighten(red_main, 0.4),
                colorspace::lighten(red_main, 0.6),
                colorspace::lighten(red_main, 0.8))

yellow_pal_20 <- c(
  colorspace::darken(yellow_main, 0.4),
  colorspace::darken(yellow_main, 0.20),
  yellow_main,
  colorspace::lighten(yellow_main, 0.20),
  colorspace::lighten(yellow_main, 0.4),
  colorspace::lighten(yellow_main, 0.6))

unikn::seecol(list(blue_pal_20, darkblue_pal_20, green_pal_20, red_pal_20, yellow_pal_20),
              title = "20% on both side. Blue, red and green start in 2nd position, \ndarkblue first (last one 90%) and yellow on the 3rd position")
