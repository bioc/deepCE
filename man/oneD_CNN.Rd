% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/oneD_CNN.R
\name{oneD_CNN}
\alias{oneD_CNN}
\title{Predict Interactions using One-dimensional Convolutional Neural
Network (1D-CNN)}
\usage{
oneD_CNN(
  data,
  train_d,
  train_l,
  nlayers = 3,
  filters_1 = 64,
  filters_2 = 128,
  kernel_size = 3,
  strides = 1,
  pool_size = 2,
  drate = 0.1,
  powerto = 4,
  optimizer = "rmsprop",
  epochs = 50,
  b_size = 64,
  cv_fold = 5,
  plots = FALSE,
  filename = "plots.pdf"
)
}
\arguments{
\item{data}{A matrix containing concatenated co-elution profiles,
generated from \code{\link{getPPI}}.}

\item{train_d}{A matrix of training data containing numerical features,
generated from \code{\link{build_trainingData}}.}

\item{train_l}{A vector of binary categorical label (0-1),
generated from \code{\link{build_trainingData}}.}

\item{nlayers}{Number of hidden layers; defaults to 3.}

\item{filters_1}{Integer, the dimensionality of the output space
(i.e. the number of output filters in the first convolution).
Defaults to 64.}

\item{filters_2}{Integer, the dimensionality of the output space
(i.e. the number of output filters in the second convolution).
Defaults to 128.}

\item{kernel_size}{An integer or tuple/list of 2 integers, specifying the
height and width of the 2D convolution window. Can be a single integer to
specify the same value for all spatial dimensions.
Defaults to 3.}

\item{strides}{An integer or tuple/list of 2 integers, specifying the
strides of the convolution along the height and width. Can be a single
integer to specify the same value for all spatial dimensions.
Defaults to 1.}

\item{pool_size}{Down samples the input representation by taking the
maximum value over a spatial window of size pool_size.
Defaults to 2.}

\item{drate}{Numeric, the dropout rates. Defaults to 0.1.}

\item{powerto}{Integer, the number of neurons in the last layer
as defined by two to the power of this value.
Defaults to 4.}

\item{optimizer}{Name of optimizer.
For most models, this defaults to "rmsprop".}

\item{epochs}{Number of epochs to train the model. Defaults to 50.}

\item{b_size}{Number of samples per gradient update. Defaults to 64.}

\item{cv_fold}{Number of partitions for cross-validation; defaults to 5.}

\item{plots}{Logical value, indicating whether to plot the performance of
the learning algorithm using k-fold cross-validation; defaults to FALSE.
If the argument set to TRUE, plots will be saved in the temp() directory.
These plots are :
\itemize{ \item{pr_plot} - Precision-recall PLOT
\item{roc_plot} - ROC plot
\item{radar_plot} - Radar plot showing
accuracy, F1-score , positive predictive value (PPV), sensitivity (SE)
and MCC.}}

\item{filename}{character string, indicating the output filename
in the current directory as an pdf object. Defaults to plots.pdf.}
}
\value{
Predicted interactions with predicted scores.
}
\description{
This function uses one-dimensional convolutional Neural
network (1D-CNN) on densly-connected neural net to predict interactions
from co-elution data.
}
\details{
oneD_CNN
}
\author{
Matineh Rahmatbakhsh, \email{matinerb.94@gmail.com}
}
