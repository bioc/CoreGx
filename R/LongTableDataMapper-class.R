#' @include DataMapper-class.R
NULL

#' A Class for Mapping Between Raw Data and an `LongTable` Object
#'
#' @slot rowDataMap See Slots section.
#' @slot colDataMap See Slots section.
#' @slot assayMap See Slots section.
#' @slot metadataMap See Slots section.
#'
#' @inheritSection DataMapper-class Slots
#'
#' @section Slots:
#' * rowDataMap: A list-like object containing two `character` vectors. 
#' The first is column names in `rawdata` needed to uniquely identify each row, 
#' the second is additional columns which map to rows, but are not required to
#' uniquely identify them. Rows should be drugs.
#' * colDataMap: A list-like object containing two `character` vectors. 
#' The first is column names in `rawdata` needed to uniquely identify each 
#' column, the second is additional columns which map to rows, but are not 
#' required to uniquely identify them. Columns should be samples.
#' * assayMap: A list-like where each item is a `character` vector of
#' `rawdata` column names to assign to an assay, where the name of that assay 
#' is the name of the list item. If names are omitted, assays will be numbered 
#' by their index in the list.
#' * metadataMap: A list-like where each item is a `character` vector of
#' `rawdata` column names to assign to the `@metadata` of the `LongTable`, 
#' where the name of that assay is the name of the list item. If names are 
#' omitted, assays will be numbered by their index in the list.
#'
#' @md
#' @aliases LongTableDataMapper-class
.LongTableDataMapper <- setClass('LongTableDataMapper', 
    contains=c('DataMapper'),
    slots=list(
        rowDataMap='list_or_List',
        colDataMap='list_or_List',
        assayMap='list_or_List',
        metadataMap='list_or_List'
    ))

#' Constructor for the `LongTableDataMapper` class, which maps from one or
#'   more raw experimental data files to the slots of a `LongTable` object.
#' 
#' @details
#' The `guessMapping` method can be used to test hypotheses about the 
#' cardinality of one or more sets of identifier columns. This is helpful
#' to determine the id columns for `rowDataMap` and `colDataMap`, as well
#' as identify columns mapping to `assays` or `metadata`.
#' 
#' To attach metadata not associated with `rawdata`, please use the `metadata`
#' assignment method on your `LongTableDataMapper`. This metadata will be 
#' merge with any metadata from `metadataMap` and added to the `LongTable`
#' which this object ultimately constructs.
#'
#' @param rawdata A `data.frame` of raw data from a treatment response 
#' experiment. This will be coerced to a `data.table` internally. We recommend
#' using joins to aggregate your raw data if it is not present in a single file.
#' @param rowDataMap A list-like object containing two `character` vectors. 
#' The first is column names in `rawdata` needed to uniquely identify each row, 
#' the second is additional columns which map to rows, but are not required to
#' uniquely identify them. Rows should be drugs.
#' @param colDataMap A list-like object containing two `character` vectors. 
#' The first is column names in `rawdata` needed to uniquely identify each 
#' column, the second is additional columns which map to rows, but are not 
#' required to uniquely identify them. Columns should be samples.
#' @param assayMap A list-like where each item is a `character` vector of
#' `rawdata` column names to assign to an assay, where the name of that assay 
#' is the name of the list item. If names are omitted, assays will be numbered 
#' by their index in the list
#' @param metadataMap A list-like where each item is a `character` vector of
#' `rawdata` column names to assign to the `@metadata` of the `LongTable`, 
#' where the name of that assay is the name of the list item. If names are 
#' omitted, assays will be numbered by their index in the list.
#'
#' @return A `LongTable` object, with columns mapped to it's slots according
#' to the various maps in the `LongTableDataMapper` object.
#'
#' @seealso [`guessMapping`]
#'
#' @md
#' @importFrom data.table setDT
#' @export
LongTableDataMapper <- function(rawdata, rowDataMap=list(), 
    colDataMap=list(), assayMap=list(), metadataMap=list())
{
    funContext <- '[CoreGx::LongTableDataMapper]\n\t'
    if (missing(rawdata)) stop(.errorMsg(funContext, 'The rawdata parameter ',
        'is mandatory. Please provide a list of raw data to map from.'))
    
    if (is(rawdata, 'data.frame') && !is(rawdata, 'data.table')) setDT(rawdata)

    .LongTableDataMapper(rawdata=rawdata, rowDataMap=rowDataMap, 
        colDataMap=colDataMap, assayMap=assayMap, metadataMap=metadataMap)
}


