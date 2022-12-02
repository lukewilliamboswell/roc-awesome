app "app-aoc-2022-day-2"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.{ Parser },
    ]
    provides [main] to pf

main : Task {} []
main =
    task =
        fileContents <- File.readUtf8 (Path.fromStr "input-day-2.txt") |> Task.await
        input = Str.toUtf8 fileContents |> List.append '\n'
        parser = Parser.oneOrMore rockPaperScissorParser
        answer =
            Parser.parse parser input List.isEmpty
            |> Result.map \rounds ->
                ts = totalScore rounds |> Num.toStr

                "The total score following guide \(ts) "

        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure _) -> Stderr.line "Parsing failure"
            Err (ParsingIncomplete leftover) ->
                ls = leftover |> Str.fromUtf8 |> Result.withDefault ""

                Stderr.line "Parsing incomplete \(ls)"

    Task.onFail task \_ -> crash "Oops, something went wrong."

RSP : [Rock, Scissor, Paper]

totalScore : List { opponent : RSP, guide : RSP } -> U64
totalScore = \rounds ->
    rounds
    |> List.map calculateRoundScore
    |> List.sum

calculateRoundScore : { opponent : RSP, guide : RSP } -> U64
calculateRoundScore = \{ opponent, guide } ->
    baseScore =
        when guide is
            Rock -> 1
            Paper -> 2
            Scissor -> 3

    winLossDrawScore =
        when determineOutcome { opponent, guide } is
            Loss -> 0
            Draw -> 3
            Win -> 6

    baseScore + winLossDrawScore

determineOutcome : { opponent : RSP, guide : RSP } -> [Win, Loss, Draw]
determineOutcome = \{ opponent, guide } ->
    when P opponent guide is
        P Rock Rock -> Draw
        P Rock Paper -> Win
        P Rock Scissor -> Loss
        P Paper Rock -> Loss
        P Paper Paper -> Draw
        P Paper Scissor -> Win
        P Scissor Rock -> Win
        P Scissor Paper -> Loss
        P Scissor Scissor -> Draw

rockPaperScissorParser : Parser (List U8) { opponent : RSP, guide : RSP }
rockPaperScissorParser =
    Parser.const (\opponent -> \_ -> \guide -> \_ -> { opponent, guide })
    |> Parser.apply opponentParser
    |> Parser.apply parseBlankSpace
    |> Parser.apply guideParser
    |> Parser.apply parseNewLine

parseBlankSpace = parseUtf8 ' '
parseNewLine = parseUtf8 '\n'
opponentParser =
    Parser.oneOf [
        parseUtf8 'A' |> Parser.map \_ -> Rock,
        parseUtf8 'B' |> Parser.map \_ -> Paper,
        parseUtf8 'C' |> Parser.map \_ -> Scissor,
    ]

guideParser =
    Parser.oneOf [
        parseUtf8 'X' |> Parser.map \_ -> Rock,
        parseUtf8 'Y' |> Parser.map \_ -> Paper,
        parseUtf8 'Z' |> Parser.map \_ -> Scissor,
    ]

# Crashing roc test :sadface:
expect
    input = ['X']
    parser = guideParser
    result = Parser.parse parser input List.isEmpty

    result == Ok Rock

expect
    input = ['\n']
    parser = parseNewLine
    result = Parser.parse parser input List.isEmpty

    result == Ok '\n'

parseUtf8 : U8 -> Parser (List U8) U8
parseUtf8 = \x ->
    Parser.buildPrimitiveParser \input ->
        when List.first input is
            Ok value ->
                if x == value then
                    Ok { val: x, input: List.dropFirst input }
                else
                    Err (ParsingFailure "")

            Err ListWasEmpty ->
                Err (ParsingFailure "empty list")
