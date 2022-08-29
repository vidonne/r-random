library(ggplot2)
library(plotly)
library(gapminder)
library(htmlwidgets)

p <- gapminder %>%
  filter(year==1977) %>%
  ggplot( aes(gdpPercap, lifeExp, size = pop, color=continent)) +
  geom_point() +
  theme_bw()

dynamic_p <- ggplotly(p)

htmlwidgets::saveWidget(dynamic_p, file = "test_plotly.html", background = "transparent")
