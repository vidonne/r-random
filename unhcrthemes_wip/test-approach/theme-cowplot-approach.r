library(ggplot2)

# sample data for plot ----
points <- 
  data.frame(
    x = rep(1:10,3), 
    y = rep(1:10,3), 
    z = sort(rep(letters[1:2], 15)),
    w = rep(letters[3:4], 15)
  )

theme_unhcr_wip <- function(font_size = 12, font_family = "Lato", legend_title = FALSE) {
  
  rel_large <- 12/9
  rel_small <- 8/9
  rel_tiny <- 7/9
  line_size <- .5
  
  # work off of theme_grey just in case some new theme element comes along
  ggplot2::theme_grey(base_size = font_size, base_family = font_family) %+replace%
    ggplot2::theme(
      line              = ggplot2::element_line(color = "black", size = line_size, linetype = 1, lineend = "butt"),
      rect              = ggplot2::element_rect(fill = NA, color = NA, size = line_size, linetype = 1),
      text              = ggplot2::element_text(family = font_family, face = "plain", color = "#1A1A1A",
                                       size = font_size, hjust = 0.5, vjust = 0.5, angle = 0, lineheight = .9,
                                       margin = margin(), debug = FALSE),
      
      # axis.line         = element_line(color = "black", size = line_size, lineend = "square"),
      # axis.line.x       = NULL,
      # axis.line.y       = NULL,
      # axis.text         = element_text(color = "black", size = small_size),
      # axis.text.x       = element_text(margin = margin(t = small_size / 4), vjust = 1),
      # axis.text.x.top   = element_text(margin = margin(b = small_size / 4), vjust = 0),
      # axis.text.y       = element_text(margin = margin(r = small_size / 4), hjust = 1),
      # axis.text.y.right = element_text(margin = margin(l = small_size / 4), hjust = 0),
      # axis.ticks        = element_line(color = "black", size = line_size),
      # axis.ticks.length = unit(half_line / 2, "pt"),
      # axis.title.x      = element_text(
      #   margin = margin(t = half_line / 2),
      #   vjust = 1
      # ),
      # axis.title.x.top  = element_text(
      #   margin = margin(b = half_line / 2),
      #   vjust = 0
      # ),
      # axis.title.y      = element_text(
      #   angle = 90,
      #   margin = margin(r = half_line / 2),
      #   vjust = 1
      # ),
      # axis.title.y.right = element_text(
      #   angle = -90,
      #   margin = margin(l = half_line / 2),
      #   vjust = 0
      # ),
      # 
      # 
      legend.background = element_blank(),
      legend.spacing    = unit(font_size * 0.5, "pt"),
      legend.spacing.x  = NULL,
      legend.spacing.y  = NULL,
      legend.margin     = margin(0, 0, 0, 0),
      legend.key        = element_blank(),
      legend.key.size   = unit(1.1 * font_size, "pt"),
      legend.key.height = NULL,
      legend.key.width  = NULL,
      legend.text       = element_text(size = rel(rel_small)),
      legend.text.align = NULL,
      legend.title      = element_blank(),
      legend.title.align = NULL,
      legend.position   = "top",
      legend.direction  = NULL,
      legend.justification = c("right", "center"),
      legend.box        = NULL,
      legend.box.margin =  margin(0, 0, 0, 0),
      legend.box.background = element_blank(),
      legend.box.spacing = unit(font_size, "pt"),
      # 
      # panel.background  = element_blank(),
      # panel.border      = element_blank(),
      # panel.grid        = element_blank(),
      # panel.grid.major  = NULL,
      # panel.grid.minor  = NULL,
      # panel.grid.major.x = NULL,
      # panel.grid.major.y = NULL,
      # panel.grid.minor.x = NULL,
      # panel.grid.minor.y = NULL,
      # panel.spacing     = unit(half_line, "pt"),
      # panel.spacing.x   = NULL,
      # panel.spacing.y   = NULL,
      # panel.ontop       = FALSE,
      # 
      # strip.background  = element_rect(fill = "grey80"),
      # strip.text        = element_text(
      #   size = rel(rel_small),
      #   margin = margin(half_line / 2, half_line / 2,
      #                   half_line / 2, half_line / 2)
      # ),
      # strip.text.x      = NULL,
      # strip.text.y      = element_text(angle = -90),
      # strip.placement   = "inside",
      # strip.placement.x =  NULL,
      # strip.placement.y =  NULL,
      # strip.switch.pad.grid = unit(half_line / 2, "pt"),
      # strip.switch.pad.wrap = unit(half_line / 2, "pt"),
      # 
      plot.background   = element_blank(),
      plot.title        = element_text(
        face = "bold",
        size = rel(rel_large),
        hjust = 0, vjust = 1,
        color = "black",
        margin = margin(t = font_size, b = font_size * 1/3)
      ),
      plot.title.position = "plot",
      plot.subtitle     = element_text(
        size = rel(rel_small),
        hjust = 0, vjust = 1,
        margin = margin(b = font_size * 2/3)
      ),
      plot.caption      = element_text(
        size = rel(rel_tiny),
        hjust = 0, vjust = 1,
        color = "grey40",
        margin = margin(t = font_size * 0.5)
      ),
      plot.caption.position = "plot",
      plot.tag           = element_text(
        face = "plain",
        color = "#0072bc",
        hjust = 0, vjust = 0.7
      ),
      plot.tag.position = c(0, 1),
      plot.margin       = margin(font_size, font_size, font_size, font_size),

      complete = TRUE
    )
}
  
ggplot(data = points, 
       mapping = aes(x = x, y = y, col = z)) + 
  geom_point() +
  labs(x="Petal length", y="Petal width",
       title = "Iris data ggplot2 scatterplot example",
       subtitle= "Just a simple plot to show the basic style of theme_unhcr",
       caption = "Data from datasets::iris",
       tag = "Figure 1") +
  theme_unhcr_wip()


# ggplot using many theme options ----
ggplot(data = points, 
       mapping = aes(x = x, y = y, col = w)) + 
  geom_point(size = 5) + 
  facet_grid(w ~ z, switch = "y") +
  theme_unhcr_wip() +
  labs(title = "test title",
       subtitle = "test subtitle",
       x = "my x axis",
       y = "my y axis",
       caption = "this is a caption",
       col = "Renamed Legend") 
