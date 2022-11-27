# Find the solution to Project Euler Problem 3

app "app-euler-3"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [main] to pf

main : Task {} []
main = 
    n = 600851475143
    result = largestPrimeFact n 2 |> Num.toStr
    Stdout.line "The largest prime factor of 600851475143 is \(result)" 

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









