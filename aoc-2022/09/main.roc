app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.1.0/xbO9bXdHi7E9ja6upN5EJXpDoYm7lwmJ8VzL7a5zhYE.tar.br",
        parser: "../Parser/main.roc",
    }
    imports [
        pf.Stdout,
        pf.Task,
        json.Core.{ json },
        "./input-day-9.txt" as fileInput : Str,
        TerminalColor.{ Color, withColor },
    ]
    provides [ main, stateToStr ] to pf

main =
    print = \description, answer -> Stdout.line "\(description)\(answer)"
    fileMoves = parse fileInput

    # Part 1
    {} <- print (withColor "Part 1 Sample:" Green) (process sampleMoves 1) |> Task.await
    {} <- print (withColor "Part 1 File:" Green) (process fileMoves 1) |> Task.await
    
    # Part 2
    {} <- print (withColor "Part 2 Sample:" Green) (process sampleMoves 9) |> Task.await
    {} <- print (withColor "Part 2 Bigger Example:" Green) (process biggerExampleMoves 9) |> Task.await
    {} <- print (withColor "Part 2 File:" Green) (process fileMoves 9) |> Task.await

    Stdout.line "Done"

Move : { direction : [Right, Left, Up, Down], count : Nat }
Position : {x : I32, y : I32}
State : {
    head : Position,
    tails : List Position,
    visits : Set Position,
}

initPosition : Position
initPosition = {x : 0i32, y : 0i32}

initState : Nat -> State
initState = \tailCount ->
    tails =
        List.range {start : At 0, end : Before tailCount}
        |> List.map \_ -> initPosition
    {
        tails,
        head : initPosition,
        visits : Set.single initPosition,
    }

process = \moves, tailCount ->
    moves
    |> List.walk (initState tailCount) reduceMoves
    |> .visits
    |> Set.len
    |> Num.toStr
    |> \i -> "number of visits is \(i)"

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

        # Move tails
        tails = 
            List.walk state.tails {leader : head, tails : []} reduceTails 
            |> .tails

        visits = when List.last tails is 
            Ok lastTail -> Set.insert state.visits lastTail
            Err _ -> crash "expected at least one tail"

        reduceMoves {state & head, tails, visits} {direction, count : count - 1}

reduceTails = \{leader, tails}, tail ->
    distX = leader.x - tail.x
    distY = leader.y - tail.y
    step = \h, t -> when Num.compare h t is
        LT -> -1
        GT -> 1
        EQ -> 0

    updatedTail = 
        if abs distX <= 1 && abs distY <= 1 then
            tail 
        else
            { 
                x : tail.x + step leader.x tail.x, 
                y : tail.y + step leader.y tail.y 
            }
    
    {
        leader : updatedTail, 
        tails : List.append tails updatedTail,
    }

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
biggerExampleInput = "R 5\nU 8\nL 8\nD 3\nR 17\nD 10\nL 25\nU 20"

sampleMoves = parse sampleInput
biggerExampleMoves = parse biggerExampleInput

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

    when Str.fromUtf8 (Encode.toBytes encodableState json) is 
        Ok str -> str
        Err _ -> crash "unable to encode state to Json"
