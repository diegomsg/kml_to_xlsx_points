# bibliotecas -----
library(shiny)
library(bslib)
library(bsicons)
library(tmap)
tmap_mode("view")

# dependencias -----
source("R/files_handler.R")
source("R/points_extract.R")
source("R/mapping.R")

# UI -----
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "cosmo"),

  ## title -----
  title = "Extrair pontos de KML para XLSX ou CSV",

  ## sidebar -----
  sidebar = sidebar(

    ## inputs -----
    accordion(
      ### select file -----
      accordion_panel(
        title = "Upload",
        icon = bs_icon("upload"),
        fileInput(
          "kml_file",
          label = "Forneça um ou mais arquivos KML",
          buttonLabel = "Selecionar...",
          placeholder = "Nenhum selecionado",
          multiple = TRUE,
          accept = c(".kml")),
        span("Tamanho limite de arquivos: 5 MB")
      ),

      ### parâmetros de tabela -----
      accordion_panel(
        title = "Precisão",
        icon = bs_icon("123"),
        sliderInput(
          "digits",
          label = "Decimais das coordenadas na tabela",
          min = 4,
          max = 15,
          value = 11,
          step = 1,
          round = TRUE),
        tooltip(
          span(
            "Padrão: 11 (onze) casas decimais, observando-se:",
            bs_icon("info-circle"),
            tags$li("(i) latitude (-34º a +06º)"),
            tags$li("(ii) longitude (-074º a -030º)"),
            tags$li("(iii) altitude (-100m a 3000m)")
          ),
          "MCR-02 Documentos-01 Requisitos Sicor-25-Nota a"
        ),
      ),

      #### download -----
      accordion_panel(
        title = "Download",
        icon = bs_icon("download"),
        selectInput(
          "filetype",
          "Tipo de arquivo:",
          choices = list(
            "MS Excel (.xlsx)" = "xlsx",
            "Arquivo separado por vírgula (.csv)" = "csv"),
          selected = "xlsx",
          multiple = FALSE
        ),
        downloadButton("download_file")
      )
    )
  ),

  ## principal -----
  navset_card_pill(
    title = "Conteúdo do KML",
    full_screen = TRUE,

    ### tabela -----
    tabPanel(
      "Pontos",
      tableOutput("table")
    ),

    ### mapa -----
    nav_panel(
      "Mapa",
      tmapOutput(
        "map_plot"
        # mode = "view"
      )
    ),

    ### file -----
    tabPanel(
      "Arquivo(s)",
      tableOutput("file_info")
    )
  ),
  ## lang -----
  lang = "pt"
)

# Server -----
server <- function(input, output) {

  ## user input -----
  file_info <- reactive({
    req(input$kml_file)

    data <- input$kml_file[c("name", "size")]
    data$size <- data$size / 1024
    colnames(data) <- c("Arquivo", "Tamanho (kB)")
    data
  })

  data <- reactive({
    req(input$kml_file)

    read_kml_file(input$kml_file)
  })

  digits <- reactive({
    req(input$digits)

    input$digits
  })

  ### reactive content -----
  points_table <- reactive({
    data() |>
      expand_kml_features() |>
      expand_points()
  })

  # geo <- reactive({
  #   data() |>
  #     _$sf_content |>
  #     tm_shape(
  #       name = "Áreas do KML",
  #       crs = "auto") +
  #     tm_polygons(
  #       "Name",
  #       fill_alpha = .6)
  # })

  geo <- reactive({
    map_object(data()$sf_content)
  })

  out_type <- reactive({
    req(input$filetype)

    input$filetype
  })

  ### outputs -----
  output$file_info <- renderTable(
    file_info(),
    striped = TRUE,
    hover = TRUE,
    digits = 1,
    colnames = TRUE,
    spacing = "s")

  output$table <- renderTable(
    points_table(),
    striped = TRUE,
    hover = TRUE,
    digits = reactive(digits()),
    colnames = TRUE,
    spacing = "s")

  output$map_plot <- renderTmap(
    geo()
  )

  output$download_file <- downloadHandler(
    filename = function() {
      paste(name_auto("kml_pontos"), out_type(), sep = ".")},
    content = function(file) {
      switch(
        out_type(),
        xlsx = export_xlsx(
          points_table(),
          filename = file),
        csv = export_csv(
          points_table(),
          filename = file)
      )
    }
  )
}

# Run -----
shinyApp(ui = ui, server = server)
