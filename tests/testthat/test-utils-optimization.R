library(testthat)
testthat::local_edition(3)

# Create some dummy data
hillEqn <- function(x, Emin, Emax, EC50, lambda) {
    (Emin + Emax * (x / EC50)^lambda) / (1 + (x / EC50)^lambda)
}
# Set parameters for function testing
doses <- rev(1000 / (5^(1:10)))
lambda <- 0.6
Emin <- 1
Emax <- 0.5
EC50 <- median(doses)
# Helper to combine
fx <- if (is_optim_compatible(hillEqn)) hillEqn else
    make_optim_function(hillEqn, lambda=lambda, Emin=Emin)
response <- hillEqn(doses, Emin=Emin, lambda=lambda, Emax=Emax, EC50=EC50)
nresponse <- response + rnorm(length(response), sd=sd(response)*0.1)

# -- Loss function tests
lmsg <- c("LOSS FUNCTION: ")
testthat::test_that(paste0(lmsg, ".residual and .normal_loss produce equal results."), {
    trunc_vals <- c(FALSE, TRUE, FALSE, TRUE)
    nvals <- c(1, 1, 3, 3)
    for (i in seq_along(trunc_vals)) {
        n1 <- .residual(par=c(Emax=0.2, EC50=10), x=doses, y=nresponse, f=fx,
            family="normal", n=nvals[i], trunc=trunc_vals[i], scale=0.07)
        n2 <- CoreGx:::.normal_loss(par=c(Emax=0.2, EC50=10), x=doses, y=nresponse, fn=fx,
            n=nvals[i], trunc=trunc_vals[i], scale=0.07)
        testthat::expect_equal(n1, n2,
            info=paste0("trunc: ", trunc_vals[i], ", n: ", nvals[i])
        )
    }
})

testthat::test_that(paste0(lmsg, ".residual and .cauchy_loss produce equal results."), {
    trunc_vals <- c(FALSE, TRUE, FALSE, TRUE)
    nvals <- c(1, 1, 3, 3)
    for (i in seq_along(trunc_vals)) {
        c1 <- .residual(par=c(Emax=0.2, EC50=10), x=doses, y=nresponse, f=fx,
            family="Cauchy", n=nvals[i], trunc=trunc_vals[i], scale=0.07)
        c2 <- CoreGx:::.cauchy_loss(par=c(Emax=0.2, EC50=10), x=doses, y=nresponse, fn=fx,
            n=nvals[i], trunc=trunc_vals[i], scale=0.07)
        testthat::expect_equal(c1, c2,
            info=paste0("trunc: ", trunc_vals[i], ", n: ", nvals[i])
        )
    }
})

# -- Curve fitting
cmsg <- "CURVE FITTING: "
testthat::test_that(paste0(cmsg, ".fitCurve and .fitCurve2 produce equal results for 2-parameter Hill curve."), {
    par_list <- list(c(Emax=0.1, EC50=0.1), c(Emax=0.5, EC5O=500), c(Emax=0.9, EC50=100))
    for (i in seq_along(par_list)) {
        pars <- par_list[[i]]
        normal_par1 <- .fitCurve(
            gritty_guess=pars,
            x=doses,
            y=nresponse,
            f=fx,
            family="normal",
            trunc=FALSE,
            median_n=1,
            scale=0.07,
            upper_bound=c(2, max(doses)),
            lower_bound=c(0, min(doses)),
            density=c(2, 10),
            precision=1e-4,
            step=0.5 / c(2, 10)
        )
        normal_par2 <-.fitCurve2(
            par=pars,
            x=doses,
            y=nresponse,
            fn=hillEqn,
            loss=CoreGx:::.normal_loss,
            loss_args=list(trunc=FALSE, n=1, scale=0.07),
            Emin=Emin,
            lambda=lambda,
            upper=c(2, max(doses)),
            lower=c(0, min(doses)),
            density=c(2, 10),
            precision=1e-4,
            step=0.5 / c(2, 10)
        )
        testthat::expect_equal(normal_par1, normal_par2,
            info=paste0("Emax: ", pars[1], ", EC50: ", pars[2]))
        cauchy_par1 <- .fitCurve(
            gritty_guess=pars,
            x=doses,
            y=nresponse,
            f=fx,
            family="Cauchy",
            trunc=FALSE,
            median_n=1,
            scale=0.07,
            upper_bound=c(2, max(doses)),
            lower_bound=c(0, min(doses)),
            density=c(2, 10),
            precision=1e-4,
            step=0.5 / c(2, 10)
        )
        cauchy_par2 <-.fitCurve2(
            par=pars,
            x=doses,
            y=nresponse,
            fn=hillEqn,
            loss=CoreGx:::.cauchy_loss,
            loss_args=list(trunc=FALSE, n=1, scale=0.07),
            Emin=Emin,
            lambda=lambda,
            upper=c(2, max(doses)),
            lower=c(0, min(doses)),
            density=c(2, 10),
            precision=1e-4,
            step=0.5 / c(2, 10)
        )
        testthat::expect_equal(cauchy_par1, cauchy_par2,
            info=paste0("Emax: ", pars[1], ", EC50: ", pars[2]))
    }
})


