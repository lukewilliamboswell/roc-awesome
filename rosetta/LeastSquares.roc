##
## Rosetta Code solution for [Find Square Difference](https://rosettacode.org/wiki/Find_square_difference)
##
## Run this app with `roc run LeastSquares.roc` gives `The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is 501`
##
## Run unit tests with `roc test LeastSquares.roc`
##
app "rosetta-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

main =
    nStr = findNumber 1 |> Num.toStr

    Stdout.line "The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is \(nStr)"

## A recursive function that takes an `U32` as its input and returns the least
## positive integer number `n`, where the difference of `n*n` and `(n-1)*(n-1)`
## is greater than 1000.
##
## The input `n` should be a positive integer, and the function will return an
## `U32`representing the least positive integer that satisfies the condition.
##
findNumber : U32 -> U32
findNumber = \n ->
    difference = Num.sub (Num.powInt n 2) (Num.powInt (n - 1) 2)

    if difference > 1000 then
        n
    else
        findNumber (n + 1)

expect findNumber 1 == 501
