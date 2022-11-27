# Find the solution to Project Euler Problem 4

app "app-euler-4"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [main] to pf

main : Task {} []
main =
    result = 
        largestPalindrome (List.range 100 999) 
        |> Result.map Num.toStr
        |> Result.withDefault "Error"
         
    Stdout.line "The largest palindrome is \(result)" 

expect List.range 1 4 == [1,2,3]
 
isPalindrome : U64 -> Bool
isPalindrome = \n ->
     scalarValues = Num.toStr n |> Str.toScalars
     
     List.reverse scalarValues == scalarValues
 
expect isPalindrome 10 == Bool.false
expect isPalindrome 101 == Bool.true
expect isPalindrome 220022 == Bool.true
expect List.keepIf [121,202,9008,9009,9010] isPalindrome == [121,202,9009]
 
product : List U64, List U64 -> List (List U64)
product = \x,y ->
    List.map x (\i -> List.map y (\j -> i*j ))

expect product [1,2,3] [4,5,6] == [[4,5,6],[8,10,12],[12,15,18]]
expect List.join (product [1,2] [3,4]) == [3,4,6,8] 

largestPalindrome : List U64 -> Result U64 [ListWasEmpty]
largestPalindrome = \range ->
    product range range
        |> List.join
        |> List.keepIf isPalindrome
        |> List.sortDesc
        |> List.first

expect largestPalindrome (List.range 1 12) == Ok 121
expect largestPalindrome (List.range 10 100) == Ok 9009

