library(shiny)
library(rdrop2)

# costom CSS
appCSS <-
  ".mandatory_star { color: red; }
   #error { color: red; }
   #incorrect_msg { color: red; font-style: italic; }"


# Define mandatory fields
fieldsMandatory <- c("name", "favourite_pkg")

# Show which fields are mandatory in the UI
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}


# Save the response upon submission
fieldsAll <- c("name", "favourite_pkg", "used_shiny", "r_num_years", "os_type")
outputDir <- file.path("responses")
epochTime <- function() {as.integer(Sys.time())}
humanTime <- function() {format(Sys.time(), "%Y%m%d-%H%M%OS")}

saveData <- function(data) {
  fileName <- sprintf("%s_%s.csv",
                      humanTime(),
                      digest::digest(data))
  filePath <- file.path(tempdir(), fileName)
  write.csv(x = data, file = filePath,
            row.names = FALSE, quote = TRUE)
  drop_upload(filePath, path = outputDir)
}

# Add table that shows all previous responses
loadData <- function() {
  filesInfo <- drop_dir(outputDir)
  filePaths <- filesInfo$path_display
  #files <- list.files(file.path(responsesDir), full.names = TRUE)
  data <- lapply(filePaths, drop_read_csv, stringsAsFactors = FALSE)
  data <- dplyr::bind_rows(data)
  data
}

adminPassword <- "NTU"
admitPanelIO <- "isHidden"