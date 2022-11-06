app "aoc-2021-day-4"
    packages { pf: "../cli-platform/main.roc" }
    imports [
        pf.Program.{ Program },
        pf.Stdout,
        # pf.Task.{ Task },
        # pf.File,
        # pf.Path.{ Path },
    ]
    provides [main] to pf

main : Program
main =
    Stdout.line "Day 4"
    |> Program.quick
    # task = file <- 
    #             Path.fromStr "input-day-4.txt"
    #             |> File.readUtf8
    #             |> Task.await

    #         Contents bingoNumbersStr bingoBoardsStr = splitContents file

    #         bingoNumbers = 
    #             bingoNumbersStr
    #             |> Str.split ","
    #             |> List.keepOks Str.toU64

    #         bingoBoards =
    #             bingoBoardsStr
    #             |> List.map (\str -> str |> Str.replaceEach "\n" "")
    #             |> List.map (\str -> str |> Result.withDefault "")
    #             |> List.map (\str -> str |> Str.split " ")
    #             |> List.map (\str -> str |> List.keepOks Str.toU64)
    #             |> List.keepOks parseBingoBoard
    #             |> List.map printBingoBoard
    #             |> Str.joinWith "\n\n"

            
    #         printValue = 
    #             Str.concat 
    #                 (bingoBoards )
    #                 (bingoNumbers |> List.map Num.toStr |> Str.joinWith ",")
            
    #         Stdout.line printValue
    
    

# Board : Dict [Index U8 U8] U64

# ## Parse numbers into a bingo board
# ## Note will overwrite numbers if more than 25 
# parseBingoBoard : List U64 -> Result Board [TooManyNumbers, TooFewNumbers]
# parseBingoBoard = \numbers ->
#     length = List.len numbers 
#     if length == 25 then 
#         # x0y0 x1y0 ... x4y0
#         # x0y1 ...  ... x4y1
#         # .
#         # .
#         # x0y4 ...  ... x4y4
#         List.walk 
#             numbers
#             {board: Dict.empty, x : 0u8, y : 0u8}
#             \state, elem ->
#                 newBoard = Dict.insert state.board (Index state.x state.y) elem
#                 newX = (state.x + 1u8) % 5u8
#                 newY = (state.y + 1u8) % 5u8
#                 {board: newBoard, x : newX, y : newY}
#         |> \state -> Ok state.board
#     else if length < 25 then
#         Err TooFewNumbers
#     else 
#         Err TooManyNumbers 
    
# expect parseBingoBoard [1,2,3] == Err TooFewNumbers

# printBingoBoard : Board -> Str
# printBingoBoard = \_ ->
#     "TODO: Implement me"

# splitContents : Str ->  [Contents Str (List Str)]
# splitContents = \contents ->
#     {before, others} = contents 
#         |> Str.split "\n\n"
#         |> List.split 1
    
#     bingoNumbersStr = before 
#         |> List.first
#         |> Result.withDefault ""

#     Contents bingoNumbersStr others