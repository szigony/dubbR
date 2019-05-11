#' Shows that appear in the dubbR package
#'
#' A unique list of the shows that appear in the package. It can be used to explore the package and filter the contents.
#'
#' @importFrom tibble as.tibble
#' @export
#'
#' @format Returns a tibble with the unique list of shows that appear in the package.
#' \itemize{
#'     \item \code{show}: The unique TV shows in the package.
#' }
#'
#' @examples
#' dub_shows()
#'
#' @seealso dub_metadata, dub_text, dub_characters

dub_shows <- function() {
  data <- dub_data()
  shows <- as.tibble(data$dub_metadata %>%
    select(show) %>%
    distinct())

  return(shows)
}
