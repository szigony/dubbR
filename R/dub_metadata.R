#' Metadata of the scripts
#'
#' Metadata about audiovisual translations. The scripts were translated by Patrik Szigeti.
#'
#' @export
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
#'
#' @seealso \code{\link{dub_text}}, \code{\link{dub_characters}}, \code{\link{dub_shows}}

dub_metadata <- function() {
  data <- dub_data()
  return(data$dub_metadata)
}
