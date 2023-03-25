app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3/5CcipdhTTAtISf4FwlBNHmyu1unYAV8b0MKRwYiEHys.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{ Parser, parse, const, many, map, keep, skip, oneOrMore, buildPrimitiveParser },
    ]
    provides [main, assignmentPairToStr] to pf

main : Task {} []
main =
    task =
        fileContents <- File.readUtf8 (Path.fromStr "input-day-4.txt") |> Task.await
        input = Str.toUtf8 fileContents
        # input = Str.toUtf8 "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"
        parser = many assignmentPairParser
        answer =
            parse parser input List.isEmpty
            |> Result.map \pairs ->
                countContained =
                    pairs
                    |> List.keepIf isFullyContained
                    |> List.map (\_ -> 1u64)
                    |> List.sum
                    |> Num.toStr

                countAnyOverlap =
                    pairs
                    |> List.keepIf isAnyOverlap
                    |> List.map (\_ -> 1u64)
                    |> List.sum
                    |> Num.toStr

                "Part 1: \(countContained), Part 2: \(countAnyOverlap)"

        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure _) -> Stderr.line "Parsing failure"
            Err (ParsingIncomplete leftover) ->
                ls = leftover |> Str.fromUtf8 |> Result.withDefault ""

                Stderr.line "Parsing incomplete \(ls)"

    Task.onFail task \_ -> crash "Oops, something went wrong."

AssignmentPair : {
    startElfA : U64,
    endElfA : U64,
    startElfB : U64,
    endElfB : U64,
}

isFullyContained : AssignmentPair -> Bool
isFullyContained = \{ startElfA, endElfA, startElfB, endElfB } ->
    if startElfA >= startElfB && endElfA <= endElfB then
        Bool.true
    else if startElfB >= startElfA && endElfB <= endElfA then
        Bool.true
    else
        Bool.false

isAnyOverlap : AssignmentPair -> Bool
isAnyOverlap = \{ startElfA, endElfA, startElfB, endElfB } ->
    elf1 = List.range { start: At startElfA, end : At (endElfA + 1)} |> Set.fromList
    elf2 = List.range { start: At startElfB, end : At (endElfB + 1)} |> Set.fromList

    Set.intersection elf1 elf2
    |> Set.toList
    |> List.isEmpty
    |> Bool.not

# to help with debugging, not required
assignmentPairToStr : AssignmentPair -> Str
assignmentPairToStr = \{ startElfA, endElfA, startElfB, endElfB } ->
    a = Num.toStr startElfA
    b = Num.toStr endElfA
    c = Num.toStr startElfB
    d = Num.toStr endElfB

    "\(a)-\(b),\(c)-\(d)"

assignmentPairParser : Parser (List U8) AssignmentPair
assignmentPairParser =
    const
        (\a -> \b -> \c -> \d -> {
            startElfA: a,
            endElfA: b,
            startElfB: c,
            endElfB: d,
        })
    |> skip (many (codepoint '\n'))
    |> keep numberParser
    |> skip (codepoint '-')
    |> keep numberParser
    |> skip (codepoint ',')
    |> keep numberParser
    |> skip (codepoint '-')
    |> keep numberParser

# ## --- below should be in a Parser package
codepoint : U8 -> Parser (List U8) U8
codepoint = \x ->
    input <- buildPrimitiveParser

    when List.first input is
        Ok value ->
            if x == value then
                Ok { val: x, input: List.dropFirst input }
            else
                Err (ParsingFailure "")

        Err ListWasEmpty ->
            Err (ParsingFailure "empty list")

digitParser : Parser (List U8) U64
digitParser =
    input <- buildPrimitiveParser
    
    first = List.first input

    if first == Ok '0' then
        Ok { val: 0u64, input: List.dropFirst input }
    else if first == Ok '1' then
        Ok { val: 1u64, input: List.dropFirst input }
    else if first == Ok '2' then
        Ok { val: 2u64, input: List.dropFirst input }
    else if first == Ok '3' then
        Ok { val: 3u64, input: List.dropFirst input }
    else if first == Ok '4' then
        Ok { val: 4u64, input: List.dropFirst input }
    else if first == Ok '5' then
        Ok { val: 5u64, input: List.dropFirst input }
    else if first == Ok '6' then
        Ok { val: 6u64, input: List.dropFirst input }
    else if first == Ok '7' then
        Ok { val: 7u64, input: List.dropFirst input }
    else if first == Ok '8' then
        Ok { val: 8u64, input: List.dropFirst input }
    else if first == Ok '9' then
        Ok { val: 9u64, input: List.dropFirst input }
    else
        Err (ParsingFailure "Not a digit")

numberParser : Parser (List U8) U64
numberParser =
    digits <- digitParser |> oneOrMore |> map
    
    sum, digit <- List.walk digits 0
        
    sum * 10 + digit
