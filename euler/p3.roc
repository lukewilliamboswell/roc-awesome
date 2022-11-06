# Find the solution to Project Euler Problem 3

app "app-euler-3"
    packages { pf: "../cli-platform/main.roc" }
    imports [
        pf.Stdout, 
        pf.Program.{ Program },
    ]
    provides [main] to pf

main : Program
main = 
    n = 600851475143
    result = largestPrimeFact n 2 |> Num.toStr
    
    Stdout.line "The largest prime factor of 600851475143 is \(result)" 
        |> Program.quick

largestPrimeFact : U64, U64 -> U64
largestPrimeFact = \n, i ->
    if i*i > n then
        n
    else 
        if n%i == 0 then
            largestPrimeFact (n//i) i
        else
            largestPrimeFact n (i+1)  

expect largestPrimeFact 13195 2 == 29









