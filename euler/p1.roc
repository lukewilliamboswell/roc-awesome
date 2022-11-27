# Find the solution to Project Euler Problem 1

app "app-euler-1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [main] to pf

main : Task {} []
main =  
    result = List.range 1 1000 |> sumMultiples
    
    Stdout.line "The sum of all the multiples of 3 or 5 below 1000 is \(result)." 

# Calculate the sume of a list of integers
sumMultiples : List U64 -> Str
sumMultiples = \nums ->
    nums
        |> List.keepIf isMultiple
        |> List.sum
        |> Num.toStr

expect sumMultiples (List.range 1 10) == "23"

# Pretty print a list of integers to a string
numsToStr : List U64 -> Str
numsToStr = \vals -> 
    vals 
        |> List.map Num.toStr
        |> Str.joinWith ", "

expect numsToStr [1,2,3] == "1, 2, 3"
expect numsToStr [] == ""

# Check if an integer is a multiple of 3 or 5
isMultiple : U64  -> Bool
isMultiple = \x -> x % 3 == 0 || x % 5 == 0

expect isMultiple 1 == Bool.false
expect isMultiple 6 == Bool.true
expect isMultiple 5 == Bool.true
expect isMultiple 10 == Bool.true
expect isMultiple 11 == Bool.false

