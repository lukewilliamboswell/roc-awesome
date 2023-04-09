##
## A palindromic number reads the same both ways. The largest palindrome made 
## from the product of two 2-digit numbers is 9009 = 91 × 99.
##
## Find the largest palindrome made from the product of two 3-digit numbers.
##
## Roc solution for [Project Euler Problem 4](https://projecteuler.net/problem=4)
##
app "euler-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

main =
    range = List.range {start: At 100, end: At 999}

    result = 
        largestPalindrome range
        |> Result.map Num.toStr

    when result is 
        Ok answer -> Stdout.line "The largest palindrome is \(answer)" 
        Err _ -> crash "oops, something went wrong"

## Determine if a given integer is a palindrome.
isPalindrome : U64 -> Bool
isPalindrome = \n ->
    scalarValues = Num.toStr n |> Str.toScalars
    
    List.reverse scalarValues == scalarValues
 
expect isPalindrome 10 == Bool.false
expect isPalindrome 101 == Bool.true
expect isPalindrome 220022 == Bool.true
expect List.keepIf [121,202,9008,9009,9010] isPalindrome == [121,202,9009]
 
## Returns a list of all possible products between elements of two input lists.
product : List U64, List U64 -> List (List U64)
product = \x,y ->
    if List.isEmpty x || List.isEmpty y then 
        []
    else 
        i <- List.map x 
        j <- List.map y

        i*j 

expect product [1,2] [3,4] == [[3,4],[6,8]]
expect product [] [1,2,3] == []
expect product [1,2,3] [] == []
expect product [] [] == []
expect product [1,2,3] [4,5,6] == [[4,5,6],[8,10,12],[12,15,18]]
expect List.join (product [1,2] [3,4]) == [3,4,6,8] 

## Find the largest palindrome that can be made by multiplying two numbers from a range.
largestPalindrome : List U64 -> Result U64 [ListWasEmpty]
largestPalindrome = \range ->
    product range range
        |> List.join
        |> List.keepIf isPalindrome
        |> List.sortDesc
        |> List.first  

expect largestPalindrome [10, 11, 12, 13] == Ok 121
expect largestPalindrome [] == Err ListWasEmpty
expect largestPalindrome [1, 2, 3, 4, 5, 6, 7, 8, 9] == Ok 9
expect largestPalindrome (List.range { start: At 1, end: At 12}) == Ok 121
expect largestPalindrome (List.range { start: At 10, end: At 100}) == Ok 9009

