#' Shows that appear in the dubbR package
#'
#' A unique list of the shows that appear in the package. It can be used to explore the package and filter the contents.
#'
#' @importFrom tibble as.tibble
#' @import dplyr
#' @export
#'
#' @return tibble
#'
#' @format Returns a tibble with the unique list of shows that appear in the package.
#' \itemize{
#'     \item \code{show}: The unique TV shows in the package.
#' }
#'
#' @examples
#' dub_shows()
#'
#' @seealso \code{\link{dub_metadata}}, \code{\link{dub_text}}, \code{\link{dub_characters}}

dub_shows <- function() {
  shows <- as.tibble(dubbr_metadata %>%
    select(show) %>%
    distinct() %>%
    arrange())

  return(shows)
}
