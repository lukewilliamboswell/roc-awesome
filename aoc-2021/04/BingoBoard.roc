interface BingoBoard
    exposes [Board, new, toStr, parseInput]
    imports [        
        Parser.Core.{ Parser, parse, const, apply, map, oneOrMore, many, buildPrimitiveParser },
    ]

Board := {
    r1c1 : U64, r1c2 : U64, r1c3 : U64, r1c4 : U64, r1c5 : U64, 
    r2c1 : U64, r2c2 : U64, r2c3 : U64, r2c4 : U64, r2c5 : U64, 
    r3c1 : U64, r3c2 : U64, r3c3 : U64, r3c4 : U64, r3c5 : U64, 
    r4c1 : U64, r4c2 : U64, r4c3 : U64, r4c4 : U64, r4c5 : U64, 
    r5c1 : U64, r5c2 : U64, r5c3 : U64, r5c4 : U64, r5c5 : U64,
}

# Takes the first 25 integers from a list and returns a bingo board
new : List U64 -> Result Board [TooFewNumbers]
new = \numbers ->
    if List.len numbers <= 25 then 
        Err TooFewNumbers
    else 
        board = @Board {
            r1c1 : List.get numbers 0 |> Result.withDefault 0,
            r1c2 : List.get numbers 1 |> Result.withDefault 0,
            r1c3 : List.get numbers 2 |> Result.withDefault 0,
            r1c4 : List.get numbers 3 |> Result.withDefault 0,
            r1c5 : List.get numbers 4 |> Result.withDefault 0,
            r2c1 : List.get numbers 5 |> Result.withDefault 0,
            r2c2 : List.get numbers 6 |> Result.withDefault 0,
            r2c3 : List.get numbers 7 |> Result.withDefault 0,
            r2c4 : List.get numbers 8 |> Result.withDefault 0,
            r2c5 : List.get numbers 9 |> Result.withDefault 0,
            r3c1 : List.get numbers 10 |> Result.withDefault 0,
            r3c2 : List.get numbers 11 |> Result.withDefault 0,
            r3c3 : List.get numbers 12 |> Result.withDefault 0,
            r3c4 : List.get numbers 13 |> Result.withDefault 0,
            r3c5 : List.get numbers 14 |> Result.withDefault 0,
            r4c1 : List.get numbers 15 |> Result.withDefault 0,
            r4c2 : List.get numbers 16 |> Result.withDefault 0,
            r4c3 : List.get numbers 17 |> Result.withDefault 0,
            r4c4 : List.get numbers 18 |> Result.withDefault 0,
            r4c5 : List.get numbers 19 |> Result.withDefault 0,
            r5c1 : List.get numbers 20 |> Result.withDefault 0,
            r5c2 : List.get numbers 21 |> Result.withDefault 0,
            r5c3 : List.get numbers 22 |> Result.withDefault 0,
            r5c4 : List.get numbers 23 |> Result.withDefault 0,
            r5c5 : List.get numbers 24 |> Result.withDefault 0,
        }

        Ok board

toStr : Board -> Str
toStr = \@Board contents ->
    row1 = [
            numToStrPadded contents.r1c1,
            numToStrPadded contents.r1c2,
            numToStrPadded contents.r1c3,
            numToStrPadded contents.r1c4,
            numToStrPadded contents.r1c5,
        ]
        |> Str.joinWith ","

    row2 = [
            numToStrPadded contents.r2c1,
            numToStrPadded contents.r2c2,
            numToStrPadded contents.r2c3,
            numToStrPadded contents.r2c4,
            numToStrPadded contents.r2c5,
        ]
        |> Str.joinWith ","
    
    row3 = [
            numToStrPadded contents.r3c1,
            numToStrPadded contents.r3c2,
            numToStrPadded contents.r3c3,
            numToStrPadded contents.r3c4,
            numToStrPadded contents.r3c5,
        ]
        |> Str.joinWith ","

    row4 = [
            numToStrPadded contents.r4c1,
            numToStrPadded contents.r4c2,
            numToStrPadded contents.r4c3,
            numToStrPadded contents.r4c4,
            numToStrPadded contents.r4c5,
        ]
        |> Str.joinWith ","

    row5 = [
            numToStrPadded contents.r5c1,
            numToStrPadded contents.r5c2,
            numToStrPadded contents.r5c3,
            numToStrPadded contents.r5c4,
            numToStrPadded contents.r5c5,
        ]
        |> Str.joinWith ","

    [row1, row2, row3, row4, row5]
    |> List.map (\x -> Str.withPrefix x "[")
    |> List.map (\x -> Str.concat x "]")
    |> Str.joinWith  "\n"

numToStrPadded : U64 -> Str 
numToStrPadded = \n ->
    # assume only two digit numbers for AoC 2021 Question
    if n < 10 then
        Num.toStr n 
        |> Str.withPrefix "0"
    else 
        Num.toStr n

