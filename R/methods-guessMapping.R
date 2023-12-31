#' Generic for Guessing the Mapping Between Some Raw Data and an S4 Object
#'
#' @param object An `S4` object containing so raw data to guess data to
#'   object slot mappings for.
#' @param ... Allow new arguments to be defined for this generic.
#'
#' @return A `list` with mapping guesses as items.
#'
#' @examples
#' "Generics shouldn't need examples!"
#'
#' @md
#' @export
setGeneric('guessMapping', function(object, ...) standardGeneric('guessMapping'))

#' Guess which columns in raw experiment data map to which dimensions.
#'
#' Checks for columns which are uniquely identified by a group of identifiers.
#' This should be used to help identify the columns required to uniquely
#' identify the rows, columns, assays and metadata of a `DataMapper` class
#' object.
#'
#' @details
#' Any unmapped columns will be added to the end of the returned `list` in an
#' item called unmapped.
#'
#' The function automatically guesses metadata by checking if any columns have
#' only a single value. This is returned as an additional item in the list.
#'
#' @param object A `LongTableDataMapper` object.
#' @param groups A `list` containing one or more vector of column names
#'   to group-by. The function uses these to determine 1:1 mappings between
#'   the combination of columns in each vector and unique values in the raw
#'   data columns.
#' @param subset A `logical` vector indicating whether to to subset out mapped
#'   columns after each grouping. Must be a single `TRUE` or `FALSE` or have
#'   the same length as groups, indicating whether to subset out mapped columns
#'   after each grouping. This will prevent mapping a column to two different
#'   groups.
#' @param data A `logical` vector indicating whether you would like the data
#'   for mapped columns to be returned instead of their column names. Defaults
#'   to `FALSE` for easy use assigning mapped columns to a `DataMapper` object.
#'
#' @return A `list`, where each item is named for the associated `groups` item
#' the guess is for. The character vector in each item are columns which are
#' uniquely identified by the identifiers from that group.
#'
#' @examples
#' guessMapping(exampleDataMapper, groups=list(rows='treatmentid', cols='sampleid'),
#' subset=FALSE)
#'
#' @md
#' @export
setMethod('guessMapping', signature(object='LongTableDataMapper'),
        function(object, groups, subset, data=FALSE) {
    funContext <- '[CoreGx::guessMapping,LongTableDataMapper-method]\n\t'

    # Extract the raw data
    mapData <- copy(rawdata(object))
    if (!is.data.table(mapData)) setDT(mapData)

    # Error handle for subset parameter
    if (!(length(subset) == length(groups) || length(subset) == 1))
        stop(.errorMsg(funContext, ' The subset parameter must be
            either length 1 or length equal to the groups parameter!'))

    if (length(subset) == 1) subset <- rep(subset, length(groups))

    # Get the id columns to prevent subsetting them out
    idCols <- unique(unlist(groups))

    # Map unique columns in the data to the metadata slot
    metadataColumns <- names(which(vapply(mapData, FUN=.length_unique,
        numeric(1)) == 1))
    metadataColumns <- setdiff(metadataColumns, idCols)
    metadata <- mapData[, .SD, .SDcols=metadataColumns]
    DT <- mapData[, .SD, .SDcols=!metadataColumns]

    # Check the mappings for each group in groups
    for (i in seq_along(groups)) {
        message(funContext, paste0('Mapping for group ', names(groups)[i],
            ': ', paste0(groups[[i]], collapse=', ')))
        mappedCols <- checkColumnCardinality(DT, groups[[i]])
        mappedCols <- setdiff(mappedCols, idCols)
        assign(names(groups)[i], DT[, .SD, .SDcols=mappedCols])
        if (subset[i]) DT <- DT[, .SD, .SDcols=!mappedCols]
    }

    # Merge the results
    groups <- c(list(metadata=NA), groups)
    mappings <- mget(names(groups))
    unmapped <- setdiff(colnames(mapData),
        unique(c(unlist(groups), unlist(lapply(mappings, colnames)))))
    if (!data) mappings <- lapply(mappings, colnames)
    mappings <- Map(f=list, groups, mappings)
    mappings <- lapply(mappings, FUN=setNames,
        nm=c('id_columns', 'mapped_columns'))

    mappings[['unmapped']] <- unmapped

    return(mappings)
})

#' Search a data.frame for 1:`cardinality` relationships between a group
#'   of columns (your identifiers) and all other columns.
#'
#' @param df A `data.frame` to search for 1:`cardinality` mappings with
#'   the columns in `group`.
#' @param group A `character` vector of one or more column names to
#'   check the cardinality of other columns against.
#' @param cardinality The cardinality of to search for (i.e., 1:`cardinality`)
#'   relationships with the combination of columns in group. Defaults to 1
#'   (i.e., 1:1 mappings).
#' @param ... Fall through arguments to data.table::`[`. For developer use.
#'   One use case is setting verbose=TRUE to diagnose slow data.table
#'   operations.
#'
#' @return A `character` vector with the names of the columns with
#'    cardinality of 1:`cardinality` with the columns listed in `group`.
#'
#' @examples
#' df <- rawdata(exampleDataMapper)
#' checkColumnCardinality(df, group='treatmentid')
#'
#' @aliases cardinality
#'
#' @md
#' @importFrom data.table setindexv
#' @importFrom MatrixGenerics colAlls
#' @export
checkColumnCardinality <- function(df, group, cardinality=1, ...) {

    funContext <- '\n[CoreGx::checkColumnCardinality]\n\t'

    # Copy to prevent accidental modify by references
    df <- copy(df)
    if (!is.data.table(df)) setDT(df)

    # Intercept slow data.table group by when nrow == .NGRP
    setkeyv(df, cols=group)
    nrowEqualsNGroup <- df[, .N, by=group, ...][, max(N), ...] == 1
    if (nrowEqualsNGroup) {
        if (cardinality != 1) stop(.errorMsg(funContext, 'The group argument
            uniquely identifies each row, so the cardinality is 1:1!'))
        columnsHaveCardinality <- setdiff(colnames(df), group)
    } else {
        dimDT <- df[, lapply(.SD, FUN=uniqueN), by=group, ...]
        columnsHaveCardinality <- colnames(dimDT)[colAlls(dimDT == cardinality)]
    }

    return(columnsHaveCardinality)
}
#' @export
cardinality <- checkColumnCardinality