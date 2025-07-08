library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(plotly)
library(readr)
library(lubridate)
library(tidyr)

# Load default dataset (fallback)
default_data <- read_csv("data/barangay_health_tracker_sample_300.csv")

# UI
ui <- fluidPage(
  titlePanel("Barangay Health Tracker – Zamboanga City"),
  sidebarLayout(
    sidebarPanel(
      fileInput("csv_file", "Upload Patient CSV File", accept = c(".csv")),
      selectInput("barangay", "Filter by Barangay:", choices = "All", selected = "All")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Illness Pie Chart", plotOutput("illnessPie")),
        tabPanel("Heatmap", leafletOutput("heatmap")),
        tabPanel("Time Series", plotlyOutput("timeSeries")),
        tabPanel("Demographics", plotlyOutput("demographics"))
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {
  # Define illness abbreviations
  illness_abbr <- c(
    "Acute Gastroenteritis" = "AGE",
    "Animal bites (Rabies monitoring)" = "Rabies",
    "COVID-19" = "COVID",
    "Dengue" = "Dengue",
    "Diabetes" = "DM",
    "Hypertension" = "HTN",
    "Influenza-like Illness" = "ILI",
    "Leptospirosis" = "Lepto",
    "Other" = "Other",
    "Skin infections" = "Skin",
    "Tuberculosis" = "TB",
    "Upper Respiratory Infections" = "URI"
  )
  
  # Load uploaded file or default
  dataset <- reactive({
    if (is.null(input$csv_file)) {
      default_data
    } else {
      read_csv(input$csv_file$datapath)
    }
  })
  
  # Clean and transform the data
  data_clean <- reactive({
    dataset() %>%
      mutate(
        date = mdy_hms(Timestamp),
        age = as.numeric(floor((Sys.Date() - mdy(Birthdate)) / 365.25)),
        age_group = cut(age, breaks = c(0, 18, 35, 60, 100), labels = c("0–18", "19–35", "36–60", "60+")),
        gender = Sex,
        barangay = Barangay,
        illness = `Illness(es) diagnosed`
      )
  })
  
  # Update barangay dropdown based on uploaded data
  observe({
    updateSelectInput(session, "barangay",
                      choices = c("All", unique(data_clean()$barangay)))
  })
  
  # Filter by barangay
  filtered_data <- reactive({
    if (input$barangay == "All") {
      data_clean()
    } else {
      data_clean() %>% filter(barangay == input$barangay)
    }
  })
  
  # Pie Chart with abbreviations + case counts
  output$illnessPie <- renderPlot({
    fd <- filtered_data() %>%
      separate_rows(illness, sep = ",\\s*") %>%
      count(illness) %>%
      mutate(
        abbr = illness_abbr[illness],
        percent = round(n / sum(n) * 100, 1),
        label = paste0(abbr, "\n", n, " (", percent, "%)")
      )
    
    ggplot(fd, aes(x = "", y = n, fill = illness)) +
      geom_col(width = 1) +
      coord_polar("y") +
      geom_text(aes(label = label), position = position_stack(vjust = 0.5), size = 4.2) +
      theme_void() +
      labs(
        title = "Distribution of Illnesses",
        caption = "Note: Labels use abbreviations. See legend for full illness names."
      ) +
      theme(
        plot.caption = element_text(hjust = 0.5, size = 10, face = "italic", margin = margin(t = 10))
      )
  })
  
  # Time Series Line Plot
  output$timeSeries <- renderPlotly({
    fd <- filtered_data() %>%
      mutate(day = as.Date(date)) %>%
      separate_rows(illness, sep = ",\\s*") %>%
      count(day, illness)
    
    p <- ggplot(fd, aes(x = day, y = n, color = illness)) +
      geom_line(size = 1.2) +
      labs(title = "Illnesses Over Time", x = "Date", y = "Cases")
    
    ggplotly(p)
  })
  
  # Demographics Plot
  output$demographics <- renderPlotly({
    fd <- filtered_data() %>%
      count(age_group, gender)
    
    p <- ggplot(fd, aes(x = age_group, y = n, fill = gender)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Age & Gender Breakdown", x = "Age Group", y = "Number of Cases")
    
    ggplotly(p)
  })
  
  # Barangay Heatmap
  output$heatmap <- renderLeaflet({
    # Approximate dummy coordinates per barangay
    barangay_coords <- tibble::tibble(
      barangay = unique(data_clean()$barangay),
      lat = c(6.9214, 6.9102, 6.9305, 6.9080, 6.9130, 6.9002, 6.9271, 6.9225, 6.8821, 6.9015),
      lng = c(122.0790, 122.0785, 122.0650, 122.0701, 122.0753, 122.0820, 122.0600, 122.0800, 122.0900, 122.0742)
    )
    
    fd <- filtered_data() %>%
      separate_rows(illness, sep = ",\\s*") %>%
      count(barangay)
    
    heat_data <- left_join(fd, barangay_coords, by = "barangay")
    
    leaflet(heat_data) %>%
      addTiles() %>%
      addCircles(
        lat = ~lat, lng = ~lng, radius = ~n * 100,
        color = "red", stroke = FALSE, fillOpacity = 0.6,
        popup = ~paste(barangay, ":", n, "cases")
      )
  })
}

# Run the app
shinyApp(ui, server)
