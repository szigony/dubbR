#' Characters of the scripts
#'
#' The characters from the audiovisual translations. This can be used to create \code{anti_join}s so that the character names wouldn't skew the analysis.
#'
#' @export
#'
#' @param dub_id A list of IDs for which the characters should be imported.
#'
#' @format Returns a tibble with the characters from the scripts.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{character}: The characters that appear in the scripts.
#' }
#'
#' @examples
#' dub_characters()
#' dub_characters(c(1, 2))
#' dub_characters(dub_id_by_shows("Fifth Gear"))
#'
#' @seealso dub_metadata, dub_text, dub_shows

dub_characters <- function(dub_id) {
  data <- dub_data()

  if (missing(dub_id)) {
    dub_characters <- data$dub_characters
  } else {
    id_list <- c(dub_id)

    dub_characters <- data$dub_characters %>%
      filter(dub_id %in% id_list)
  }

  return(dub_characters)
}