digitParser : Parser (List U8) U64
digitParser = 
    buildPrimitiveParser \input ->
        first = List.first input
        if first == Ok '0' then 
            Ok { val : 0u64, input : List.dropFirst input }
        else if first == Ok '1' then 
            Ok { val : 1u64, input : List.dropFirst input }
        else if first == Ok '2' then 
            Ok { val : 2u64, input : List.dropFirst input }
        else if first == Ok '3' then 
            Ok { val : 3u64, input : List.dropFirst input }
        else if first == Ok '4' then 
            Ok { val : 4u64, input : List.dropFirst input }
        else if first == Ok '5' then 
            Ok { val : 5u64, input : List.dropFirst input }
        else if first == Ok '6' then 
            Ok { val : 6u64, input : List.dropFirst input }
        else if first == Ok '7' then 
            Ok { val : 7u64, input : List.dropFirst input }
        else if first == Ok '8' then 
            Ok { val : 8u64, input : List.dropFirst input }
        else if first == Ok '9' then 
            Ok { val : 9u64, input : List.dropFirst input }
        else
            Err (ParsingFailure "Not a digit")

numberParser : Parser (List U8) U64
numberParser = 
    oneOrMore digitParser
    |> map \digits ->
        List.walk
            digits
            0
            \sum, digit -> sum*10 + digit

commaParser : Parser (List U8) {}
commaParser = 
    buildPrimitiveParser \input ->
        first = List.first input
        if first == Ok ',' then
            Ok { val : {}, input : List.dropFirst input }
        else
            Err (ParsingFailure "Not a comma")

eolParser : Parser (List U8) {}
eolParser =
    buildPrimitiveParser (\input ->
        first = List.first input
        if first == Ok '\n' then
            Ok { val : {}, input : List.dropFirst input }
        else
            Err (ParsingFailure "Not a comma")
    )

numberComma = 
    const (\a -> \_ -> a)
    |> apply numberParser
    |> apply commaParser

numberEolLine = 
        const (\a -> \_ -> a)
        |> apply numberParser
        |> apply eolParser

bingoNumbersRow : Parser (List U8) (List U64) 
bingoNumbersRow =
    const (\a -> \b -> List.append a b)
    |> apply (many numberComma)
    |> apply numberEolLine

bingoBoardRow : Parser (List U8) (List U64) 
bingoBoardRow =
    const (\c1 -> \_ -> \c2 -> \_ -> \c3 -> \_ -> \c4 -> \_ -> \c5 -> \_ -> [c1,c2,c3,c4,c5])
    |> apply numberParser |> apply commaParser
    |> apply numberParser |> apply commaParser
    |> apply numberParser |> apply commaParser
    |> apply numberParser |> apply commaParser
    |> apply numberParser |> apply eolParser

boardParser : Parser (List U8) Board
boardParser = 
    const (\r1 -> \r2 -> \r3 -> \r4 -> \r5 ->
        maybeBoard = new (List.join [r1,r2,r3,r4,r5])
        when maybeBoard is 
            Ok board -> board
            Err _ -> crash "should have correct number of numbers when parsing a bingo board"
    )
    |> apply bingoBoardRow
    |> apply bingoBoardRow
    |> apply bingoBoardRow
    |> apply bingoBoardRow
    |> apply bingoBoardRow

bingoParser : Parser (List U8) {
    bingoNumbers : List U64,
    bingoBoards : List Board,
}
bingoParser =
    const (\bingoNumbers -> \_ -> \bingoBoards -> {
        bingoNumbers,
        bingoBoards,
    })
    |> apply bingoNumbersRow
    |> apply eolParser
    |> apply (oneOrMore (
        const (\board -> \_ -> board) 
        |> apply boardParser 
        |> apply eolParser
    ))

parseInput : List U8 -> Result {
    bingoNumbers : List U64,
    bingoBoards : List Board,
} Str
parseInput = \fileInput ->
    when Parser.Core.parse bingoParser fileInput List.isEmpty is 
        Ok result -> Ok result
        Err (ParsingFailure err) -> Err (Str.concat "Parsing Error: " err)
        Err (ParsingIncomplete input) -> 
                r = input |> Str.fromUtf8 |> Result.withDefault ""
                Err (Str.concat "Parsing Incomplete: " r)

expect 
    input = Str.toUtf8 "020"
    parse numberParser input List.isEmpty == Ok 20u64

expect 
    input = Str.toUtf8 ","
    parse commaParser input List.isEmpty == Ok {}

expect 
    input = Str.toUtf8 "\n"
    parse eolParser input List.isEmpty == Ok {}

expect
    input = Str.toUtf8 ",,,20,03\n"
    parser = 
        const (\_ -> \a -> \_ -> \b -> \_ -> a*b)
        |> apply (oneOrMore commaParser)
        |> apply numberParser
        |> apply commaParser
        |> apply numberParser
        |> apply eolParser
    parse parser input List.isEmpty == Ok 60

expect
    input = Str.toUtf8 "19,17,62,78,27,"
    parser = many numberComma
    parse parser input List.isEmpty == Ok [19,17,62,78,27]

expect
    input = Str.toUtf8 "19\n17\n62\n78\n27\n"
    parser = many numberEolLine
    parse parser input List.isEmpty == Ok [19,17,62,78,27]

# expect
#     input = Str.toUtf8 "19,17,62,78,27\n"
#     parser = bingoNumbersRow
#     parse parser input List.isEmpty == Ok [19,17,62,78,27]
