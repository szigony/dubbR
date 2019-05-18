#' Metadata of the scripts
#'
#' Metadata about audiovisual translations. The scripts were translated by Patrik Szigeti.
#'
#' @export
#'
#' @param shows The show or shows that are of interest.
#'
#' @return tibble
#'
#' @format Returns a tibble with the metadata.
#' \itemize{
#'     \item \code{dub_id}: Unique identifier of the scripts.
#'     \item \code{production_code}: The production code that was used by the production company.
#'     \item \code{show}: The name of the TV show.
#'     \item \code{season}: The season of the TV show for which the translation was requested.
#'     \item \code{episode}: The episode of the TV show within the season for which the translation was requested.
#' }
#'
#' @examples
#' dub_metadata()
#' dub_metadata("Fifth Gear")
#' dub_metadata(c("Fifth Gear", "Finding Bigfoot"))
#'
#' @seealso \code{\link{dub_text}}, \code{\link{dub_characters}}, \code{\link{dub_shows}}

dub_metadata <- function(shows) {

  if (missing(shows)) {
    dub_metadata <- dubbr_metadata
  } else {
    dub_metadata <- dubbr_metadata %>%
      filter(show %in% shows)
  }

  return(dub_metadata)
}
