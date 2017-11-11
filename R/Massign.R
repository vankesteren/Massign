#' Construct a matrix from a (formatted) string
#'
#' Constructing matrices for quick prototyping can be very annoying in \code{R},
#' requiring the user to think about how to fill the matrix with values
#' using the \code{matrix(data, nrow, ncol, byrow)} function. The \code{\%<-\%}
#' operator solves that issue by allowing the user to construct string matrices
#' that look like actual matrices.
#'
#'
#' @usage
#' x \%<-\% textMatrix
#'
#' @examples
#' M %<-% "   1,  0.2, -0.3,  0.4
#'          0.2,    1,  0.6, -0.4
#'         -0.3,  0.6,    1,  0.4
#'          0.4, -0.4,  0.4,    1"
#'
#' @name Massign
#'
#' @seealso \code{\link[base]{matrix}}
#'
#' @export
`%<-%` <- function(var, txt) {
  # argument checking
  if (!is.character(txt)) {
    stop("Please enter a proper character matrix. See ?`%<-%`")
  }

  # first, remove trailing commas if they exist
  txt <- gsub("\\,[^0-9]*(?=\\n)", "", txt, perl = TRUE)

  # then extract the first row
  match1 <- gregexpr("[0-9].*(?=\\n)", txt, perl = TRUE)
  start <- match1[[1]][1]
  stop <- start + attr(match1[[1]], which = "match.length")[1] - 1
  firstrow <- substr(txt, start, stop)

  # calculate nrow and ncol using number of commas
  commasFirstRow <- length(gregexpr(",", firstrow, fixed = TRUE)[[1]])
  commasTotal <- length(gregexpr(",", txt, fixed = TRUE)[[1]])

  nr <- commasFirstRow + 1
  nc <- commasTotal/commasFirstRow

  # generate data argument of matrix function
  d <- gsub("\\n", ",", txt)
  d <- as.numeric(strsplit(d, ",", fixed = TRUE)[[1]])

  if (length(d) != nr*nc) {
    stop("(Syntax) number of values not equal to number of cells in matrix.")
  }

  # create matrix
  mat <- matrix(data = d, byrow = TRUE, nrow = nr, ncol = nc)

  # assign to specified variable. This is pretty hacky but works well, even for
  # subenvironments and lists etc.
  # TODO: make less hacky

  # first, get the environment in which the function was called
  pf <- parent.frame()

  # then, create a variable with a reserved name
  pf$`__MassignMat__` <- mat

  # then, simply evaluate the assignment in the pf with the newly created var
  eval(parse(text = paste0(deparse(substitute(var)), " <- `__MassignMat__`")),
       envir = pf)

  # lastly, remove the var.
  evalq(rm("__MassignMat__"), envir = pf)
}


#' @rdname Massign
#'
#' @usage
#' textMatrix \%->\% x
#'
#' @export
`%->%` <- function(txt, var) {
  # argument checking
  if (!is.character(txt)) {
    stop("Please enter a proper character matrix. See ?`%->%`")
  }

  # first, remove trailing commas if they exist
  txt <- gsub("\\,[^0-9]*(?=\\n)", "", txt, perl = TRUE)

  # then extract the first row
  match1 <- gregexpr("[0-9].*(?=\\n)", txt, perl = TRUE)
  start <- match1[[1]][1]
  stop <- start + attr(match1[[1]], which = "match.length")[1] - 1
  firstrow <- substr(txt, start, stop)

  # calculate nrow and ncol using number of commas
  commasFirstRow <- length(gregexpr(",", firstrow, fixed = TRUE)[[1]])
  commasTotal <- length(gregexpr(",", txt, fixed = TRUE)[[1]])

  nr <- commasFirstRow + 1
  nc <- commasTotal/commasFirstRow

  # generate data argument of matrix function
  d <- gsub("\\n", ",", txt)
  d <- as.numeric(strsplit(d, ",", fixed = TRUE)[[1]])

  if (length(d) != nr*nc) {
    stop("(Syntax) number of values not equal to number of cells in matrix.")
  }

  # create matrix
  mat <- matrix(data = d, byrow = TRUE, nrow = nr, ncol = nc)

  # assign to specified variable. This is pretty hacky but works well, even for
  # subenvironments and lists etc.
  # TODO: make less hacky

  # first, get the environment in which the function was called
  pf <- parent.frame()

  # then, create a variable with a reserved name
  pf$`__MassignMat__` <- mat

  # then, simply evaluate the assignment in the pf with the newly created var
  eval(parse(text = paste0(deparse(substitute(var)), " <- `__MassignMat__`")),
       envir = pf)

  # lastly, remove the var.
  evalq(rm("__MassignMat__"), envir = pf)
}


