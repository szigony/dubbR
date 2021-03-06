#' Characters of the scripts
#'
#' The characters from the audiovisual translations. This can be used to create \code{anti_join}s so that the character names wouldn't skew the analysis.
#'
#' @export
#'
#' @param shows The show or shows that are of interest.
#'
#' @return tibble
#'
#' @format Returns a tibble with the characters from the scripts.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{character}: The characters that appear in the scripts.
#' }
#'
#' @examples
#' dub_characters()
#' dub_characters("Fifth Gear")
#' dub_characters(c("Fifth Gear", "Finding Bigfoot"))
#'
#' @seealso \code{\link{dub_metadata}}, \code{\link{dub_text}}, \code{\link{dub_shows}}, \code{\link{dub_id_by_shows}}

dub_characters <- function(shows) {

  if (missing(shows)) {
    dub_characters <- dubbr_characters
  } else {
    dub_characters <- as.tibble(dubbr_metadata %>%
                            filter(show %in% shows) %>%
                            select(dub_id) %>%
                            inner_join(dubbr_characters))
  }

  return(dub_characters)

}
