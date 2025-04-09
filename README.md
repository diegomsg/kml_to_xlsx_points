
# kml_to_xlsx_points

<!-- badges: start -->
<!-- badges: end -->

## Overview

**kml_to_xlsx_points** is an R Shiny application designed to extract points from KML files representing land polygons, following SICOR/BCB standards, and export the data to XLSX or CSV files. This tool is particularly useful for geographic data analysis and visualization.

## Features

- **Upload KML Files**: Easily upload one or more KML files.
- **Precision Control**: Adjust the number of decimal places for coordinates.
- **Data Export**: Export extracted points to MS Excel (.xlsx) or CSV (.csv) formats.
- **Interactive Map**: Visualize KML content on an interactive map.
- **File Information**: View details of uploaded files.

## Installation

To run this application, ensure you have R and the necessary packages installed. You can install the required packages using the following commands:

```R
install.packages(c("shiny", "bslib", "bsicons", "tmap"))
```

## Usage

1. **Clone the repository**:
    ```sh
    git clone https://github.com/diegomsg/kml_to_xlsx_points.git
    cd kml_to_xlsx_points
    ```

2. **Run the Shiny app**:
    ```R
    library(shiny)
    shinyApp(ui = ui, server = server)
    ```

## Code Structure

### Libraries

```R
library(shiny)
library(bslib)
library(bsicons)
library(tmap)
tmap_mode("view")
```

### Dependencies

```R
source("R/files_handler.R")
source("R/points_extract.R")
source("R/mapping.R")
```

### UI

The user interface is built using `page_sidebar` with a `bs_theme` for styling. It includes panels for file upload, precision settings, and data download options.

### Server

The server function handles file uploads, data extraction, precision settings, and data export. It also renders the interactive map and tables.

### Running the App

To run the app, use the `shinyApp(ui = ui, server = server)` function.

## Contributing

Feel free to contribute to this project by submitting issues or pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
