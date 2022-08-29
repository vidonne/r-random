# load library
library(colorspace)
library(chroma)
library(tidyverse)

blue_main <- "#0072BC"
darkblue_main <- "#18375F"
green_main <- "#00B398"
red_main <- "#EF4A60"
yellow_main <- "#FAEB00"
yellow_alt <- "#F5C205"
dark <- colorspace::lighten("#000000", 0.1)
light <- colorspace::lighten("#000000", 0.95)

# chroma approach
no_color <- 11

blue_chroma <- chroma::interp_colors(no_color, c(dark, blue_main, light), correct.lightness = TRUE)
darkblue_chroma <- chroma::interp_colors(no_color, c(dark, darkblue_main, light), correct.lightness = TRUE)
green_chroma <- chroma::interp_colors(no_color, c(dark, green_main, light), correct.lightness = TRUE)
red_chroma <- chroma::interp_colors(no_color, c(dark, red_main, light), correct.lightness = TRUE)
yellow_chroma <- chroma::interp_colors(no_color, c(dark, yellow_main, light), correct.lightness = TRUE)
yellow_alt_chroma <- chroma::interp_colors(no_color, c(dark, yellow_alt, light), correct.lightness = TRUE)

show_col(blue_chroma, darkblue_chroma, green_chroma, red_chroma, yellow_chroma, yellow_alt_chroma)


darkblue_chroma <- chroma::interp_colors(8, c(darkblue_main, light))
darkblue_chroma_pal <- darkblue_chroma[1:7]
show_col(blue_chroma_pal, darkblue_chroma_pal)


#from web
blue_web <- c('#213f61', '#10598f', blue_main, '#458fc9', '#81a8d5', '#afc2e0', '#d6deec')
red_web <- c('#9f3a44', '#c64252', red_main, '#f5747e', '#f7999f', '#f9bbbd', '#fadbda')
green_web <- c('#217867', '#148e7a', green_main, '#23bba2', '#70ccb9', '#aadbce', '#d7ebe5')
darkblue_web <- c(darkblue_main, '#364f72', '#546786', '#73809a', '#929baf', '#b0b6c5', '#cfd2db')
yellow_web <- c('#ae8a1b', '#c29a15', '#d6a90f', '#eab908', yellow_main, '#f9e401', '#faf3da')



show_col(blue_web, red_web, green_web, darkblue_web, yellow_web)
