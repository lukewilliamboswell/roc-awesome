# Run this with `roc dev aoc-2020/01.roc -- aoc-2020/input/01.txt`
app "aoc"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        pf.File,
        pf.Path,
        pf.Task,
        pf.Arg,
        Decode,
        Json,
    ]
    provides [main] to pf

readFile = \pathStr ->
    Path.fromStr pathStr
    |> File.readBytes
    |> Task.mapFail \_ -> crash "couldn't read input file at \"\(pathStr)\""

main =
    args <- Arg.list |> Task.await

    filePath = List.get args 1 |> Result.withDefault ""

    fileBytes <- readFile filePath |> Task.await

    [
        part1 "Part 1 Sample" sampleBytes,
        part1 "Part 1 File" fileBytes,
        part2 "Part 2 Sample" sampleBytes,
        part2 "Part 2 File" fileBytes,
    ]
    |> List.keepOks \x -> x
    |> Str.joinWith "\n"
    |> Stdout.line

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
        decodeResult = Decode.fromBytesPartial rest Json.fromUtf8

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
