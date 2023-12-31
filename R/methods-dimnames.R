# ==== LongTable Class

#' Get the column names from a `LongTable` object.
#'
#' @examples
#' head(colnames(merckLongTable))
#'
#' @describeIn LongTable Retrieve the pseudo-colnames of a LongTable object,
#'   these are constructed by pasting together the colIDs(longTable) and
#'   can be used in the subset method for regex based queries.
#'
#' @param x A `LongTable` object to get the column names from
#'
#' @return `character` Vector of column names.
#'
#' @export
setMethod('colnames', signature(x='LongTable'), function(x) {
    return(x@colData$.colnames)
})

#' Get the row names from a `LongTable` object.
#'
#' @examples
#' head(rownames(merckLongTable))
#'
#' @describeIn LongTable Retrieve the pseudo-rownames of a LongTable object,
#'   these are constructed by pasting together the rowIDs(longTable) and
#'   can be used in the subset method for regex based queries.
#'
#' @param x A `LongTable` object to get the row names from
#'
#' @return `character` Vector of row names.
#'
#' @export
setMethod('rownames', signature(x='LongTable'), function(x) {
    return(x@rowData$.rownames)
})

#' Getter for the dimnames of a `LongTable` object
#'
#' @examples
#' lapply(dimnames(merckLongTable), head)
#'
#' @describeIn LongTable Get the pseudo-dimnames for a LongTable object. See
#'   colnames and rownames for more information.
#'
#' @param x The `LongTable` object to retrieve the dimnames for.
#'
#' @return `list` List with two character vectors, one for row and one for
#'     column names.
#'
#' @importMethodsFrom Biobase dimnames
#' @export
setMethod('dimnames', signature(x='LongTable'), function(x) {
    return(list(x@rowData$.rownames, x@colData$.colnames))
})
