##
## Rosetta Code solution for the [Arithmetic](https://rosettacode.org/wiki/Arithmetic/Integer) task.
## Get two integers from the command line, and then (for those two integers), display their:
## - sum
## - difference
## - product
## - integer quotient
## - remainder
## - exponentiation
##
## Running this example with `roc run Arithmetic.roc -- 20 4` prints
## sum: 24
## difference: 16
## product: 80
## integer quotient: 5
## remainder: 0
## exponentiation: 160000
##
app "rosetta-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        pf.Arg,
        Str,
    ]
    provides [main] to pf

TaskErrors : [InvalidArg, InvalidNumStr]

main =
    task =
        args <- readArgs |> Task.await

        results = [
            ("sum", args.a + args.b),
            ("difference", args.a - args.b),
            ("product", args.a * args.b),
            ("integer quotient", args.a // args.b),
            ("remainder", args.a % args.b),
            ("exponentiation", Num.powInt args.a args.b),
        ]

        resultsStr =
            results
            |> List.map
                (\(operation, result) ->
                    resultStr = result |> Num.toStr
                    "\(operation): \(resultStr)")
            |> Str.joinWith "\n"

        Task.succeed resultsStr

    taskResult <- Task.attempt task

    when taskResult is
        Ok result -> Stdout.line result
        Err InvalidArg -> Stdout.line "Error: Please provide two integers between -1000 and 1000 as arguments."
        Err InvalidNumStr -> Stdout.line "Error: Invalid number format. Please provide integers between -1000 and 1000."

## Reads two command-line arguments, attempts to parse them as `I32` numbers,
## and returns a task containing a record with two fields, `a` and `b`, holding
## the parsed `I32` values.
##
## If the arguments are missing, if there's an issue with parsing the arguments
## as `I32` numbers, or if the parsed numbers are outside the expected range
## (-1000 to 1000), the function will return a task that fails with an
## error `InvalidArg` or `InvalidNumStr`.
readArgs : Task.Task { a : I32, b : I32 } TaskErrors
readArgs =
    Arg.list
    |> Task.mapFail \_ -> InvalidArg
    |> Task.await \args ->
        aResult = List.get args 1 |> Result.try Str.toI32
        bResult = List.get args 2 |> Result.try Str.toI32

        when (aResult, bResult) is
            (Ok a, Ok b) ->
                if a < -1000 || a > 1000 || b < -1000 || b > 1000 then
                    Task.fail InvalidNumStr
                else
                    Task.succeed { a, b }

            _ -> Task.fail InvalidNumStr
