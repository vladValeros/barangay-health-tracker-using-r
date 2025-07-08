# barangay-health-tracker-using-r
Programming Languages (PL129) Project

# Barangay Health Tracker – Zamboanga City

An interactive web app built using **R (Shiny)** to help **local health workers** visualize and monitor illness trends in their communities.

---

## Problem Statement

Many barangay-level health facilities rely on fragmented or manual records, making it difficult to identify health trends, respond to outbreaks, or make data-informed decisions. There's a need for a lightweight, accessible, and visual data tool that can interpret patient-level data in real-time — especially for underserved and low-resource communities.

---

## Purpose

This project provides a dashboard for **community-level health surveillance** using anonymized `.csv` patient data. It enables **local health workers** and barangay health centers to:

- Visualize illness trends by location and demographics
- Monitor spikes and outbreaks through time-series plots
- Track common illnesses per barangay
- Simplify patient data reporting using existing tools like Google Forms

---

## Sustainable Development Goal (SDG) Alignment

This project contributes to:

### **SDG 3: Good Health and Well-being**
> _“Ensure healthy lives and promote well-being for all at all ages.”_

By empowering barangay health centers with tools to make **data-informed decisions**, this project supports early disease detection, proactive community health measures, and accessible reporting.

---

## Sample deployment
- [View Sample Deployment](https://vladvaleros.shinyapps.io/barangay-health-tracker/)  

## How to Run the App Locally

### **Step 1: Install R and RStudio**

- [Download RStudio](https://posit.co/download/rstudio-desktop/)  
- [Install R 4.4.3 (or latest stable)](https://cran.r-project.org/bin/windows/base/old/4.4.3/)

---

### **Step 2: Set Up the Patient Data Form**

Use the following **Google Form** as a template for collecting patient data:  
📄 [Health Tracker Form Template](https://forms.gle/XNi914cY9fri4xEy7)

Once you receive responses:
1. Open the form’s **linked Google Sheet**
2. Go to **File > Download > .csv** to export the dataset

---

### **Step 3: Prepare Your R Project**

1. Open RStudio
2. Create a new **R Script** file (`File > New File > R Script`)
3. Save it as `app.R`
4. Copy-paste the complete app code (from this repository)

---

### **Step 4: Install Required Packages**

Run this in the R console:

```r
install.packages(c("shiny", "ggplot2", "dplyr", "leaflet", "plotly", "readr", "lubridate", "tidyr"))
```


### **Step 5: Add Optional Upload Feature**

The app supports file uploads, allowing users to upload .csv files using the same structure as the template.

📁 You may use the included sample file:

data/barangay_health_tracker_sample_300.csv – Used as default if no upload is made


## Deploying to shinyapps.io

### **Step 6: Create a Shinyapps.io Account**

1. Sign up at shinyapps.io

2. Install deployment tools:

```r
install.packages("rsconnect")
```

3. In RStudio, enter the following (replace with your actual account values):
```r
library(rsconnect)
rsconnect::setAccountInfo(name='your_account_name', token='your_token', secret='your_secret_ID')
rsconnect::deployApp('C:\\path\\to\\your\\project\\folder')
```
Replace the path with the directory that contains your app.R file.

## File Structure
```
barangay-health-tracker/
├── app.R
├── data/
│   └── barangay_health_tracker_sample_300.csv
```

## Features

- **Pie Chart** of illness distribution per barangay  
- **Heatmap** of affected barangays using Leaflet  
- **Time-Series** chart to monitor trends and potential outbreaks  
- **Demographic Breakdown** by age group and gender  
- **CSV Upload Support** for user-submitted data  
- **Google Form Integration** for easy data collection  

## Future Improvements

- Add **date range filters** for more precise trend analysis  
- Export **filtered data as CSV**  
- Add **basic user authentication**  
- Use **actual barangay shapefiles** for more precise heatmaps  
- Include **data validation** before upload (e.g., required fields)  
- Translate UI to **local languages** (e.g., Chavacano, Tausug)  
- Make the UI **mobile-responsive**


## License
This project is open-source and free to use for educational purposes.

## Contributors
- Amin, Ionyjal Aziz
- Idulsa, Emman Nicholas
- Valeros, Vladimir II

Dataset Design: [Contributors or health workers you consulted, optional]

