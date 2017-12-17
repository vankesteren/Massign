#' Construct a matrix from a (formatted) string
#'
#' Constructing matrices for quick prototyping can be very annoying in \code{R},
#' requiring the user to think about how to fill the matrix with values
#' using the \code{matrix(data, nrow, ncol, byrow)} function. The \code{\%<-\%}
#' operator solves that issue by allowing the user to construct string matrices
#' that look like actual matrices.
#'
#' @param var the variable to which the matrix will be assigned. Can be an element
#' of a list.
#'
#' @param value a matrix in character form to be converted to a numeric
#' matrix. See examples for valid forms.
#'
#' @examples
#' # Basic usage
#' M %<-% "   1,  0.2, -0.3,  0.4
#'          0.2,    1,  0.6, -0.4
#'         -0.3,  0.6,    1,  0.4
#'          0.4, -0.4,  0.4,    1"
#' M
#'
#' # Variables allowed!
#' phi <- 1.5
#' V %<-% "1,     1,     1
#'         1,   phi, phi^2
#'         1, phi^2, phi^4"
#' V
#'
#' # Lower triangular is made symmetric:
#' S %<-% "   1
#'          0.5,   1
#'         -0.2, 0.2,   1"
#' S
#'
#' # Complex matrices work too:
#' C %<-% "  1+2i, 2+1i, 3+4i
#'         4+0.5i, 5+2i, 6+4i"
#' C
#'
#' # And lastly, if you're a fan of LaTeX and one-liners:
#' L %<-% "1, 2, 3 \\ 4, 5, 6 \\ 7, 8, 9 \\ 10, 11, 12"
#' # (although this kind of defeats the WYSIWYG purpose of Massign)
#'
#' @name Massign
#'
#' @seealso \code{\link[base]{matrix}}
#'
#' @export
`%<-%` <- function(var, value) {
  # argument checking
  if (!is.character(value)) {
    stop("Please enter a proper character matrix. See ?`%<-%`")
  }

  # first, remove trailing commas if they exist
  txt <- gsub("\\,[^0-9]*(?=\\n)", "", value, perl = TRUE)

  # then extract the rows
  rows <- strsplit(txt, "[\n\\\\]", perl = TRUE)[[1]]

  # calculate nrow and ncol using number of commas
  commas <- sapply(gregexpr(",", rows, fixed = TRUE),
                   function(x) {
                     if (x[1] < 0) {
                       return(0)
                     } else {
                       length(x)
                     }
                   })
  commasTotal <- sum(commas)

  nc <- max(commas) + 1
  nr <- length(rows)

  nValues <- commasTotal + nr

  if (nValues != nr*nc) {
    isLowerTriangular <- all(commas == seq_along(commas) - 1)
    isUpperTriangular <- all(commas == rev(seq_along(commas) - 1))
    if (isLowerTriangular) {
      # fill the upper triangle
      for (i in seq_along(rows)) {
        sRows <- strsplit(rows, ",")
        rows[[i]] <- paste(sapply(sRows, function(x) x[i]), collapse = ",")
      }
    } else if (isUpperTriangular) {
      stop("Upper triangular matrices not yet supported, use lower triangular.")
    } else {
      stop("(Syntax) number of values not equal to number of cells in matrix.")
    }
  }

  # create data comma separated values
  d <- paste(rows, collapse = ",")

  # create matrix expression
  matExp <- paste0("matrix(data = c(", d, "), byrow = TRUE, nrow = ", nr,
                   ", ncol = ", nc, ")")

  # Assign to temporary variable. This system is petty hacky but works well,
  # even for subenvironments and lists etc.
  # First, get the environment in which the function was called
  pf <- parent.frame()

  # Then, create a variable with a reserved name
  eval(parse(text = paste0("`__MassignMat__` <-", matExp)), envir = pf)

  # Next, simply evaluate the assignment in the pf with the newly created var
  eval(parse(text = paste0(deparse(substitute(var)), " <- `__MassignMat__`")),
       envir = pf)

  # Lastly, remove the var.
  evalq(rm("__MassignMat__"), envir = pf)
}


#' @rdname Massign
#'
#' @export
`%->%` <- function(value, var) {
  # init variable
  eval(parse(text = paste0(deparse(substitute(var)), "<- NULL")),
       envir = parent.frame())
  # run %<-% on the value and variable
  eval(parse(text = paste0("`%<-%`(",
                           deparse(substitute(var)),
                           ",'", value,"')")),
       envir = parent.frame())
}