## ===========================================
## LongTableDataMapper Accessors Documentation
## -------------------------------------------

.local_class_3 <- 'LongTableDataMapper'
.local_data_3 <- 'exampleDataMapper'

#' @name LongTableDataMapper-accessors
#'
#' @eval .docs_DataMapper_accessors(class_=.local_class_3)
#' @eval .docs_DataMapper_get_rawdata(class_=.local_class_3)
#' 
#' @param value See details. 
NULL

## =====================================
## LongTableDataMapper Accessors Methods
## -------------------------------------


## --------------------
## ---- rowDataMap slot


##
## -- rowDataMap

.docs_LongTableDataMapper_get_dimDataMap <- function(...) .parseToRoxygen(
    "
    @details
    __{dim_}DataMap__: `list` of two `character` vectors, the first are the 
    columns required to uniquely identify each row of a `{class_}` and the 
    second any additional {dim_}-level metadata. If the character vectors
    have names, the resulting columns are automatically renamed to the
    item name of the specified column.

    @examples
    {dim_}DataMap({data_})

    @md
    @aliases {dim_}DataMap,{class_}-method {dim_}DataMap
    @exportMethod {dim_}DataMap
    ",
    ...
)

#' @export
setGeneric('rowDataMap', function(object, ...) standardGeneric('rowDataMap'))

#' @rdname LongTableDataMapper-accessors
#' @eval 
#' .docs_LongTableDataMapper_get_dimDataMap(dim_='row', class_=.local_class_3, 
#' data_=.local_data_3)
setMethod('rowDataMap', signature(object='LongTableDataMapper'), function(object) 
{
    object@rowDataMap
})

#' @export
setGeneric('rowDataMap<-', function(object, ..., value) standardGeneric('rowDataMap<-'))

.docs_LongTableDataMapper_set_dimDataMap <- function(...) .parseToRoxygen(
    "
    @details
    __{dim_}DataMap<-__: Update the `@{dim_}DataMap` slot of a `{class_}` object,
    returning an invisible NULL. Arguments:
    - value: A `list` or `List` where the first item is the names of the
    identifier columns -- columns needed to uniquely identify each row in
    {dim_}Data -- and the second item is the metadata associated with those
    the identifier columns, but not required to uniquely identify rows in
    the object rowData.

    @examples
    {dim_}DataMap({data_}) <- list(c('{id_col_}'), c())

    @md
    @aliases rowDataMap<-,{class_},list-method {dim_}DataMap<-{class_},List-method {dim_}DataMap<-
    @exportMethod {dim_}DataMap<-
    ",
    ...
)


#' @rdname LongTableDataMapper-accessors
#' @eval
#' .docs_LongTableDataMapper_set_dimDataMap(dim_='row', class_=.local_class_3, 
#' data_=.local_data_3, id_col_='drug_id')
setReplaceMethod('rowDataMap', signature(object='LongTableDataMapper', 
    value='list_or_List'), function(object, value) 
{
    funContext <- '[CoreGx::`rowDataMap<-`,LongTableDataMapper-method]\n\t'
    rawdataCols <- colnames(rawdata(object))

    # -- Handle error conditions
    if (length(value) > 2) {
        stop(.errorMsg(funContext, 'Assignments to rowDataMap should be a list ',
            'of length 2, where the first item is the name of the id columns ',
            'and the second item is the name of the metadata columns which ',
            'map to those id columns.'))
    }

    hasIDcols <- value[[1]] %in% rawdataCols
    if (!all(hasIDcols)) {
        stop(.errorMsg(funContext, 'One or more of the id columns specified ',
            'in value[[1]] are not valid column names in the rawdata slot of ',
            'this ', class(object)[1], ' object!'))
    }
    
    if (length(value) > 1 && length(value[[2]]) != 0) {
        hasMetaCols <- value[[2]] %in% rawdataCols
        if (!all(hasMetaCols)) {
            stop(.errorMsg(funContext, 'The follow metadata columns in value[[2]] ',
                'are not present in rawdata(object): ', 
                .collapse(value[[2]][!hasMetaCols]), '!'))
        }
        hasOneToOneRelationship <- 
            value[[2]] %in% cardinality(rawdata(object), group=value[[1]])
        if (!all(hasOneToOneRelationship)) {
            stop(.errorMsg(funContext, 'The columns ', 
                .collapse(value[[2]][!hasOneToOneRelationship], ' do not have a ',
                '1:1 relationship with the specified ID columns!')))
        }
    }

    # -- Function body
    object@rowDataMap <- value
    return(object)
})

