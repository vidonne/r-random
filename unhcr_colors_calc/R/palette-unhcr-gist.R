# load library
library(colorspace)

# Main UNHCR data visualization colors
main_blue <- "#0072BC"
main_darkblue <- "#18375F"
main_green <- "#00B398"
main_red <- "#EF4A60"
main_greygrey <- colorspace::lighten("black", 0.4)
main_yellow <- "#FAEB00"
alt_yellow <- "#BB9D21" # Altenative yellow needed to create darker shades of the pal_yellow_unhcr

# Color palette definition, all based on the main colors defined above
# Main color is usually the second darkest color except if specified otherwise

# Blue, green and red 30% color spacing - Exceptions: blue1 and red1 85% (instead of 90%)
# Darkblue 25% color spacing - Exceptions: darkblue1 90% and main_darkblue is the darkest shade
# Grey 20% color spacing - Exceptions: grey1 90%
# Yellow more manual. yellow5 = alt_yellow, yellow4 = mixcolor(alt_yellow, main_yellow),
# yellow3 = main_yellow, yellow2 = 40% color spacing, yellow1 = 70%

pal_blue_unhcr <- c(
  "blue5" = colorspace::darken(main_blue, 0.3),
  "blue4" = main_blue,
  "blue3" = colorspace::lighten(main_blue, 0.3),
  "blue2" = colorspace::lighten(main_blue, 0.6),
  "blue1" = colorspace::lighten(main_blue, 0.85)
)

pal_darkblue_unhcr <- c(
  "darkblue5" = main_darkblue,
  "darkblue4" = colorspace::lighten(main_darkblue, 0.25), #was 22.5% should we move back?
  "darkblue3" = colorspace::lighten(main_darkblue, 0.5),
  "darkblue2" = colorspace::lighten(main_darkblue, 0.75),
  "darkblue1" = colorspace::lighten(main_darkblue, 0.9)
)

pal_green_unhcr <- c(
  "green5" = colorspace::darken(main_green, 0.3),
  "green4" = main_green,
  "green3" = colorspace::lighten(main_green, 0.3),
  "green2" = colorspace::lighten(main_green, 0.6),
  "green1" = colorspace::lighten(main_green, 0.9)
)

pal_red_unhcr <- c(
  "red5" = colorspace::darken(main_red, 0.3),
  "red4" = main_red,
  "red3" = colorspace::lighten(main_red, 0.3),
  "red2" = colorspace::lighten(main_red, 0.6),
  "red1" = colorspace::lighten(main_red, 0.85)
)

pal_grey_unhcr <- c(
  "grey5" <- colorspace::lighten("black", 0.2),
  "grey4" <- colorspace::lighten("black", 0.4),
  "grey3" <- colorspace::lighten("black", 0.6),
  "grey2" <- colorspace::lighten("black", 0.8),
  "grey1" <- colorspace::lighten("black", 0.9)
)

pal_yellow_unhcr <- c(
  "yellow5" <- alt_yellow,
  "yellow4" <- hex(colorspace::mixcolor(0.4, hex2RGB(main_yellow), hex2RGB(alt_yellow))),
  "yellow3" <- main_yellow,
  "yellow2" <- colorspace::lighten(main_yellow, 0.4),
  "yellow1" <- colorspace::lighten(main_yellow, 0.7)
)

colorspace::swatchplot("pal_blue_s" = pal_blue_unhcr,
                       "pal_darkblue_s" = pal_darkblue_unhcr,
                       "pal_green_s" = pal_green_unhcr, 
                       "pal_red_s" = pal_red_unhcr,
                       "pal_grey_s" = pal_grey_unhcr,
                       "pal_yellow_s" = pal_yellow_unhcr,
                       "pal_main_c" = c(pal_blue_unhcr[2], pal_darkblue_unhcr[1], pal_green_unhcr[2],
                                        pal_grey_unhcr[2], pal_red_unhcr[2]),
                       "pal_shade_c" = c(pal_blue_unhcr[2], pal_blue_unhcr[4],
                                         pal_darkblue_unhcr[1], pal_darkblue_unhcr[3],
                                         pal_green_unhcr[2], pal_green_unhcr[4],
                                         pal_grey_unhcr[2], pal_grey_unhcr[4],
                                         pal_red_unhcr[2], pal_red_unhcr[4]),
                       "pal_blue_red_d" = c(pal_blue_unhcr[2], pal_blue_unhcr[3], pal_blue_unhcr[4], pal_grey_unhcr[5],
                                            pal_red_unhcr[4], pal_red_unhcr[3], pal_red_unhcr[2]),
                       "pal_darkblue_red_d" = c(pal_darkblue_unhcr[1], pal_darkblue_unhcr[2], pal_darkblue_unhcr[3],
                                                  pal_grey_unhcr[5], pal_red_unhcr[4],
                                                  pal_red_unhcr[3], pal_red_unhcr[2]),
                       "pal_darkblue_yellow_d" = c(pal_darkblue_unhcr[1], pal_darkblue_unhcr[2],
                                                   pal_darkblue_unhcr[3],pal_grey_unhcr[5],
                                                   pal_yellow_unhcr[4],pal_yellow_unhcr[3], pal_yellow_unhcr[2]),
                       border = "transparent", sborder = "transparent", off = 0)

colorspace::swatchplot("pal_blue_s" = pal_blue_unhcr,
                       "pal_darkblue_s" = pal_darkblue_unhcr,
                       "pal_green_s" = pal_green_unhcr, 
                       "pal_red_s" = pal_red_unhcr,
                       "pal_grey_s" = pal_grey_unhcr,
                       "pal_yellow_s" = pal_yellow_unhcr,
                       border = "transparent", sborder = "transparent", off = 0)

