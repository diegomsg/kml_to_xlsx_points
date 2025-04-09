read_kml_file <- function(input_file) {
  stopifnot(
    "Entrada precisa ser um arquivo KML." = all(
       fs::as_fs_path(input_file$datapath) |>
        fs::path_ext() == "kml"
      )
  )

  tibble::tibble(
    arquivo = input_file$name,
    sf_content = purrr::map_df(input_file$datapath, ~ sf::read_sf(
      .x,
      quiet = TRUE))
  )
}

expand_kml_features <- function(tbl) {
  tidyr::unnest_wider(tbl, sf_content)
}

add_indice <- function(tbl, name_repair = "minimal") {
  if(!tibble::is_tibble(tbl)) {
    tbl <- tibble::as_tibble(tbl, .name_repair = name_repair)
  }

  tbl$ponto <- seq(nrow(tbl))
  dplyr::relocate(tbl, ponto, .before = 1)
}

expand_points <- function(tbl) {
  tbl |>
    dplyr::mutate(
      geometry = purrr::map(geometry, \(geom) {
          sf::st_cast(geom, "MULTIPOINT") |>
            sf::st_coordinates() |>
            add_indice()
        })
    ) |>
    tidyr::unnest(geometry, names_repair = "unique")
}
