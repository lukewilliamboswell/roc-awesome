app "aoc"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Task.{Task, await},
    ]
    provides [main] to pf

# row col
Node : (I32, I32)

State : {
    heights : Dict Node U8,
    unvisited : Dict Node U32,
    visited : Dict Node U32,
    start : Node,
    end : Node,
    rows: U8, 
    cols: U8,
}

sampleInput =
    """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

main =
    initialState = {
        heights: Dict.empty {},
        unvisited: Dict.empty {},
        visited: Dict.empty {},
        start: (0, 0),
        end: (0, 0),
        rows: 1, 
        cols: 0, 
    }

    state = parseMap (Str.toUtf8 sampleInput) initialState 0 0

    # dbg state

    {} <- printMap state |> await

    Stdout.line "Hi"

parseMap : List U8, State, I32, I32 -> State
parseMap = \input, state, row, col ->
    when input is
        [] -> state
        [a, ..] if a == '\n' ->
            # Next row, reset column
            # Assume all rows are same length
            updatedState = { state & 
                rows: state.rows + 1,
                cols: Num.toU8 col,
            }
            parseMap (List.dropFirst input) updatedState (row + 1) 0

        [a, ..] if a == 'S' ->
            # Add Start node
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) 'a',
                unvisited: Dict.insert state.unvisited (row, col) 0,
                start: (row, col),
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

        [a, ..] if a == 'E' ->
            # Add End node
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) 'z',
                unvisited: Dict.insert state.unvisited (row, col) Num.maxU32,
                end: (row, col),
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

        [a, ..] ->
            # Add node
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) a,
                unvisited: Dict.insert state.unvisited (row, col) Num.maxU32,
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

printMap : State -> Task {} []
printMap = \{rows, cols, heights, start, end} ->
    strs = generateNodes {rows, cols} |> List.map \node ->
        if node == start then
            "S"
        else if node == end then
            "E"
        else
            when Dict.get heights node |> Result.map (\x -> [x]) |> Result.try Str.fromUtf8 is 
                Ok h -> 
                    if Num.toU8 node.1 == cols - 1 then
                        "\(h)\n"
                    else
                        h
                Err _ -> "?"

    strs
    |> Str.joinWith ""
    |> Stdout.line

generateNodes : {rows : U8, cols : U8} -> List Node
generateNodes = \{rows, cols} ->
    row <- List.range {start: At 0, end: Before rows} |> List.joinMap
    col <- List.range {start: At 0, end: Before cols} |> List.map
    
    (Num.toI32 row, Num.toI32 col)

expect generateNodes {rows: 2, cols: 3} == [
    (0, 0),
    (0, 1),
    (0, 2),
    (1, 0),
    (1, 1),
    (1, 2),
]

