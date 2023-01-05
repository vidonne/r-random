library(edgebundle)
library(igraph)
library(ggplot2)
library(ggraph)

g <- graph_from_edgelist(
  matrix(c(1, 2, 1, 6, 1, 4, 2, 3, 3, 4, 4, 5, 5, 6), ncol = 2, byrow = TRUE),
  FALSE
)
xy <- cbind(c(0, 10, 25, 40, 50, 50), c(0, 15, 25, 15, 0, -10))

# non-bundled drawing
ggraph(g, "manual", x = xy[, 1], y = xy[, 2]) +
  geom_edge_link0(edge_colour = "grey66", edge_width = 2) +
  geom_node_point(size = 5) +
  theme_graph()

# bundled drawing
res <- edge_bundle_path(g, xy, max_distortion = 2, weight_fac = 2, segments = 50)
ggplot() +
  geom_path(
    data = res, aes(x, y, group = group, col = as.factor(group)),
    size = 2, show.legend = FALSE
  ) +
  geom_point(data = as.data.frame(xy), aes(V1, V2), size = 5) +
  scale_color_manual(values = c("grey66", "firebrick3", "firebrick3", rep("grey66", 4))) +
  theme_void()

g <- us_flights
xy <- cbind(V(g)$longitude, V(g)$latitude)
verts <- data.frame(x = V(g)$longitude, y = V(g)$latitude)

pbundle <- edge_bundle_path(g, xy, max_distortion = 12, weight_fac = 2, segments = 50)
View(pbundle)

states <- map_data("state")

ggplot() +
  geom_polygon(
    data = states, aes(long, lat, group = group),
    col = "white", size = 0.1, fill = NA
  ) +
  geom_path(
    data = pbundle, aes(x, y, group = group),
    col = "#9d0191", size = 0.05
  ) +
  geom_path(
    data = pbundle, aes(x, y, group = group),
    col = "white", size = 0.005
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "#9d0191", size = 0.25
  ) +
  geom_point(
    data = verts, aes(x, y),
    col = "white", size = 2, alpha = 0.5
  ) +
  geom_point(
    data = verts[verts$name != "", ], aes(x, y),
    col = "white", size = 3, alpha = 1
  ) +
  labs(title = "Edge-Path Bundling") +
  ggraph::theme_graph(background = "black") +
  theme(plot.title = element_text(color = "white"))

library(sf)
library(dplyr)
pbundle_sf <- pbundle %>%
  st_as_sf(coords = c("x", "y"), agr = "constant") %>%
  group_by(group) %>%
  summarise(do_union = FALSE) %>%
  st_cast("LINESTRING")

st_crs(pbundle_sf) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

pbundle_sf

ggplot() +
  geom_sf(data = pbundle_sf)


## A simple example with a couple of actors
## The typical case is that these tables are read in from files....
actors <- data.frame(
  name = c(
    "Alice", "Bob", "Cecil", "David",
    "Esmeralda"
  ),
  age = c(48, 33, 45, 34, 21),
  gender = c("F", "M", "F", "M", "F")
)
relations <- data.frame(
  from = c(
    "Bob", "Cecil", "Cecil", "David",
    "David", "Esmeralda"
  ),
  to = c("Alice", "Bob", "Alice", "Alice", "Bob", "Alice"),
  same.dept = c(FALSE, FALSE, TRUE, FALSE, FALSE, TRUE),
  friendship = c(4, 5, 5, 2, 1, 1), advice = c(4, 5, 5, 4, 2, 3)
)
g_simple <- graph_from_data_frame(relations, directed = TRUE, vertices = actors)
print(g_simple, e = TRUE, v = TRUE)


library(nycflights13)

## Lines from points
# Filter out the flights from JFK from the flight data of the nycflights13 package
flights.jfk <- filter(flights, origin == "JFK")

# Count the number of flights on each origin-destination route, and give each route an id
flights.jfk.counted <- group_by(flights.jfk, origin, dest) %>%
  summarise(total = n()) %>%
  mutate(id = paste(origin, "-", dest, sep = ""))
head(flights.jfk.counted)
