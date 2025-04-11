map_object <- function(geodata, layername = "Áreas do KML", alpha = .6) {
  require(leaflet)

  is_compatible_geom <- function(geom, compatible_types = c("MULTIPOLYGON", "POLYGON")) {
    geom_type <- sf::st_geometry_type(geom)
    compat_geom_types <- c("MULTIPOLYGON", "POLYGON")

    stopifnot(
      "Geometria não é compatível com polígonos." = geom_type %in% compat_geom_types)
  }

  is_compatible_geom(geodata)


  pal <- colorFactor("RdYlBu", geodata$Name)
  labels <- sprintf(
    "<b>Nome:</b> %s<br/><b>Descrição:</b> %s",
    geodata$Name, geodata$Description) |>
    lapply(htmltools::HTML)

  leaflet(geodata) |>
    addProviderTiles(providers$CartoDB.Positron, group = "CartoDB") |>
    addProviderTiles(providers$OpenStreetMap, group = "OpenStreetMap") |>
    addProviderTiles(providers$Esri.WorldImagery, group = "Satélite") |>
    addProviderTiles(providers$Esri.WorldTopoMap, group = "Topográfico") |>
    addPolygons(
      group = layername,
      stroke = TRUE,
      weight = 2,
      opacity = alpha,
      color = "white",
      fill = TRUE,
      fillOpacity = alpha,
      fillColor = ~pal(Name),
      highlightOptions = highlightOptions(
        weight = 5,
        color = "#666",
        fillOpacity = alpha + .2,
        bringToFront = TRUE),
      label = labels,
      labelOptions = labelOptions(
        textsize = "12px")
    ) |>
    addLegend(
      position = "bottomright",
      pal = pal,
      values = ~Name,
      opacity = alpha + .1,
      title = layername) |>
    addLayersControl(
      baseGroups = c("CartoDB", "OpenStreetMap", "Topográfico", "Satélite"),
      overlayGroups = layername,
      position = "topleft")
}

sizes_table <- function(geodata) {
  require(dplyr)

  geodata |>
    dplyr::rename(
      Nome = Name,
      Descrição = Description) |>
    dplyr::mutate(
      geometry = sf::st_make_valid(geometry),
      "Vértices" = sapply(geometry, \(x) {
        sf::st_coordinates(x) |>
          nrow()
      }),
      "Área (m²)" = sf::st_area(geometry),
      "Área (ha)" = units::set_units(`Área (m²)`, "ha"),
      "Perímetro (m)" = sf::st_perimeter(geometry),
      "Perímetro (km)" = units::set_units(`Perímetro (m)`, "km")
    ) |>
    sf::st_drop_geometry()
}