## --------------------
## ---- colDataMap slot

##
## -- colDataMap

#' @export
setGeneric('colDataMap', function(object, ...) standardGeneric('colDataMap'))

#' @rdname LongTableDataMapper-accessors
#' @eval 
#' .docs_LongTableDataMapper_get_dimDataMap(dim_='col', class_=.local_class_3, 
#' data_=.local_data_3)
setMethod('colDataMap', signature(object='LongTableDataMapper'), function(object) 
{
    object@colDataMap
})

#' @export
setGeneric('colDataMap<-', function(object, ..., value) standardGeneric('colDataMap<-'))

#' @rdname LongTableDataMapper-accessors
#' @eval 
#' .docs_LongTableDataMapper_set_dimDataMap(dim_='col', class_=.local_class_3, 
#' data_=.local_data_3, id_col_='cell_id')
setReplaceMethod('colDataMap', signature(object='LongTableDataMapper',
    value='list_or_List'), function(object, value) 
{
    funContext <- '[CoreGx::`colDataMap<-`,LongTableDataMapper-method]\n\t'
    rawdataCols <- colnames(rawdata(object))

    # -- Handle error conditions
    if (length(value) > 2 || !is.list(value)) {
        stop(.errorMsg(funContext, 'Assignments to colDataMap should be a list ',
            'of length 2, where the first item is the name of the id columns ',
            'and the second item is the name of the metadata columns which ',
            'map to those id columns.'))
    }

    hasIDcols <- value[[1]] %in% rawdataCols
    if (!all(hasIDcols)) {
        stop(.errorMsg(funContext, 'One or more of the id columns specified ',
            'in value[[1]] are not valid column names in the rawdata slot of ',
            'this ', class(object)[1], ' object!'))
    }
    
    if (length(value) > 1 && length(value[[2]]) != 0) {
        hasMetaCols <- value[[2]] %in% rawdataCols
        if (!all(hasMetaCols)) {
            stop(.errorMsg(funContext, 'The follow metadata columns in value[[2]] ',
                'are not present in rawdata(object): ', 
                .collapse(value[[2]][!hasMetaCols]), '!'))
        }
        hasOneToOneRelationship <- 
            value[[2]] %in% cardinality(rawdata(object), group=value[[1]])
        if (!all(hasOneToOneRelationship)) {
            stop(.errorMsg(funContext, 'The columns ', 
                .collapse(value[[2]][!hasOneToOneRelationship], ' do not have a ',
                '1:1 relationship with the specified ID columns!')))
        }
    }

    # -- Function body
    object@colDataMap <- value
    return(object)
})

## ----------------
## ---- assayMap slot


#' @export
setGeneric('assayMap', function(object, ...) standardGeneric('assayMap'))

.docs_LongTableDataMapper_get_assayMap <- function(...) .parseToRoxygen(
    "
    @details
    __assayMap__:  A `list` of character vectors. The name of each list item 
    will be the assay in a `LongTableDataMapper` object that the columns in the 
    `character` vector will be assigned to. Column renaming occurs automatically
    when the character vectors have names (from the value to the name).

    @examples
    assayMap({data_})

    @md
    @aliases assayMap,{class_},list-method assayMap,{class_},List-method 
    assayMap
    @exportMethod assayMap
    ",
    ...
)

#' @rdname LongTableDataMapper-accessors
#' @eval .docs_LongTableDataMapper_get_assayMap(class_=.local_class_3, data_=.local_data_3)
setMethod('assayMap', signature(object='LongTableDataMapper'), function(object) 
{
    object@assayMap
})


#' @export
setGeneric('assayMap<-', function(object, ..., value) standardGeneric('assayMap<-'))

