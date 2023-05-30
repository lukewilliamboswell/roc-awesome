##
## Rosetta Code solution for [FizzBuzz](https://rosettacode.org/wiki/FizzBuzz).
##
## Print the integers from 1 to 100, replacing:
## - multiples of three with "Fizz",
## - multiples of five with "Buzz",
## - multiples of both three and five with "FizzBuzz".
##
## Run this app with `roc run FizzBuzz.roc` to print the FizzBuzz sequence, or
## run unit tests with `roc test FizzBuzz.roc`.
##
app "rosetta"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        Str,
    ]
    provides [main] to pf

main =
    List.range { start: At 1, end: At 100 }
    |> List.map fizzBuzz
    |> Str.joinWith "\n"
    |> Stdout.line

## Determine the FizzBuzz value for a given integer. Returns "Fizz" for multiples
## of 3, "Buzz" for multiples of 5, "FizzBuzz" for multiples of both 3 and 5,
## and the original number as a string for all other values.
fizzBuzz : I32 -> Str
fizzBuzz = \n ->
    fizz = Num.rem n 3 == 0
    buzz = Num.rem n 5 == 0

    if fizz && buzz then
        "FizzBuzz"
    else if fizz && !buzz then
        "Fizz"
    else if !fizz && buzz then
        "Buzz"
    else
        Num.toStr n

## Test Case 1: not a multiple of 3 or 5
expect fizzBuzz 1 == "1"
expect fizzBuzz 7 == "7"

## Test Case 2: multiple of 3
expect fizzBuzz 3 == "Fizz"
expect fizzBuzz 9 == "Fizz"

## Test Case 3: multiple of 5
expect fizzBuzz 5 == "Buzz"
expect fizzBuzz 20 == "Buzz"

## Test Case 4: multiple of both 3 and 5
expect fizzBuzz 15 == "FizzBuzz"
expect fizzBuzz 45 == "FizzBuzz"
