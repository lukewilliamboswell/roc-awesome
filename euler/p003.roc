##
## The prime factors of 13195 are 5, 7, 13 and 29.
##
## What is the largest prime factor of the number 600851475143 ?
## 
## Roc solution for [Project Euler Problem 3](https://projecteuler.net/problem=3)
##
app "euler-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

main = 
    n = 600851475143
    answer = largestPrimeFact n 2 |> Num.toStr

    Stdout.line "The largest prime factor of 600851475143 is \(answer)" 

## A recursive function that finds the largest prime factor of a positive 
## integer `n`.
largestPrimeFact : U64, U64 -> U64
largestPrimeFact = \n, i ->
    if i*i > n then
        n
    else if n%i == 0 then
        largestPrimeFact (n//i) i
    else
        largestPrimeFact n (i+1)

expect largestPrimeFact 13195 2 == 29
expect largestPrimeFact 600851475143 2 == 6857
expect largestPrimeFact 1234567890123 2 == 116216501
