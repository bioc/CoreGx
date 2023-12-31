% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LongTable-utils.R
\name{$,LongTable-method}
\alias{$,LongTable-method}
\title{Select an assay from a LongTable object}
\usage{
\S4method{$}{LongTable}(x, name)
}
\arguments{
\item{x}{A \code{LongTable} object to retrieve an assay from}

\item{name}{\code{character} The name of the assay to get.}
}
\value{
\code{data.frame} The assay object.
}
\description{
Select an assay from a LongTable object
}
\examples{
merckLongTable$sensitivity

}
