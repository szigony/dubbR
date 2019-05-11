#' Data wrangling of the scripts
#'
#' Creates the tibbles that should be returned for the separate functions
#'
#' @import docxtractr
#' @import stringr
#' @import dplyr

dub_data <- function() {
  # Read file
  file_name <- "ESD 938397 B – Fifth Gear – Season 22 Episode 01.docx"
  doc <- read_docx(paste0("source_files/", file_name))

  # Dissect file name
  translation_info <- function(file_name) {
    production_code <- str_extract(file_name, "E(S|H)D [0-9]{6} .")
    season <- str_extract(str_extract(file_name, "S(eason )?[0-9]+"), "[0-9]+")
    episode <- str_extract(str_extract(file_name, "E(pisode )?[0-9]+"), "[0-9]+")
    show <- str_replace(str_replace(file_name, production_code, ""), "[S(eason )?0-9E(pisode )?0-9]+.doc", "")
    show <- substr(show, 4, nchar(show) - 2)

    data.frame(production_code, show, season, episode)
  }

  metadata <- translation_info(file_name)
  metadata <- tibble::rowid_to_column(metadata, "dub_id")

  # Data wrangling
  # The first table only contains the characteristics of the characters, such as gender and age
  raw_text <- NULL
  for (i in seq(2, docx_tbl_count(doc), by = 1)) {
    raw_text <- bind_rows(raw_text, docx_extract_tbl(doc, i, header = FALSE))
  }

  # Create a tibble from characters
  characters <- raw_text %>%
    rename(character = V2) %>%
    filter(character != "") %>%
    mutate(dub_id = metadata$dub_id) %>%
    select(dub_id, character) %>%
    distinct()

  # Get rid of the timestamps, only keep the actual text
  # Remove empty rows
  text <- raw_text %>%
    rename(text = V3) %>%
    filter(text != "") %>%
    mutate(dub_id = metadata$dub_id) %>%
    select(dub_id, text)

  data <- list("dub_metadata" = metadata,
               "dub_text" = text,
               "dub_characters" = characters)

  return(data)
}
