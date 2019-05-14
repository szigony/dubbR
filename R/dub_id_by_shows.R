#' IDs for shows
#'
#' Get the list of IDs that are in scope for the selected set of shows.
#'
#' This would tipically be used to filter for texts or characters of a specific show.
#'
#' @export
#'
#' @param shows A show or a list of shows for which we'd like to return the \code{dub_id}s.
#'
#' @return vector
#'
#' @format Returns a list of \code{dub_id}s.
#'
#' @examples
#' dub_id_by_shows("Fifth Gear")
#' dub_id_by_shows(c("Fifth Gear", "Finding Bigfoot"))
#'
#' @seealso \code{\link{dub_text}}, \code{\link{dub_characters}}

dub_id_by_shows <- function(shows) {
  in_scope_dubs <- dub_data()$dub_metadata %>%
    filter(show %in% shows)

  return(in_scope_dubs$dub_id)
}
