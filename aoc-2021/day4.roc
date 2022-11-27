app "app-aoc-2021-day-4"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        pf.Process,
    ]
    provides [main] to pf

main : Task {} []
main =
    task = 
        _ <- File.readUtf8 (Path.fromStr "input-day-4.txt") |> Task.await
        Stdout.line "Read ths input file... do something with it"
    
    Task.attempt task \result ->
        when result is
            Ok {} -> Process.exit 0
            Err _ -> Process.exit 1

# BingoBoard : List {row : U64, col: U64, number: U64}
# ParsedInput : {
#     bingoNumbers : List U64, 
#     boards : List BingoBoard,
# }
# ParsedInputHelper : [ParsingNumbers ParsedInput, ParsingBoard U64 ParsedInput]

# emptyBingoBoard : ParsedInput
# emptyBingoBoard = {bingoNumbers : [], boards : [] }

# parseInput : Str -> ParsedInput
# parseInput = \fileContents ->
#     List.walk 
#         (Str.graphemes fileContents)
#         (ParsingNumbers emptyBingoBoard)
#         parseInputHelper
#     |> \output -> 
#         when output is
#             ParsingNumbers input -> input
#             ParsingBoard _ input -> input
#     |> \parsedInput ->
#         # filter out boards that are empty due to newline characters
#         updatedBoards = List.keepIf parsedInput.boards (\boards -> List.len boards > 0)
#         {parsedInput & boards:updatedBoards}

# parseInputHelper : ParsedInputHelper, Str -> ParsedInputHelper
# parseInputHelper = \input, grapheme ->
#     number = Str.toU64 grapheme
#     when number is
#         Ok num ->
#             when input is
#                 ParsingNumbers state ->  
#                     updatedBingoNumbers = List.append state.bingoNumbers num
#                     ParsingNumbers {state & bingoNumbers : updatedBingoNumbers}
#                 ParsingBoard boardNumber state ->
#                     maybeBoard = List.get state.boards (Num.toNat boardNumber) 
#                     when maybeBoard is 
#                         Ok board ->
#                             updatedBoard = List.append board {row : nextRow num, col : nextCol num, number : num } 
#                             updatedBoards = List.set state.boards (Num.toNat boardNumber) updatedBoard
#                             ParsingBoard boardNumber {state & boards : updatedBoards}
#                         Err _ -> 
#                             updatedBoard = [{row : 0u64, col: 0u64, number: num}]
#                             updatedBoards = List.set state.boards (Num.toNat boardNumber) updatedBoard
#                             ParsingBoard boardNumber {state & boards : updatedBoards}
#         Err _ -> 
#             when input is
#                 ParsingNumbers state ->
#                     ParsingBoard 0u64 state
#                 ParsingBoard boardNumber state ->
#                     ParsingBoard (boardNumber+1) state           

# # Get the index for the next bingo number to insert into a board  
# nextRow : U64 -> U64
# nextRow = \len ->
#     (len % 5)

# expect nextRow 0 == 0
# expect nextRow 1 == 1
# expect nextRow 2 == 2
# expect nextRow 3 == 3
# expect nextRow 4 == 4
# expect nextRow 5 == 0

# nextCol : U64 -> U64
# nextCol = \len ->
#     (len // 5) % 5

# expect nextCol 0 == 0
# expect nextCol 1 == 0
# expect nextCol 5 == 1
# expect nextCol 6 == 1
# expect nextCol 10 == 2
# expect nextCol 11 == 2