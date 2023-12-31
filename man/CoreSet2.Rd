% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CoreSet-class.R
\name{CoreSet2}
\alias{CoreSet2}
\title{Make a CoreSet with the updated class structure}
\usage{
CoreSet2(
  name = "emptySet",
  treatment = data.frame(),
  sample = data.frame(),
  molecularProfiles = MultiAssayExperiment(),
  treatmentResponse = LongTable(),
  datasetType = "sensitivity",
  perturbation = list(n = array(dim = 3), info = "No perturbation data!"),
  curation = list(sample = data.frame(), treatment = data.frame())
)
}
\arguments{
\item{name}{A \code{character(1)} vector with the \code{CoreSet} objects name.}

\item{treatment}{A \code{data.frame} with treatment level metadata.}

\item{sample}{A \code{data.frame} with sample level metadata for the union
of samples in \code{treatmentResponse} and \code{molecularProfiles}.}

\item{molecularProfiles}{A \code{MultiAssayExperiment} containing one
\code{SummarizedExperiment} object for each molecular data type.}

\item{treatmentResponse}{A \code{LongTable} or \code{LongTableDataMapper} object
containing all treatment response data associated with the \code{CoreSet}
object.}

\item{datasetType}{A deprecated slot in a \code{CoreSet} object included
for backwards compatibility. This may be removed in future releases.}

\item{perturbation}{A deprecated slot in a \code{CoreSet} object included
for backwards compatibility. This may be removed in future releases.}

\item{curation}{A \code{list(2)} object with two items named \code{treatment} and \code{sample} with
mappings from publication identifiers to standardized identifiers for
both annotations, respectively.}
}
\value{
A \code{CoreSet} object storing standardized and curated treatment
response and multiomic profile data associated with a given publication.
}
\description{
New implementation of the CoreSet constructor to support MAE and TRE. This
constructor will be swapped with the original \code{CoreSet} constructor as
part of an overhaul of the CoreSet class structure.
}
\examples{
data(clevelandSmall_cSet)
clevelandSmall_cSet

}
