app "aoc"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3/5CcipdhTTAtISf4FwlBNHmyu1unYAV8b0MKRwYiEHys.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        TerminalColor.{ Color, withColor },
    ]
    provides [ main, arrayToStr ] to pf

main : Task {} []
main =

    task =
        fileInput <- File.readUtf8 (Path.fromStr "Input/input-day-8.txt") |> Task.map Str.toUtf8 |> Task.await
        fileState = processInput fileInput

        # Part 1
        {} <- part1 (withColor "P1 Sample:" Green) sampleState |> Task.await
        {} <- part1 (withColor "Part 1:" Green) fileState |> Task.await

        # Part 2
        {} <- part2 (withColor "P2 Sample:" Green) sampleState |> Task.await
        {} <- part2 (withColor "Part 2:" Green) fileState |> Task.await

        # Completed
        Stdout.line "Done"

    Task.onFail task \_ -> crash "Oops, something went wrong."

# 2D array of trees
Trees : {
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

    answer =
        processed
        |> .vs # get visibilities
        |> List.countIf \vis -> vis == Bool.true
        |> Num.toStr

    Stdout.line "\(name)\(answer)"

# Part 2
part2 = \name, state ->
    List.range {start : At 0, end : Before state.cols} |> List.map \col ->
        List.range {start : At 0, end : Before state.rows} |> List.map \row ->
            cl = treesIn state Left {row, col}
            cr = treesIn state Right {row, col}
            cu = treesIn state Up {row, col}
            cd = treesIn state Down {row, col}
        
            # calculate scenic score 
            cl * cr * cu * cd
    |> List.join
    |> List.max
    |> Result.withDefault 0
    |> Num.toStr
    |> \answer -> Stdout.line "\(name)\(answer)"

# For debugging
arrayToStr : Trees -> Str
arrayToStr = \state ->
    hs = state.hs |> List.map Num.toStr |> Str.joinWith ","
    vs = state.vs |> List.map (\v -> if v then "Y" else "N") |> Str.joinWith ","
    rows = state.rows |> Num.toStr
    cols = state.cols |> Num.toStr
    count = state.count |> Num.toStr
    "count:\(count),rows:\(rows),cols:\(cols),\nHEIGHTS:\n\(hs)\nVISIBILITIES:\n\(vs)"

initialArray : Trees
initialArray = {
    hs : List.withCapacity (100*100),
    vs : List.withCapacity (100*100),
    rows : 1,
    cols : 0,
    count : 0, 
}

processInput : List U8 {} -> Trees
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

getHeight : Trees, {row : Nat, col: Nat}  -> U8
getHeight = \state, {row, col} ->
    when List.get state.hs (index col state.cols row) is 
        Ok h -> h
        Err _ -> crash "index out of bounds"

getVisibility : Trees, {row : Nat, col: Nat}  -> Bool
getVisibility = \state, {row, col} ->
    when List.get state.vs (index col state.cols row) is 
        Ok v -> v
        Err _ -> crash "index out of bounds"

setVisible : Trees, {row : Nat, col: Nat} -> Trees
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


setRowVisibility : Trees, [Left, Right] -> Trees
setRowVisibility = \state, direction ->
    rowNumbers = List.range {start : At 0, end : Before state.rows}
    state2, currentRow <- List.walk rowNumbers state 

    getRow { row : currentRow, cols : state.cols, direction }
    |> List.map \{row,col} -> {row,col,height : getHeight state {row,col}}
    |> List.walk {tallest : 255, state : state2} setVisHelp
    |> .state

setColVisibility : Trees, [Up, Down] -> Trees
setColVisibility = \state, direction ->
    colNumbers = List.range {start : At 0, end : Before state.rows}
    state2, currentCol <- List.walk colNumbers state 

    getCol { col : currentCol, rows : state.rows, direction }
    |> List.map \{row,col} -> {row,col,height : getHeight state {row,col}}
    |> List.walk {tallest : 255, state : state2} setVisHelp
    |> .state

setVisHelp : {tallest : U8, state: Trees }, {row: Nat, col : Nat, height : U8} -> {tallest : U8, state: Trees }
setVisHelp = \{tallest, state}, {row,col,height} -> 
    if tallest == 255 then 
        {tallest : height, state : setVisible state {row, col}}
    else if height > tallest then 
        {tallest : height, state : setVisible state {row, col}}
    else 
        {state, tallest}

treesIn : Trees, [Up, Down, Left, Right], {row : Nat, col : Nat} -> Nat
treesIn = \state, direction, {row,col} ->
    treeHouseHeight = getHeight state {row, col}
    when direction is 
        Up -> 
            range {start : 0, end : row}
            |> List.reverse
            |> List.dropFirst
            |> List.map \n -> {col, row : n}
            |> List.walk {blocked : Bool.false, tallest : 0, count : 0, state, treeHouseHeight} countTreesHelp
            |> .count
        Down ->
            range {start : row, end : state.rows}
            |> List.dropLast
            |> List.dropFirst
            |> List.map \n -> {col, row : n}
            |> List.walk {blocked : Bool.false, tallest : 0, count : 0, state, treeHouseHeight} countTreesHelp
            |> .count
        Left -> 
            range {start : 0, end : col}
            |> List.reverse
            |> List.dropFirst
            |> List.map \n -> {row, col : n}
            |> List.walk {blocked : Bool.false, tallest : 0, count : 0, state, treeHouseHeight} countTreesHelp
            |> .count
        Right ->
            range {start : col, end : state.cols}
            |> List.dropLast
            |> List.dropFirst
            |> List.map \n -> {row, col : n}
            |> List.walk {blocked : Bool.false, tallest : 0, count : 0, state, treeHouseHeight} countTreesHelp
            |> .count

countTreesHelp = \s, position -> 
    height = getHeight s.state position
    if height >= s.treeHouseHeight && s.blocked == Bool.false then
        {s & count : s.count + 1, blocked : Bool.true}
    else if !s.blocked then
        {s & count : s.count + 1}
    else
        s

expect treesIn sampleState Up {row : 1, col: 2} == 1
expect treesIn sampleState Left {row : 1, col: 2} == 1
expect treesIn sampleState Right {row : 1, col: 2} == 2
expect treesIn sampleState Down {row : 1, col: 2} == 2
expect treesIn sampleState Up {row : 3, col: 2} == 2
expect treesIn sampleState Left {row : 3, col: 2} == 2 
expect treesIn sampleState Right {row : 3, col: 2} == 2
expect treesIn sampleState Down {row : 3, col: 2} == 1
expect treesIn sampleState Up {row : 2, col: 3} == 2
expect treesIn sampleState Left {row : 2, col: 3} == 1
expect treesIn sampleState Right {row : 2, col: 3} == 1
expect treesIn sampleState Down {row : 2, col: 3} == 1
expect treesIn sampleState Up {row : 0, col: 0} == 0
expect treesIn sampleState Left {row : 0, col: 0} == 0 
expect treesIn sampleState Right {row : 0, col: 0} == 2
expect treesIn sampleState Down {row : 0, col: 0} == 2
expect treesIn sampleState Up {row : 4, col: 0} == 1
expect treesIn sampleState Left {row : 4, col: 0} == 0
expect treesIn sampleState Right {row : 4, col: 0} == 1
expect treesIn sampleState Down {row : 4, col: 0} == 0
expect treesIn sampleState Up {row : 1, col: 3} == 1
expect treesIn sampleState Left {row : 1, col: 3} == 1
expect treesIn sampleState Right {row : 1, col: 3} == 1
expect treesIn sampleState Down {row : 1, col: 3} == 1
expect treesIn sampleState Up {row : 2, col: 1} == 1
expect treesIn sampleState Left {row : 2, col: 1} == 1
expect treesIn sampleState Right {row : 2, col: 1} == 3
expect treesIn sampleState Down {row : 2, col: 1} == 2

range : {start : Nat, end : Nat} -> List Nat
range = \{start, end} ->
    if start < end then 
        rangeHelp (1 + end - start) []
        |> List.map (\n -> n + start)
        |> List.reverse
    else if start == end then 
        [start]
    else 
        crash "start must be less than end"

rangeHelp : Nat, List Nat -> List Nat 
rangeHelp = \count, list -> 
    if count == 0 then 
        list
    else 
        rangeHelp (count - 1) (List.append list (count - 1))

expect range {start : 2, end : 4} == [2,3,4]
expect range {start : 0, end : 4} == [0,1,2,3,4]

