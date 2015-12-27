#' Create a tbl_svy from a data.frame
#'
#'#' \code{as_survey} can be used to create a \code{tbl_svy} using design information
#' (\code{\link{design_survey}}), replicate weights (\code{\link{design_survey_rep}}),
#' or a two phase design (\code{\link{design_twophase}}). \code{as_survey_} is its
#' standard evaluation counterpart.
#'
#' @param .data a data.frame
#' @param ... other arguments, see details.
#'
#' @return a tbl_svy
#' @export
#' @examples
#' # Examples from ?survey::svydesign
#' library(survey)
#' data(api)
#'
#' # stratified sample
#' dstrata <- apistrat %>%
#'   as_survey(strata = stype, weights = pw)
#'
#' # Examples from ?survey::svrepdesign()
#' data(scd)
#' # use BRR replicate weights from Levy and Lemeshow
#' scd$rep1 <- 2 * c(1, 0, 1, 0, 1, 0)
#' scd$rep2 <- 2 * c(1, 0, 0, 1, 0, 1)
#' scd$rep3 <- 2 * c(0, 1, 1, 0, 0, 1)
#' scd$rep4 <- 2 * c(0, 1, 0, 1, 1, 0)
#'
#' scdrep <- scd %>%
#'   as_survey(type = "BRR", repweights = starts_with("rep"),
#'                     combined_weights = FALSE)
#'
#'#' # Examples from ?survey::twophase
#' # two-phase simple random sampling.
#' data(pbc, package="survival")
#'
#' pbc <- pbc %>%
#'   mutate(randomized = !is.na(trt) & trt > 0,
#'          id = row_number())
#' d2pbc <- pbc %>%
#'   as_survey(id = list(id, id), subset = randomized)
#'
as_survey <- function(.data, ...) {
  dots <- lazyeval::lazy_dots(...)
  if ("repweights" %in% names(dots)) {
    design_survey_rep(.data, ...)
  } else if ("id" %in% names(dots) | "ids" %in% names(dots)) {
    # twophase has a list of 2 groups for id, while regular id is just a set of variables
    id_expr <- as.character(dots$id$expr)
    if ("list" %in% id_expr & length(id_expr) == 3) {
      design_twophase(.data, ...)
    } else {
      design_survey(.data, ...)
    }
  } else {
    design_survey(.data, ...)
  }
}

#' @export
#' @rdname as_survey
as_survey_ <- function(.data, ...) {
  dots <- lazyeval::lazy_dots(...)
  if ("repweights" %in% names(dots)) {
    design_survey_rep_(.data, ...)
  } else if ("id" %in% names(dots) | "ids" %in% names(dots)) {
    # twophase has a list of 2 groups for id, while regular id is just a set of variables
    id_expr <- as.character(dots$id$expr)
    if ("list" %in% id_expr & length(id_expr) == 3) {
      design_twophase_(.data, ...)
    } else {
      design_survey_(.data, ...)
    }
  } else {
    design_survey_(.data, ...)
  }
}
