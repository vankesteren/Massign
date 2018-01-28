#' Quickly test matrix multiplication of two matrices interpreted from strings.
#'
#' Building on Massign's core functionality, the Multiplipe operator `%*>%`
#' allows for quick prototyping of matrix multiplications.
#'
#' @param matrix1 a matrix or Massign character matrix that premultiplies
#'
#' @param matrix2 a matrix or Massign character matrix that postmultiplies
#'
#' @examples
#' # Basic usage
#' "1, 2
#'  3, 4" %*>%
#'  " 0, 1
#'    1, 0"
#'
#' # Second argument can be a matrix:
#' "1, 2, pi \\ 3, 4, 1 \\ 3, 2, 1" %*>% diag(c(1, 2, 3))
#'
#' # Or the first, for that matter:
#' diag(c(1, 2, 3)) %*>% "1, 2, pi \\ 3, 4, 1 \\ 3, 2, 1"
#'
#'
#' @name Multiplipe
#'
#' @seealso \code{\link[base]{matrix}}, \code{\link{Massign}}
#'
#' @export
`%*>%` <- function(matrix1, matrix2) {
  areMats <- sapply(list(matrix1, matrix2), is.matrix)
  areChars <- sapply(list(matrix1, matrix2), is.character)
  m1 <- m2 <- NULL
  if (all(areChars)) {
    m1 %<-% matrix1
    m2 %<-% matrix2
    return(m1 %*% m2)
  } else if (areMats[1] && areChars[2]) {
    m2 %<-% matrix2
    return(matrix1 %*% m2)
  } else if (areMats[2] && areChars[1]) {
    m1 %<-% matrix1
    return(m1 %*% matrix2)
  } else if (all(areMats)) {
    warning("Just use %*%, silly!")
    return(matrix1 %*% matrix2)
  } else {
    stop("Use matrices or Massign character matrices!")
  }
}
