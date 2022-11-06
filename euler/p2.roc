# Find the solution to Project Euler Problem 2

app "app-euler-2"
    packages { pf: "../cli-platform/main.roc" }
    imports [
        pf.Stdout,
        pf.Program.{ Program },
    ]
    provides [main] to pf

main : Program
main =
    limit = 4000000
    result = fibs limit 0 1 0 |> Num.toStr
    
    Stdout.line "The sum of even Fibonacci valus less then four million is \(result)." 
        |> Program.quick

fibs : U64, U64, U64, U64 -> U64
fibs = \limit, previous, current, sum ->
    isDone = current >= limit
    isEven = Num.isEven current

    if isDone then
        sum
    else 
        if isEven then
            fibs limit current (current+previous) (sum + current)
        else
            fibs limit current (current+previous) sum

expect fibs 5 1 2 0 == 2
expect fibs 10 1 2 0 == 10
expect fibs 50 1 2 0 == 44 
expect fibs 188 1 2 0 == 188