#' @noRd
.docs_LongTableDataMapper_set_assayMap <- function(...) .parseToRoxygen(
    "
    @details
    __assayMap<-__: Updates the `@assaMap` slot of a `{class_}` object,
    returning an invisible NULL. Arguments:
    - value:  A `list` of character vectors, where the name of each list
    item is the name of an assay and the values of each character vector
    specify the columns mapping to the assay in the `S4` object the 
    `{class_}` constructs.

    @examples
    assayMap({data_}) <- list(sensitivity=c(viability1='vaibility'))

    @md
    @aliases assayMap<-,{class_},list-method assayMap<-,{class_},List-methhod
    assayMap<-
    @exportMethod assayMap<-
    ",
    ...
)

#' @rdname LongTableDataMapper-accessors
#' @eval .docs_LongTableDataMapper_set_assayMap(class_=.local_class_3, data_=.local_data_3)
setReplaceMethod('assayMap', signature(object='LongTableDataMapper', 
    value='list_or_List'), function(object, value) 
{
    funContext <- '[CoreGx::`assayMap<-,LongTableDataMapper-method`]\n\t'
    rawdataCols <- colnames(rawdata(object))
    if (length(names(value)) == 0) stop(.errorMsg('The value argument must
        be a named list-like of column name character vectors!'))

    for (i in seq_along(value)) {
        hasRawdataCols <- value[[i]] %in% rawdataCols
        if (!all(hasRawdataCols)) {
            stop(.errorMsg(funContext, 'There are no columns named ',
                .collapse(value[[i]][!hasRawdataCols]), ' in the rawdata ',
                'of this ', class(object)[1], ' object. Please ensure item ',
                names(value)[i], ' of value has valid column names.'))
        }
    }

    object@assayMap <- value
    return(object)
})

# -- metadataMap


#' @export
setGeneric('metadataMap', function(object, ...) standardGeneric('metadataMap'))

#' @noRd
.docs_LongTableDataMapper_get_metadataMap <- function(...) .parseToRoxygen(
    "
    @details
    __metadataMap__:  A `list` of `character` vectors. Each item is an element 
    of the constructed objects `@metadata` slot.

    @examples
    metadataMap({data_})

    @md
    @aliases metadataMap,{class_}-method metadataMap
    @exportMethod metadataMap
    ",
    ...
)

#' @rdname LongTableDataMapper-accessors
#' @eval .docs_LongTableDataMapper_get_metadataMap(class_=.local_class_3, data_=.local_data_3)
setMethod('metadataMap', signature(object='LongTableDataMapper'), function(object) 
{
    object@metadataMap
})


#' @export
setGeneric('metadataMap<-', function(object, ..., value) 
    standardGeneric('metadataMap<-'))

#' @noRd
.docs_LongTableDataMapper_set_metadataMap <- function(...) .parseToRoxygen(
    "
    @details
    __metadataMap<-__: Updates `{class_}` object in-place, then returns an 
    `invisible(NULL)`. Arguments:
    - value:  A `list` of `character` vectors. The name of each list item
    is the name of the item in the `@metadata` slot of the `{class_}` object 
    created when `metaConstruct` is called on the `DataMapper`, and a 
    character vector specifies the columns of `@rawdata` to assign to each item.

    @examples
    metadataMap({data_}) <- list(object_metadata=c('metadata'))

    @md
    @aliases metadataMap<-,{class_}-method metadataMap<-
    @exportMethod metadataMap<-
    ",
    ...
)

#' @rdname LongTableDataMapper-accessors
#' @eval .docs_LongTableDataMapper_set_metadataMap(class_=.local_class_3, data_=.local_data_3, col_='metadata')
setReplaceMethod('metadataMap', signature(object='LongTableDataMapper', 
    value='list_or_List'), function(object, value) 
{
    funContext <- '[CoreGx::`metadataMap<-,LongTableDataMapper-method`]\n\t'
    rawdataCols <- colnames(rawdata(object))
    if (length(names(value)) == 0) stop(.errorMsg('The value argument must
        be a named list-like of column name character vectors!'))

    for (i in seq_along(value)) {
        hasRawdataCols <- value[[i]] %in% rawdataCols
        if (!all(hasRawdataCols)) {
            stop(.errorMsg(funContext, 'There are no columns named ',
                .collapse(value[[i]][!hasRawdataCols]), ' in the rawdata ',
                'of this ', class(object)[1], ' object. Please ensure item ',
                names(value)[i], ' of value has valid column names.'))
        }
    }

    object@metadataMap <- value
    return(object)
})