theme_unhcr_hrbt <- function(base_family = "Lato", base_size = 14) {

  black <- "#000000"
  dark <- "#1A1A1A"
  medium <- "#666666"
  blue <- "#0072BC"


  rel_large <- 12 / 9
  rel_small <- 8 / 9
  rel_tiny <- 7 / 9
  line_size <- .5

  # work off of theme_minimal
  ret <- ggplot2::theme_minimal(base_family = base_family, base_size = base_size)
  ret <- ret + ggplot2::theme(line = ggplot2::element_line(
    color = black, size = line_size, linetype = 1, lineend = "butt"
  ))
  ret <- ret + ggplot2::theme(rect = ggplot2::element_rect(
    fill = NA, color = NA, size = line_size, linetype = 1
  ))
  ret <- ret + ggplot2::theme(text = ggplot2::element_text(
    family = base_family, face = "plain", color = dark,
    size = base_size, hjust = 0.5, vjust = 0.5, angle = 0, lineheight = .9,
    margin = margin(), debug = FALSE))

  ret <- ret + ggplot2::theme(plot.title = ggplot2::element_text(
    size = rel(rel_large), color = black, face = "bold",
    hjust = 0, vjust = 1,
    margin = ggplot2::margin(b = base_size * 1/3),
  ))
  ret <- ret + ggplot2::theme(plot.subtitle = ggplot2::element_text(
    size = base_size, color = dark, face = "plain",
    hjust = 0, vjust = 1,
    margin = ggplot2::margin(b = base_size)
  ))
  ret <- ret + ggplot2::theme(plot.title.position = "plot")

  ret <- ret + ggplot2::theme(plot.caption = ggplot2::element_text(
    size = rel(rel_tiny), color = medium,
    hjust = 0, vjust = 1,
    margin = ggplot2::margin(t = base_size * 2 / 3)
  ))
  ret <- ret + ggplot2::theme(plot.caption.position = "plot")

  ret <- ret + ggplot2::theme(plot.tag = ggplot2::element_text(
    size = base_size, color = blue,
    hjust = 0, vjust = 1
  ))
  ret <- ret + ggplot2::theme(plot.tag.position = c(0, 1))

  ret <- ret + ggplot2::theme(plot.margin = ggplot2::margin(base_size, base_size, base_size, base_size))

  ret
}
