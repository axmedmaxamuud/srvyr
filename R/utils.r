# Small helper function to get argument names from lazy dots
# and use them in order if no explicit names given
match_dot_args <- function(dots, arg_names) {
  dots_names <- names(dots)

  unused_args <- dots_names[!(dots_names %in% c("", arg_names))]
  if (length(unused_args) > 0) stop("unused argument ", unused_args[1])

  arg_nums <- match(dots_names, arg_names)
  # Complex way to use the arguments in order if they don't have names.
  arg_nums[is.na(arg_nums)] <- seq_along(arg_names)[setdiff(seq_along(arg_names), arg_nums)][seq_len(sum(is.na(arg_nums)))]

  names(dots) <- arg_names[arg_nums]
  dots
}

nullable <- function(f, x) {
  if (is.null(x)) NULL
  else f(x)
}

# From dplyr (utils.r)
"%||%" <- function(x, y) if(is.null(x)) y else x

# From dplyr (utils.r)
names2 <- function (x)
{
  names(x) %||% rep("", length(x))
}

# from dplyr (utils-format.r)
wrap <- function(..., indent = 0) {
  x <- paste0(..., collapse = "")
  wrapped <- strwrap(x, indent = indent, exdent = indent + 2,
                     width = getOption("width"))
  paste0(wrapped, collapse = "\n")
}

# from dplyr (utils.r)
dots <- function(...) {
  eval(substitute(alist(...)))
}

# from dplyr (utils.r)
named_dots <- function(...) {
  lazyeval::auto_name(dots(...))
}

# from dplyr (utils.r)
deparse_all <- function(x) {
  deparse2 <- function(x) paste(deparse(x, width.cutoff = 500L), collapse = "")
  vapply(x, deparse2, FUN.VALUE = character(1))
}

#' Pipe operator
#'
#' See \code{\link[magrittr]{\%>\%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL
