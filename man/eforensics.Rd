% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ef_main.R
\name{eforensics}
\alias{eforensics}
\title{Election Forensics Finite Mixture Model}
\usage{
eforensics(formula1, formula2, formula3 = NULL, formula4 = NULL,
  formula5 = NULL, formula6 = NULL, data, elegible.voters = NULL,
  weights = NULL, mcmc, model, parameters = "all",
  na.action = "exclude", get.dic = 1000, parComp = T, autoConv = T,
  max.auto = 10)
}
\arguments{
\item{formula1}{an object of the class \code{formula} as used in \code{\link{lm}}. The dependent variable of this formula must the number (counts) or proportion of votes for the party or candidate that won the election. If counts are used, the model must be from the binomial family (see \code{model} parameter below). If proportions are provided, the model must be from the normal family (see \code{model} parameter below)}

\item{formula2}{an object of the class \code{formula} as used in \code{\link{lm}}. The dependent variable of this formula must the number (counts) or proportion of abstention.  The type (count or proportion) must be the same as the independent variable in \code{formula1}}

\item{formula3}{See description below}

\item{formula4}{See description below}

\item{formula5}{See description below}

\item{formula6}{See description below
\describe{
  \item{Formulas 3 to 6}{There are four other possible formulas to use: formula3, formula4, formula5, formula6}
  \item{formula3}{an object of the class \code{formula} as used in \code{\link{lm}}. The left-hand side (LHS) of the formula must be mu.iota.m (see example). The mu.iota.m is the probability of incremental fraud by manufacturing votes and it is a latent variable in the model. By specifying the LHS with that variable, the functional automatically identifies that formula as formula3. Default is \code{NULL} and it means that probability is not affected by election unit (ballot box, polling place, etc) covariate}
  \item{formula4}{an object of the class \code{formula} as used in \code{\link{lm}}. The left-hand side (LHS) of the formula must be mu.iota.s (see example). The mu.iota.s is the probability of incremental fraud by stealing votes from the opposition and it is a latent variable in the model. By specifying the LHS with that variable, the functional automatically identifies that formula as formula4. Default is \code{NULL} and it means that probability is not affected by election unit (ballot box, polling place, etc) covariate}
  \item{formula5}{an object of the class \code{formula} as used in \code{\link{lm}}. The left-hand side (LHS) of the formula must be mu.chi.m (see example). The mu.chi.m is the probability of extreme fraud by manufacturing votes and it is a latent variable in the model. By specifying the LHS with that variable, the functional automatically identifies that formula as formula5. Default is \code{NULL} and it means that probability is not affected by election unit (ballot box, polling place, etc) covariate}
  \item{formula6}{an object of the class \code{formula} as used in \code{\link{lm}}. The left-hand side (LHS) of the formula must be mu.chi.s (see example). The mu.chi.s is the probability of extreme fraud by stealing votes from the opposition and it is a latent variable in the model. By specifying the LHS with that variable, the functional automatically identifies that formula as formula6. Default is \code{NULL} and it means that probability is not affected by election unit (ballot box, polling place, etc) covariate}
}}

\item{data}{a dara.frame with the independent variables (voters for the winner and abstention) and the covariates. If the independent variables are counts, the it is necessary to provide the total number of elegible voters (see parameter \code{elegible.voters})}

\item{elegible.voters}{string with the name of the variable in the data that contains the number of elegible voters. Default is \code{NULL}, but it is required if the independent variables (voters for the winner and abstention) are counts}

\item{weights}{(not used)}

\item{mcmc}{a list containing \code{n.iter}, which is the number of iterations for the MCMC, \code{burn.in} for the burn-in period of the MCMC chain, \code{n.adapt} indicating the number of adaptative steps before the estimation (see \code{\link{rjags}})}

\item{model}{a string with the model ID to use in the estimation. Run \code{\link{ef_models()}} to see the list and descriptions of the models available.}

\item{parameters}{a string vector with the names of the parameters to monitor. When \code{NULL}, it will monitor all the parameters, except the Z's. When \code{parameters='all'} (default), it will monitor all parameters, including Z, which is necessary to classify the observations as fraudulent cases or not.}

\item{na.action}{(not used)}

\item{get.dic}{logical.  If get.dic is FALSE, no DIC is calculated.  If get.dic is an integer greater than 0, run model get.dic iterations to get the DIC.  If \code{parComp = TRUE}, then no DIC is calculated.}

\item{parComp}{Logical.  If parComp = TRUE, then chains are computed in parallel using the runjags architecture.  This opens n.chains instances of JAGS.  In practice, a max of 4 unique chains can be run due to the way in which JAGS generates initial values.}

\item{autoConv}{Logical.  If parComp = TRUE and autoConv = TRUE, the chains are run until convergence criteria are met.  Currently, chains are run for a single period equal to \code{burn.in} iterations and monitored for \code{n.iter} iterations.  If PSRF on the three values of pi are lower than 1.05, then the chain is stopped and the chain is run for \code{n.iter} more iterations monitoring all values specified by \code{parameters}.  If the PSRF for any value is higher than 1.05, then the chain is run for \code{burn.in} + \code{n.iter} more iterations and the PSRF is again checked.  This is repeated, at most, \code{max.auto} times.  If PSRF is not met by \code{max.auto} attempts, a warning message is printed and the chains are run \code{n.iter} more times with all parameters monitored.}

\item{max.auto}{Integer.  Number of subsequent tries to achieve a PSRF of 1.05 on pi.  After \code{max.auto} failures, a warning is thrown and the chain is run \code{n.iter} more times monitoring all specified parameters.}
}
\value{
The function returns a nested list. The first element of the list is a \code{mcmc} object with the samples from the posterior distribution. The second element of the list is a list of summaries (HPD, Mean, etc)
}
\description{
This function estimates a finite mixture model of election fraud
}
\examples{

model    = 'bl'

## simulate data
## -------------
sim_data = ef_simulateData(n=700, nCov=1, model=model)
data     = sim_data$data

## mcmc parameters
## ---------------
mcmc    = list(burn.in=1, n.adapt=10, n.iter=100, n.chains=2)

## samples
## -------
## help(eforensics)
devtools::document(pkg_folder)
samples    = eforensics(
    w ~ x1.w ,
    a ~ x1.a,
    mu.iota.m ~ x1.iota.m, 
    mu.iota.s ~ x1.iota.s,
    ## mu.chi.m  ~ x1.chi.m, 
    ## mu.chi.s  ~ x1.chi.s,
    data=data,
    elegible.voters="N",
    model=model, mcmc=mcmc, get.dic=0)

summary(samples)
summary(samples, join.chains=T)

}
