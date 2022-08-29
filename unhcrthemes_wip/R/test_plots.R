library(ggplot2)

mpg |> ggplot(aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  labs(
    x = "Petal length", y = "Petal width",
    title = "Iris data ggplot2 scatterplot example",
    subtitle = "Just a simple plot to show the basic style of theme_unhcr",
    caption = "Data from datasets::iris",
    tag = "Figure 1"
  ) +
  theme_unhcr_wip(ticks = "X", grid = FALSE, axis = FALSE)

mpg |> ggplot(aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  labs(
    x = "Petal length", y = "Petal width",
    title = "Iris data ggplot2 scatterplot example",
    subtitle = "Just a simple plot to show the basic style of theme_unhcr",
    caption = "Data from datasets::iris\n© UNHCR"
  ) +
  theme_unhcr_wip()


mpg |> ggplot(aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  facet_grid(fl ~ drv, switch = "y") +
  labs(
    x = "Petal length", y = "Petal width",
    title = "Iris data ggplot2 scatterplot example",
    subtitle = "Just a simple plot to show the basic style of theme_unhcr",
    caption = "Data from datasets::iris"
  ) +
  theme_unhcr_wip()

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  theme_unhcr_wip()

p$theme$plot.margin

p$theme$text$size
