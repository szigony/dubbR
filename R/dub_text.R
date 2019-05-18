#' Text of the scripts
#'
#' The text of the audiovisual translations, formatted to be convenient for text analysis.
#'
#' @export
#'
#' @param shows The show or shows that are of interest.
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
#' dub_text("Fifth Gear")
#' dub_text(c("Fifth Gear", "Finding Bigfoot"))
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