testthat::test_that(
    paste0(cmsg, ".fitCurve and .fitCurve2 produce equal results for 3-parameter Hill curve."), {
    par_list <- list(
        c(Emax=0.1, EC50=0.1, lambda=1),
        c(Emax=0.5, EC5O=500, lambda=0.75),
        c(Emax=0.9, EC50=100, lambda=2)
    )
    fx <- make_optim_function(hillEqn, Emin=Emin)
    for (i in seq_along(par_list)) {
        pars <- par_list[[i]]
        normal_par1 <- .fitCurve(
            gritty_guess=pars,
            x=doses,
            y=nresponse,
            f=fx,
            family="normal",
            trunc=FALSE,
            median_n=1,
            scale=0.07,
            upper_bound=c(2, max(doses), 6),
            lower_bound=c(0, min(doses), 0),
            density=c(2, 10, 5),
            precision=1e-4,
            step=0.5 / c(2, 10, 5)
        )
        normal_par2 <-.fitCurve2(
            par=pars,
            x=doses,
            y=nresponse,
            fn=hillEqn,
            loss=CoreGx:::.normal_loss,
            loss_args=list(trunc=FALSE, n=1, scale=0.07),
            Emin=Emin,
            upper=c(2, max(doses), 6),
            lower=c(0, min(doses), 0),
            density=c(2, 10, 5),
            precision=1e-4,
            step=0.5 / c(2, 10, 5)
        )
        testthat::expect_equal(normal_par1, normal_par2,
            info=paste0("Emax: ", pars[1], ", EC50: ", pars[2]))
        cauchy_par1 <- .fitCurve(
            gritty_guess=pars,
            x=doses,
            y=nresponse,
            f=fx,
            family="Cauchy",
            trunc=FALSE,
            median_n=1,
            scale=0.07,
            upper_bound=c(2, max(doses), 6),
            lower_bound=c(0, min(doses), 0),
            density=c(2, 10, 5),
            precision=1e-4,
            step=0.5 / c(2, 10, 5)
        )
        cauchy_par2 <-.fitCurve2(
            par=pars,
            x=doses,
            y=nresponse,
            fn=hillEqn,
            loss=CoreGx:::.cauchy_loss,
            loss_args=list(trunc=FALSE, n=1, scale=0.07),
            Emin=Emin,
            upper=c(2, max(doses), 6),
            lower=c(0, min(doses), 0),
            density=c(2, 10, 5),
            precision=1e-4,
            step=0.5 / c(2, 10, 5)
        )
        testthat::expect_equal(cauchy_par1, cauchy_par2,
            info=paste0("Emax: ", pars[1], ", EC50: ", pars[2]))
    }
})