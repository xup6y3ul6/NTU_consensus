library(shiny)
library(rdrop2)
library(dplyr)

# costom CSS
appCSS <-
  ".mandatory_star { color: red; }
   .font_red { color: red; }
   .align_right { float: right; }
   #error { color: red; }
   #incorrect_msg { color: red; font-style: italic; }
   .answer_bg { background-color: rgba(140, 202, 242, 0.25); }
   .instruction_bg { background-color: grey; }
   .margin{ margin-left: 5px; margin-right: 5%; }"

# Load NTU_quessionaire
. <- read.csv("NTU_questionnaire.csv", header = TRUE, encoding = "UTF8")
questions <- split(., seq(nrow(.)))
questionsID <- sapply(questions, "[[", "ID") %>% as.character()

# Define mandatory fields
fieldsMandatory <- c("name", questionsID)

# Show which fields are mandatory in the UI
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}


# Save the response upon submission
fieldsAll <- c("name", "num_years", questionsID)
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


