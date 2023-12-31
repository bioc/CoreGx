% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CoreSet-class.R
\docType{class}
\name{CoreSet-class}
\alias{CoreSet-class}
\alias{.CoreSet}
\title{CoreSet - A generic data container for molecular profiles and
treatment response data}
\description{
CoreSet - A generic data container for molecular profiles and
treatment response data
}
\details{
The CoreSet (cSet) class was developed as a superclass for pSets in the
PharmacoGx and RadioGx packages to contain the data generated in screens
of cancer sample lines for their genetic profile and sensitivities to therapy
(Pharmacological or Radiation). This class is meant to be a superclass which
is contained within the PharmacoSet (pSet) and RadioSet (rSet) objects
exported by PharmacoGx and RadioGx. The format of the data is similar for
both pSets and rSets, allowing much of the code to be abstracted into
the CoreSet super-class. However, the models involved with quantifying
sampleular response to Pharmacological and Radiation therapy are widely
different, and extension of the cSet class allows the
packages to apply the correct model for the given data.
}
\section{Slots}{

\describe{
\item{\code{annotation}}{See Slots section.}

\item{\code{molecularProfiles}}{See Slots section.}

\item{\code{sample}}{See Slots section.}

\item{\code{treatment}}{See Slots section.}

\item{\code{treatmentResponse}}{See Slots section.}

\item{\code{perturbation}}{See Slots section.}

\item{\code{curation}}{See Slots section.}

\item{\code{datasetType}}{See Slots section.}
}}

\section{Slots}{

\itemize{
\item annotation: A \code{list} of annotation data about the \code{CoreSet},
including the \verb{$name} and the session information for how the object
was created, detailing the exact versions of R and all the packages used.
\item molecularProfiles: A \code{list} or \code{MultiAssayExperiment} containing
\code{CoreSet} object.
\item sample: A \code{data.frame} containg the annotations for all the samples
profiled in the data set, across all molecular data types and
treatment response experiments.
\item treatment: A \code{data.frame} containing the annotations for all treatments
in the dataset, including the mandatory 'treatmentid' column to uniquely
identify each treatment.
\item treatmentResponse: A \code{list} or \code{LongTable} containing all the data for the
treatment response experiment, including \verb{$info}, a \code{data.frame}
containing the experimental info, \verb{$raw} a 3D \code{array} containing raw data,
\verb{$profiles}, a \code{data.frame} containing sensitivity profiles
statistics, and \verb{$n}, a \code{data.frame} detailing the number of
experiments for each sample-drug/radiationInfo pair
\item perturbation: \code{list} containing \verb{$n}, a \code{data.frame}
summarizing the available perturbation data. This slot is currently
being deprecated.
\item curation: \code{list} containing mappings for \code{treatment},
\code{sample} and \code{tissue} names used in the data set to universal
identifiers used between different \code{CoreSet} objects.
\item datasetType: \code{character} string of 'sensitivity',
'perturbation', or both detailing what type of data can be found in the
\code{CoreSet}, for proper processing of the data
}
}

\seealso{
\code{\link{CoreSet-accessors}}
}
