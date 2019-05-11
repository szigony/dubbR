#' Text of the scripts
#'
#' The text of the audiovisual translations, formatted to be convenient for text analysis.
#'
#' @export
#'
#' @param dub_id A list of IDs for which the texts should be imported.
#'
#' @format Returns a tibble with the text of the scripts.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{text}: The text from the scripts line by line.
#' }
#'
#' @examples
#' dub_text()
#' dub_text(c(1, 2))
#'
#' @seealso dub_metadata, dub_characters, dub_shows

dub_text <- function(dub_id) {
  data <- dub_data()

  if (missing(dub_id)) {
    dub_text <- data$dub_text
  } else {
    id_list <- c(dub_id)

    dub_text <- data$dub_text %>%
      filter(dub_id %in% id_list)
  }

  return(dub_text)
}