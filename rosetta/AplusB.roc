##
## Rosetta Code solution for [A+B](https://rosettacode.org/wiki/A%2BB)
##
## Given two integers, A and B. Their sum needs to be calculated.
##
## Running this examples with `roc run AplusB.roc -- 1 2` prints
## `The sum of 1.0 and 2.0 is 3.0` to stdio.
##
app "rosetta"
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

        sum = args.a + args.b
        aStr = args.a |> Num.toStr
        bStr = args.b |> Num.toStr
        sumStr = sum |> Num.toStr

        Task.succeed "The sum of \(aStr) and \(bStr) is \(sumStr)"

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