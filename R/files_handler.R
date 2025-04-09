name_auto <- function(id = NULL) {
  paste(
    id,
    format(Sys.time(), "%Y-%m-%d_%H%M%S"),
    sep = "_") |>
  trimws()
}

export_xlsx <- function(tbl, filename = "file") {
  writexl::write_xlsx(
    x = tbl,
    path = filename,
    col_names = TRUE)
}

export_csv <- function(tbl, filename = "file") {
  readr::write_csv2(
    x = tbl,
    file = filename,
    append = FALSE)
}
