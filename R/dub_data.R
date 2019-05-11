#' Data wrangling of the scripts
#'
#' Creates the tibbles that should be returned for the separate functions
#'
#' @import docxtractr
#' @import stringr
#' @import dplyr

dub_data <- function() {
  # Function to dissect the file name
  translation_info <- function(file_name) {
    production_code <- str_extract(file_name, "E(S|H)D [0-9]{6} .")
    season <- str_extract(str_extract(file_name, "S(eason )?[0-9]+"), "[0-9]+")
    episode <- str_extract(str_extract(file_name, "E(pisode )?[0-9]+"), "[0-9]+")
    show <- str_replace(str_replace(file_name, production_code, ""), "[S(eason )?0-9E(pisode )?0-9]+.doc", "")
    show <- substr(show, 4, nchar(show) - 3)

    data.frame(production_code, show, season, episode)
  }

  # Read all files from the source_files/ directory
  file_list <- list.files(path = "source_files/")

  # Create the shell for the outputs
  all_metadata <- NULL
  all_text <- NULL
  all_characters <- NULL

  # Loop through all the files in the directory
  for (file_name in file_list) {

    # Read file
    doc <- read_docx(paste0("source_files/", file_name))

    # Create metadata and ID for the dubs
    metadata <- translation_info(file_name) %>%
      mutate(dub_id = which(file_name == file_list)) %>%
      select(dub_id, production_code, season, episode, show)

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

    all_metadata <- bind_rows(all_metadata, metadata)
    all_text <- bind_rows(all_text, text)
    all_characters <- bind_rows(all_characters, characters)
  }

  data <- list("dub_metadata" = all_metadata,
               "dub_text" = all_text,
               "dub_characters" = all_characters)

  return(data)
}
