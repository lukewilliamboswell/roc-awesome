##
## Find the sum of all the multiples of 3 or 5 below 1000.
##
## Roc solution for [Project Euler Problem 1](https://projecteuler.net/problem=1)
##
app "euler-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

main =
    answer =
        List.range { start: At 1, end: At 1000 }
        |> List.keepIf \x -> x % 3 == 0 || x % 5 == 0
        |> List.sum
        |> Num.toStr

    Stdout.line "The sum of all the multiples of 3 or 5 below 1000 is \(answer)."
