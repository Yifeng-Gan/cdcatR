% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gen.data.R
\name{gen.data}
\alias{gen.data}
\title{Data generation}
\usage{
gen.data(
  N = NULL,
  R = 1,
  item.bank = NULL,
  att.profiles = NULL,
  att.dist = "uniform",
  mvnorm.parm = list(mean = NULL, sigma = NULL, cutoffs = NULL),
  higher.order.parm = list(theta = NULL, lambda = NULL),
  categorical.parm = list(att.prior = NULL),
  seed = NULL
)
}
\arguments{
\item{N}{Scalar numeric. Sample size for the datasets}

\item{R}{Scalar numeric. Number of datasets replications. Default is 1}

\item{item.bank}{An object of class \code{gen.itembank}}

\item{att.profiles}{Numeric matrix indicating the true attribute profile for each examinee (\emph{N} examinees x \emph{K} attributes). If \code{NULL} (by default), \code{att.dist} must be specified}

\item{att.dist}{Numeric vector of length 2^\emph{K}, where \emph{K} is the number of attributes. Distribution for attribute simulation. It can be \code{"uniform"} (by default), \code{"higher.order"}, \code{"mvnorm"}, or \code{"categorical"}. See \code{simGDINA} function of package \code{GDINA} for more information. Only used when \code{att.profiles = NULL}}

\item{mvnorm.parm}{A list of arguments for multivariate normal attribute distribution (\code{att.dist = "mvnorm"}). See \code{simGDINA} function of package \code{GDINA} for more information}

\item{higher.order.parm}{A list of arguments for higher-order attribute distribution (\code{att.dist = "higher.order"}). See \code{simGDINA} function of package \code{GDINA} for more information}

\item{categorical.parm}{A list of arguments for categorical attribute distribution (\code{att.dist = "categorical"}). See \code{simGDINA} function of package \code{GDINA} for more information}

\item{seed}{Scalar numeric. A scalar to use with \code{set.seed}}
}
\value{
\code{gen.data} returns an object of class \code{gen.data}.
\describe{
\item{simdat}{An array containing the simulated responses (dimensions N examinees x J items x R replicates). If \code{R = 1}, a matrix is provided}
\item{simalpha}{An array containing the simulated attribute profiles (dimensions N examinees x K attributes x R replicates). If \code{R = 1}, a matrix is provided}
\item{specifications}{A list that contains all the specifications}
}
}
\description{
This function can be used to generate datasets based on an object of class \code{gen.itembank}.
The user can manipulate the examinees' attribute distribution or provide a matrix of attribute profiles.
Data are simulated using the \code{GDINA::simGDINA} function (Ma & de la Torre, 2020).
}
\examples{

####################################
# Example 1.                       #
# Generate dataset (GDINA item     #
# parameters and uniform attribute #
# distribution)                    #
####################################

Q <- sim180GDINA$simQ
bank <- gen.itembank(Q = Q, mean.IQ = .70, range.IQ = .20, model = "GDINA")

simdata <- gen.data(N = 1000, item.bank = bank)

####################################
# Example 2.                       #
# Generate multiple datasets (DINA #
# model and multivariate normal    #
# attribute distribution)          #
####################################

Q <- sim180GDINA$simQ
K <- ncol(Q)
bank <- gen.itembank(Q = Q, mean.IQ = .70, range.IQ = .20, model = "DINA")

cutoffs <- qnorm(c(1:K)/(K+1))
m <- rep(0,K)
vcov <- matrix(0.5,K,K)
diag(vcov) <- 1
simdata <- gen.data(N = 1000, R = 20, item.bank = bank, att.dist = "mvnorm",
                   mvnorm.parm = list(mean = m, sigma = vcov, cutoffs = cutoffs))

####################################
# Example 3.                       #
# Generate dataset (multiple       #
# models and higher-order          #
# attribute distribution)          #
####################################

Q <- sim180GDINA$simQ
K <- ncol(Q)
model <- sample(c("DINA", "DINO", "ACDM"), size = nrow(Q), replace = TRUE)
bank <- gen.itembank(Q = Q, mean.IQ = .70, range.IQ = .20, model = model)

N <- 1000
theta <- rnorm(N)
lambda <- data.frame(a = runif(K, 0.7, 1.3), b = seq( -2, 2, length.out = K))
simdata <- gen.data(N = N, item.bank = bank, att.dist = "higher.order",
                   higher.order.parm = list(theta = theta,lambda = lambda))

####################################
# Example 4.                       #
# Generate dataset (GDINA model    #
# and given attribute profiles)    #
####################################

Q <- sim180GDINA$simQ
K <- ncol(Q)
bank <- gen.itembank(Q = Q, mean.IQ = .70, range.IQ = .20, model = "GDINA")

att.profiles <- matrix(data = c(1,0,0,0,0,
                               1,1,0,0,0,
                               1,1,1,0,0,
                               1,1,1,1,1), ncol = K, byrow = TRUE)
simdata <- gen.data(item.bank = bank, att.profiles = att.profiles)

}
\references{
Ma, W. & de la Torre, J. (2020). GDINA: The generalized DINA model framework. R package version 2.7.9. Retrived from https://CRAN.R-project.org/package=GDINA
}
