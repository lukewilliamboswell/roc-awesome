app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{ Parser, parse, const, keep, oneOf,map, oneOrMore, buildPrimitiveParser },
    ]
    provides [main] to pf

main : Task {} []
main =
    task =
        fileContents <- File.readUtf8 (Path.fromStr "input-day-2.txt") |> Task.await
        input = Str.toUtf8 fileContents |> List.append '\n'
        # input = Str.toUtf8 "A Y\nB X\nC Z\n"
        parser = oneOrMore rockPaperScissorParser
        answer =
            parse parser input List.isEmpty
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
Outcome : [Loss, Draw, Win]

totalScore : List { opponent : RSP, guide : Outcome } -> U64
totalScore = \rounds ->
    rounds
    |> List.map \round ->
        round
        |> determineChoice
        |> calculateScore
    |> List.sum

calculateScore : { opponent : RSP, choice : RSP } -> U64
calculateScore = \{ opponent, choice } ->
    baseScore =
        when choice is
            Rock -> 1
            Paper -> 2
            Scissor -> 3

    winLossDrawScore =
        when determineOutcome { opponent, choice } is
            Loss -> 0
            Draw -> 3
            Win -> 6

    baseScore + winLossDrawScore

determineOutcome : { opponent : RSP, choice : RSP } -> Outcome
determineOutcome = \{ opponent, choice } ->
    when P opponent choice is
        P Rock Rock -> Draw
        P Rock Paper -> Win
        P Rock Scissor -> Loss
        P Paper Rock -> Loss
        P Paper Paper -> Draw
        P Paper Scissor -> Win
        P Scissor Rock -> Win
        P Scissor Paper -> Loss
        P Scissor Scissor -> Draw

determineChoice : { opponent : RSP, guide : Outcome } -> { opponent : RSP, choice : RSP }
determineChoice = \{ opponent, guide } ->
    if determineOutcome { opponent, choice: Rock } == guide then
        { opponent, choice: Rock }
    else if determineOutcome { opponent, choice: Paper } == guide then
        { opponent, choice: Paper }
    else
        { opponent, choice: Scissor }

rockPaperScissorParser : Parser (List U8) { opponent : RSP, guide : Outcome }
rockPaperScissorParser =
    const (\opponent -> \_ -> \guide -> \_ -> { opponent, guide })
    |> keep opponentParser
    |> keep parseBlankSpace
    |> keep guideParser
    |> keep parseNewLine

parseBlankSpace = parseUtf8 ' '
parseNewLine = parseUtf8 '\n'
opponentParser =
    oneOf [
        parseUtf8 'A' |> map \_ -> Rock,
        parseUtf8 'B' |> map \_ -> Paper,
        parseUtf8 'C' |> map \_ -> Scissor,
    ]

guideParser =
    oneOf [
        parseUtf8 'X' |> map \_ -> Loss,
        parseUtf8 'Y' |> map \_ -> Draw,
        parseUtf8 'Z' |> map \_ -> Win,
    ]

# Crashing roc test :sadface:
expect
    input = ['X']
    parser = guideParser
    result = parse parser input List.isEmpty

    result == Ok Rock

expect
    input = ['\n']
    parser = parseNewLine
    result = parse parser input List.isEmpty

    result == Ok '\n'

parseUtf8 : U8 -> Parser (List U8) U8
parseUtf8 = \x ->
    buildPrimitiveParser \input ->
        when List.first input is
            Ok value ->
                if x == value then
                    Ok { val: x, input: List.dropFirst input }
                else
                    Err (ParsingFailure "")

            Err ListWasEmpty ->
                Err (ParsingFailure "empty list")
