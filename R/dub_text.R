#' Text of the scripts
#'
#' The text of the audiovisual translations, formatted to be convenient for text analysis.
#'
#' @import dplyr
#' @export
#'
#' @param dub_id A list of IDs for which the texts should be imported.
#'
#' @return tibble
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
#' dub_text(dub_id_by_shows("Fifth Gear"))
#'
#' @seealso \code{\link{dub_metadata}}, \code{\link{dub_characters}}, \code{\link{dub_shows}}, \code{\link{dub_id_by_shows}}

dub_text <- function(shows) {

  if (missing(shows)) {
    dub_text <- dubbr_text
  } else {
    dub_text <- as.tibble(dubbr_metadata %>%
      filter(show %in% shows) %>%
      select(dub_id) %>%
      inner_join(dubbr_text))
  }

  return(dub_text)

}
