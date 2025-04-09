map_object <- function(geodata, layername = "Áreas do KML", alpha = .6) {
  # stopifnot(
  #   "Geometria não é válida." = sf::st_is_valid(geodata))

  tm_shape(
    geodata,
    name = layername,
    crs = "auto") +
    tm_polygons(
      "Name",
      fill_alpha = alpha)
}
