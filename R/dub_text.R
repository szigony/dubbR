#' Text of the scripts
#'
#' The text of the audiovisual translations, formatted to be convenient for text analysis.
#'
#' @export
#'
#' @format Returns a tibble with the text of the scripts.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{text}: The text from the scripts line by line.
#' }
#'
#' @examples
#' dub_text()
#'
#' @seealso dub_metadata, dub_characters, dub_shows

dub_text <- function() {
  data <- dub_data()
  return(data$dub_text)
}
