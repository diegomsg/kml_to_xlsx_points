name_auto <- function(id = NULL) {
  paste(
    id,
    format(Sys.time(), "%Y-%m-%d_%H%M%S"),
    sep = "_") |>
  trimws()
}
