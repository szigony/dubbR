#' Characters of the scripts
#'
#' The characters from the audiovisual translations. This can be used to create \code{anti_join}s so that the character names wouldn't skew the analysis.
#'
#' @export
#'
#' @format Returns a tibble with the characters from the scripts.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{character}: The characters that appear in the scripts.
#' }
#'
#' @examples
#' dub_characters()
#'
#' @seealso dub_metadata, dub_text, dub_shows

dub_characters <- function() {
  data <- dub_data()
  return(data$dub_characters)
}
