##
## Find the largest Lynch-Bell number (integer whose digits are all different,
## and is evenly divisible by each of its individual digits).
##
## Run this app with `roc run LynchBell.roc` to find the largest Lynch-Bell number.
##
app "rosetta"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        Num,
        Str,
    ]
    provides [main] to pf

main =
    lynchBellNumber = findLargestLynchBell 987654321
    answer = Num.toStr lynchBellNumber

    Stdout.line "The largest Lynch-Bell number is \(answer)"

## Find the largest Lynch-Bell number by iterating from the highest possible
## number with unique digits 987654321 down to 1.
findLargestLynchBell : U32 -> U32
findLargestLynchBell = \n ->
    if isLynchBell n then
        n
    else
        findLargestLynchBell (n - 1)

## Checks if a number is a Lynch-Bell number (i.e., its digits are all different,
## and it is evenly divisible by each of its individual digits).
isLynchBell : U32 -> Bool
isLynchBell = \n ->
    traverseDigits n n (Set.empty {})

# traverseDigits : U32, U32, Set U32 -> Bool
# traverseDigits = \originalN, remainingN, visitedDigits ->
#     if remainingN == 0 then
#         Bool.true
#     else
#         digit = Num.rem remainingN 10
#         newRemainingN = Num.divTrunc remainingN 10

#         if digit == 0 || Set.contains visitedDigits digit || Num.rem originalN digit != 0 then
#             Bool.false
#         else
#             traverseDigits originalN newRemainingN (Set.insert visitedDigits digit)

# Should PASS
expect isLynchBell 1 == Bool.true
expect isLynchBell 2 == Bool.true
expect isLynchBell 3 == Bool.true
expect isLynchBell 12 == Bool.true
expect isLynchBell 15 == Bool.true
expect isLynchBell 24 == Bool.true
expect isLynchBell 135 == Bool.true
expect isLynchBell 384 == Bool.true

# Should FAIL
expect isLynchBell 120 == Bool.false

## A helper function for `isLynchBell` that recursively traverses the digits of a number
## and checks if the number satisfies the Lynch-Bell conditions.
##
## The function takes three arguments:
## - `originalN`: The original number being tested for Lynch-Bell conditions.
## - `remainingN`: The remaining part of the number that has not yet been processed.
## - `visitedDigits`: A set of digits that have already been visited and processed.
##
## The function returns `Bool.true` if the number satisfies the Lynch-Bell conditions, 
## and `Bool.false` otherwise.
##
traverseDigits : U32, U32, Set U32 -> Bool
traverseDigits = \originalN, remainingN, visitedDigits ->
    if remainingN == 0 then
        Bool.true
    else
        digit = Num.rem remainingN 10
        newRemainingN = Num.divTrunc remainingN 10

        if digit == 0 || Set.contains visitedDigits digit || Num.rem originalN digit != 0 then
            Bool.false
        else
            traverseDigits originalN newRemainingN (Set.insert visitedDigits digit)

## Unit tests for `traverseDigits` function
expect (traverseDigits 128 128 (Set.empty {})) == Bool.true
expect (traverseDigits 135 135 (Set.empty {})) == Bool.true
expect (traverseDigits 136 136 (Set.empty {})) == Bool.false
expect (traverseDigits 102 102 (Set.empty {})) == Bool.false
expect (traverseDigits 123456789 123456789 (Set.empty {})) == Bool.false
