app "app-aoc-2021-day-4"
    packages { pf: "../cli-platform/main.roc" }
    imports [
        pf.Program.{ Program },
        pf.Stdout,
        Json,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
    ]
    provides [main] to pf

main : Program
main =
    Path.fromStr "input-day-4.txt"
    |> File.readUtf8
    |> Task.map parseInput
    |> Task.map (\parsedInput -> Encode.toBytes parsedInput Json.toUtf8)
    |> Task.map (\encoded -> encoded |> Str.fromUtf8 |> Result.withDefault "")
    |> Task.map Stdout.line
    # Stdout.line "WIP"
    |> Program.quick

BingoBoard : List {row : U64, col: U64, number: U64}
ParsedInput : {
    bingoNumbers : List U64, 
    boards : List BingoBoard,
}
ParsedInputHelper : [ParsingNumbers ParsedInput, ParsingBoard U64 ParsedInput]

emptyBingoBoard : ParsedInput
emptyBingoBoard = {bingoNumbers : [], boards : [] }

parseInput : Str -> ParsedInput
parseInput = \fileContents ->
    List.walk 
        (Str.graphemes fileContents)
        (ParsingNumbers emptyBingoBoard)
        parseInputHelper
    |> \output -> 
        when output is
            ParsingNumbers input -> input
            ParsingBoard _ input -> input
    |> \parsedInput ->
        # filter out boards that are empty due to newline characters
        updatedBoards = List.keepIf parsedInput.boards (\boards -> List.len boards > 0)
        {parsedInput & boards:updatedBoards}

parseInputHelper : ParsedInputHelper, Str -> ParsedInputHelper
parseInputHelper = \input, grapheme ->
    number = Str.toU64 grapheme
    when number is
        Ok num ->
            when input is
                ParsingNumbers state ->  
                    updatedBingoNumbers = List.append state.bingoNumbers num
                    ParsingNumbers {state & bingoNumbers : updatedBingoNumbers}
                ParsingBoard boardNumber state ->
                    maybeBoard = List.get state.boards boardNumber
                    when maybeBoard is 
                        Ok board ->
                            len = List.len board
                            updatedBoard = List.append board {row : nextRow num, col : nextCol num, number : num } 
                            updatedBoards = List.set state.boards boardNumber updatedBoard
                            ParsingBoard boardNumber {state & boards : updatedBoards}
                        Err _ -> 
                            updatedBoard = [{row : 0u64, col: 0u64, number: num}]
                            updatedBoards = List.set state.boards boardNumber updatedBoard
                            ParsingBoard boardNumber {state & boards : updatedBoards}
        Err _ -> 
            when input is
                ParsingNumbers state ->
                    ParsingBoard 0u64 state
                ParsingBoard boardNumber state ->
                    ParsingBoard (boardNumber+1) state           

# Get the index for the next bingo number to insert into a board  
nextRow : U64 -> U64
nextRow = \len ->
    (len % 5)

expect nextRow 0 == 0
expect nextRow 1 == 1
expect nextRow 2 == 2
expect nextRow 3 == 3
expect nextRow 4 == 4
expect nextRow 5 == 0

nextCol : U64 -> U64
nextCol = \len ->
    (len // 5) % 5

expect nextCol 0 == 0
expect nextCol 1 == 0
expect nextCol 5 == 1
expect nextCol 6 == 1
expect nextCol 10 == 2
expect nextCol 11 == 2