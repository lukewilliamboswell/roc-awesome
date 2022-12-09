app "app-aoc-2022-day-8"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        TerminalColor.{ Color, withColor },
    ]
    provides [
        main,
        arrayToStr,
    ] to pf

main : Task {} []
main =

    task =
        # Sample
        {} <- part1 (withColor "Sample:" Green) sampleState |> Task.await

        # Part 1
        fileInput <- File.readUtf8 (Path.fromStr "input-day-8.txt") |> Task.map Str.toUtf8 |> Task.await
        fileState = processInput fileInput
        {} <- part1 (withColor "Part 1:" Green) fileState |> Task.await

        # Completed
        Stdout.line "Done"

    Task.onFail task \_ -> crash "Oops, something went wrong."

# 2D array, note must be square
# R C O L U M N S
# O
# W
# S
Array2D : {
    hs : List U8, # heights
    vs : List Bool, # vibilities
    rows : Nat, # zero indexed 
    cols : Nat, # zero indexed
    count : Nat, # for  
}

sampleState = processInput sampleInput

part1 = \name, state ->
    processed = 
        state
        |> setRowVisibility Left
        |> setRowVisibility Right
        |> setColVisibility Up
        |> setColVisibility Down
    
    # FOR DEBUGGING
    # {} <- Stdout.line (arrayToStr processed) |> Task.await

    answer =
        processed
        |> .vs # get visibilities
        |> List.countIf \vis -> vis == Bool.true
        |> Num.toStr

    Stdout.line "\(name)\(answer)"

# For debugging
arrayToStr : Array2D -> Str
arrayToStr = \state ->
    hs = state.hs |> List.map Num.toStr |> Str.joinWith ","
    vs = state.vs |> List.map (\v -> if v then "Y" else "N") |> Str.joinWith ","
    rows = state.rows |> Num.toStr
    cols = state.cols |> Num.toStr
    count = state.count |> Num.toStr
    "count:\(count),rows:\(rows),cols:\(cols),\nHEIGHTS:\n\(hs)\nVISIBILITIES:\n\(vs)"

initialArray : Array2D
initialArray = {
    hs : List.withCapacity (100*100),
    vs : List.withCapacity (100*100),
    rows : 1,
    cols : 0,
    count : 0, 
}

processInput : List U8 {} -> Array2D
processInput = \data ->
    state, elem <- List.walk data initialArray

    when elem is 
        '\n' -> 
            if state.cols == 0 then
                {state & rows : state.rows + 1, cols : state.count}
            else 
                {state & rows : state.rows + 1}
        '0' -> {state & hs : List.append state.hs 0u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '1' -> {state & hs : List.append state.hs 1u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '2' -> {state & hs : List.append state.hs 2u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '3' -> {state & hs : List.append state.hs 3u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '4' -> {state & hs : List.append state.hs 4u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '5' -> {state & hs : List.append state.hs 5u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '6' -> {state & hs : List.append state.hs 6u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '7' -> {state & hs : List.append state.hs 7u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '8' -> {state & hs : List.append state.hs 8u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        '9' -> {state & hs : List.append state.hs 9u8, count : state.count + 1, vs : List.append state.vs Bool.false}
        _ -> crash "unexpected input"

sampleInput =
    """
    30373
    25512
    65332
    33549
    35390
    """
    |> Str.toUtf8

index : Nat, Nat, Nat -> Nat
index = \col, cols, row -> col + cols * row

getHeight : Array2D, {row : Nat, col: Nat}  -> U8
getHeight = \state, {row, col} ->
    when List.get state.hs (index col state.cols row) is 
                Ok h -> h
                Err _ -> crash "index out of bounds"

getVisibility : Array2D, {row : Nat, col: Nat}  -> Bool
getVisibility = \state, {row, col} ->
    when List.get state.vs (index col state.cols row) is 
        Ok v -> v
        Err _ -> crash "index out of bounds"

setVisible : Array2D, {row : Nat, col: Nat} -> Array2D
setVisible = \state, {row, col} ->
    {state & vs : List.set state.vs (index col state.cols row) Bool.true}

expect getHeight sampleState {row : 0, col : 0}  == 3
expect getHeight sampleState {row : 4, col : 4}  == 0
expect getHeight sampleState {row : 2, col : 2}  == 3
expect getHeight sampleState {row : 2, col : 0}  == 6
expect sampleState
    |> setVisible {row : 4, col : 4}
    |> getVisibility {row : 4, col : 4} 
    |> Bool.isEq Bool.true

getRow : {
    row : Nat, # which row number
    cols : Nat, # number of cols
    direction : [Left, Right] # from which direction
} -> List {row : Nat, col : Nat}
getRow = \{row, cols, direction} -> 
    i <- List.range {start : At 0, end : Before cols} |> List.map
    
    when direction is 
        Left -> { row, col : i}
        Right -> { row, col : cols - i - 1}

expect 
    expected = [
        {row: 4, col : 4},
        {row: 4, col : 3},
        {row: 4, col : 2},
        {row: 4, col : 1},
        {row: 4, col : 0},
    ]
    got = getRow {row : 4, cols : 5, direction : Right}
    got == expected

getCol : {
    col : Nat, # which col number
    rows : Nat, # number of rows
    direction : [Down, Up] # from which direction
} -> List {row : Nat, col : Nat}
getCol = \{col, rows, direction} -> 
    i <- List.range {start : At 0, end : Before rows} |> List.map
    
    when direction is 
        Down -> {row: i, col }
        Up -> {row: rows - i - 1, col }

expect 
    expected = [
        {row: 4, col : 4},
        {row: 3, col : 4},
        {row: 2, col : 4},
        {row: 1, col : 4},
        {row: 0, col : 4},
    ]
    got = getCol {col : 4, rows : 5, direction : Up}
    got == expected


setRowVisibility : Array2D, [Left, Right] -> Array2D
setRowVisibility = \state, direction ->
    rowNumbers = List.range {start : At 0, end : Before state.rows}
    state2, currentRow <- List.walk rowNumbers state 

    getRow { row : currentRow, cols : state.cols, direction }
    |> List.map \{row,col} -> {row,col,height : getHeight state {row,col}}
    |> List.walk {tallest : 255, state : state2} setVisHelp
    |> .state

setColVisibility : Array2D, [Up, Down] -> Array2D
setColVisibility = \state, direction ->
    colNumbers = List.range {start : At 0, end : Before state.rows}
    state2, currentCol <- List.walk colNumbers state 

    getCol { col : currentCol, rows : state.rows, direction }
    |> List.map \{row,col} -> {row,col,height : getHeight state {row,col}}
    |> List.walk {tallest : 255, state : state2} setVisHelp
    |> .state

setVisHelp : {tallest : U8, state: Array2D }, {row: Nat, col : Nat, height : U8} -> {tallest : U8, state: Array2D }
setVisHelp = \{tallest, state}, {row,col,height} -> 
    if tallest == 255 then 
        {tallest : height, state : setVisible state {row, col}}
    else if height > tallest then 
        {tallest : height, state : setVisible state {row, col}}
    else 
        {state, tallest}


