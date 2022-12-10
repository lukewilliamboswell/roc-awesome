app "app-aoc-2022-day-9"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Encode, Json,
        TerminalColor.{ Color, withColor },
    ]
    provides [ main, stateToStr ] to pf

main : Task {} []
main =

    task =
        fileInput <- File.readUtf8 (Path.fromStr "input-day-9.txt") |> Task.await
        fileMoves = parse fileInput

        # # Part 1
        {} <- Stdout.line (part1 "Sample" sampleMoves) |> Task.await
        {} <- Stdout.line (part1 "File" fileMoves) |> Task.await

        # # Part 2

        # Completed
        Stdout.line "Done"

    Task.onFail task \_ -> crash "Oops, something went wrong."

Move : { direction : [Right, Left, Up, Down], count : Nat }
Position : {x : I32, y : I32}
State : {
    head : Position,
    tail : Position,
    visits : Set Position,
}

initState : State
initState = {
    head : {x : 0i32, y : 0i32},
    tail : {x : 0i32, y : 0i32},
    visits : Set.single {x : 0i32, y : 0i32},
}

part1 = \name, moves ->
    moves
    |> List.walk initState reduceMoves        
    # |> stateToStr
    |> .visits
    |> Set.len
    |> Num.toStr
    |> \i -> 
        p = withColor "Part 1 \(name):" Green
        "\(p) number of visits is \(i)"

reduceMoves = \state, {direction, count} ->
    if count == 0 then 
        state 
    else 
        # Head moves
        head = when direction is
            Right -> { x : state.head.x + 1, y : state.head.y }
            Left -> { x : state.head.x - 1, y : state.head.y }
            Up -> { x : state.head.x, y : state.head.y + 1 }
            Down -> { x : state.head.x, y : state.head.y - 1 }

        # Tail moves?
        distX = head.x - state.tail.x
        distY = head.y - state.tail.y
        step = \h, t -> when Num.compare h t is
            LT -> -1
            GT -> 1
            EQ -> 0

        tail = 
            if abs distX <= 1 && abs distY <= 1 then
                state.tail
            else
                { 
                    x : state.tail.x + step head.x state.tail.x, 
                    y : state.tail.y + step head.y state.tail.y 
                }

        visits = Set.insert state.visits tail

        reduceMoves {state & head, tail, visits} {direction, count : count - 1}

parse : Str -> List Move 
parse = \input ->
    input
    |> Str.split "\n"
    |> List.map \line -> Str.split line " "
    |> List.map \line ->
        when line is 
            ["R", moves] -> {direction : Right,count : toNatOrCrash moves}
            ["L", moves] -> {direction : Left,count : toNatOrCrash moves}
            ["U", moves] -> {direction : Up,count : toNatOrCrash moves}
            ["D", moves] -> {direction : Down,count : toNatOrCrash moves}
            _ -> crash "unexpected input"

sampleInput = "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2"  
sampleMoves = parse sampleInput
expect sampleMoves == [
        {direction : Right, count : 4},
        {direction : Up, count : 4},
        {direction : Left, count : 3},
        {direction : Down, count : 1},
        {direction : Right, count : 4},
        {direction : Down, count : 1},
        {direction : Left, count : 5},
        {direction : Right, count : 2},
    ]

toNatOrCrash = \numStr ->
    when Str.toNat numStr is 
        Ok n -> n
        Err InvalidNumStr -> crash "invalid num string"

abs : I32 -> U32 
abs = \x -> if x >= 0 then Num.toU32 x else Num.toU32 (-1*x)

expect abs -2 == 2
expect abs 0 == 0

# For debugging
stateToStr = \state ->
    
    # Set which doesnt implement encoding??
    encodableState = {
        head: state.head, 
        tail: state.tail,
        visits : Set.toList state.visits
    }

    when Str.fromUtf8 (Encode.toBytes encodableState Json.toUtf8) is 
        Ok str -> str
        Err _ -> crash "unable to encode state to Json"
