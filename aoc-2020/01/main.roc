# Run this with `roc dev aoc-2020/01.roc -- aoc-2020/input/01.txt`
app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.1.0/xbO9bXdHi7E9ja6upN5EJXpDoYm7lwmJ8VzL7a5zhYE.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.File,
        pf.Path,
        pf.Task,
        pf.Arg,
        json.Core.{json},
        "./input.txt" as fileBytes : List U8,
    ]
    provides [main] to pf

TaskErrors : [InvalidArg, InvalidFile Str]

main =
    task =
        # path <- readPath |> Task.await
        # fileBytes <- readFile path |> Task.await

        [
            part1 "Part 1 Sample" sampleBytes,
            part1 "Part 1 File" fileBytes,
            part2 "Part 2 Sample" sampleBytes,
            part2 "Part 2 File" fileBytes,
        ]
        |> List.keepOks \x -> x
        |> Str.joinWith "\n"
        |> Task.succeed

    taskResult <- Task.attempt task

    when taskResult is
        Ok answers -> Stdout.line answers
        Err InvalidArg -> Stderr.line "Error: expected arg file.roc -- path/to/input.txt"
        Err (InvalidFile path) -> Stderr.line "Error: couldn't read input file at \"\(path)\""

part1 = \source, input ->
    { numbers, rest } = parseNumbers { numbers: [], rest: input }

    expect List.isEmpty rest

    combined =
        x <- numbers |> List.joinMap
        y <- numbers |> List.map

        { x, y, sum: x + y, mul: x * y }

    when combined |> List.keepIf \c -> c.sum == 2020 is
        [first, ..] ->
            xStr = first.x |> Num.toStr
            yStr = first.y |> Num.toStr
            mulStr = first.mul |> Num.toStr

            Ok "\(source): \(xStr) * \(yStr) = \(mulStr)"

        _ ->
            Err "expected at least one pair to have sum of 2020"

part2 = \source, input ->
    { numbers, rest } = parseNumbers { numbers: [], rest: input }

    expect List.isEmpty rest

    combined =
        x <- numbers |> List.joinMap
        y <- numbers |> List.joinMap
        z <- numbers |> List.map

        { x, y, z, sum: x + y + z, mul: x * y * z }

    when combined |> List.keepIf \c -> c.sum == 2020 is
        [first, ..] ->
            xStr = first.x |> Num.toStr
            yStr = first.y |> Num.toStr
            zStr = first.z |> Num.toStr
            mulStr = first.mul |> Num.toStr

            Ok "\(source): \(xStr) * \(yStr) * \(zStr) = \(mulStr)"

        _ ->
            Err "expected at least one triple to have sum of 2020"

parseNumbers = \{ numbers, rest } ->
    if List.isEmpty rest then
        { numbers, rest }
    else
        decodeResult : Decode.DecodeResult U64
        decodeResult = Decode.fromBytesPartial rest json

        when decodeResult.result is
            Ok n -> parseNumbers { numbers: List.append numbers n, rest: decodeResult.rest }
            Err _ -> parseNumbers { numbers, rest: List.dropFirst rest }

sampleBytes =
    """
    1721
    979
    366
    299
    675
    1456
    """
    |> Str.toUtf8

readPath : Task.Task Str TaskErrors
readPath =
    # Read command line arguments
    Arg.list
    |> Task.mapFail \_ -> InvalidArg
    |> Task.await \args ->
        # Get the second argument, note first is the executable
        List.get args 1
        |> Result.mapErr \_ -> InvalidArg
        |> Task.fromResult

readFile : Str -> Task.Task (List U8) TaskErrors
readFile = \path ->
    # Read input file at the given path
    Path.fromStr path
    |> File.readBytes
    |> Task.mapFail \_ -> InvalidFile path
