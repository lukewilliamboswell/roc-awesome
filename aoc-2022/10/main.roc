app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/v0.3.0/y2bZ-J_3aq28q0NpZPjw0NC6wghUYFooJpH03XzJ3Ls.tar.br",
        parser: "../Parser/main.roc",
    }
    imports [
        pf.Stdout,
        pf.Task,
        json.Core.{ json },
        "./input-day-10.txt" as fileContents : Str,
        TerminalColor.{ Color, withColor },
    ]
    provides [ main, stateToStr ] to pf

main =
    print = \description, answer -> Stdout.line "\(description)\(answer)"

    fileInstructions = parse fileContents

    # Part 1
    {} <- print (withColor "Part 1 Small sample:" Green) (part1 smaleInstructions) |> Task.await
    {} <- print (withColor "Part 1 Bigger example:" Green) (part1 biggerInstructions) |> Task.await
    {} <- print (withColor "Part 1 Input file:" Green) (part1 fileInstructions) |> Task.await

    # Part 2
    {} <- print (withColor "Part 2 Bigger example:" Green) (part2 biggerInstructions) |> Task.await
    {} <- print (withColor "Part 2 Input file:" Green) (part2 fileInstructions) |> Task.await

    Stdout.line "Done"

Instruction : [NOOP, ADDX I32]
Sample : {cycle : I32, start : I32, end : I32}
State : {
    cycle : I32,
    register : I32,
    history : List Sample,
    current : Instruction,
    cyclesRemaining : Nat,
}

initState : State
initState = {
    cycle : 0, 
    register : 1,
    history : [],
    current : NOOP,
    cyclesRemaining : 0,
}

part1 = \instructions ->
    List.walk instructions initState reduceInstructions
    |> .history
    |> filterSignalStrength
    |> List.map \{cycle, start } -> cycle*start
    |> List.sum
    |> Num.toStr
    |> \answer -> "sum of signal strength is \(answer)"

part2 = \instructions ->
    List.walk instructions initState reduceInstructions 
    |> .history
    |> renderPixels    
    |> \answer -> "\n\(answer)"

filterSignalStrength = \history ->
    check = \{cycle} -> 
        List.range {start : At 20, end : At 220, step : 40}
        |> List.contains cycle
    
    List.keepIf history check

reduceInstructions = \state, instruction ->
    cyclesRequired = when instruction is
        NOOP -> 1
        ADDX _ -> 2

    tick {state & current : instruction, cyclesRemaining : cyclesRequired }

tick : State -> State
tick = \state ->

    start = state.register

    current = state.current

    cycle = state.cycle + 1

    offset = when P cyclesRemaining current is 
        P 0 (ADDX value) -> value
        _ -> 0

    register = state.register + offset

    end = register

    history = List.append state.history {cycle, start, end}

    cyclesRemaining = state.cyclesRemaining - 1

    if cyclesRemaining == 0 then
        { cycle, register, history, current, cyclesRemaining } 
    else
        tick { cycle, register, history, current, cyclesRemaining } 

toPixels : List Sample -> List Str
toPixels = \samples ->
    {cycle, start} <- List.map samples

    position = (cycle - 1) % 40
    
    drawSprite = 
        List.range {start : At (start - 1), end : At (start + 1)}
        |> List.contains position
    
    if drawSprite then 
        "#"
    else 
        "."

renderPixels : List Sample -> Str
renderPixels = \samples -> 
    toPixels samples
    |> List.walk {buffer:"", index : 0} \state, pixel ->
    
        buffer = 
            if index % 40 == 0 then
                Str.concat state.buffer "\(pixel)\n"
            else 
                Str.concat state.buffer pixel

        index = state.index + 1

        {buffer, index}

    |> .buffer

parse : Str -> List Instruction 
parse = \input ->
    input
    |> Str.split "\n"
    |> List.map \line -> Str.split line " "
    |> List.map \line ->
        when line is 
            ["noop"] -> NOOP
            ["addx", value] -> ADDX (toI32OrCrash value)
            _ -> crash "unexpected input"

toI32OrCrash = \numStr ->
    when Str.toI32 numStr is 
        Ok n -> n
        Err InvalidNumStr -> crash "invalid num string"

smallSample = "noop\naddx 3\naddx -5"  
smaleInstructions = parse smallSample
expect smaleInstructions == [NOOP, ADDX 3, ADDX -5]

biggerSample = "addx 15\naddx -11\naddx 6\naddx -3\naddx 5\naddx -1\naddx -8\naddx 13\naddx 4\nnoop\naddx -1\naddx 5\naddx -1\naddx 5\naddx -1\naddx 5\naddx -1\naddx 5\naddx -1\naddx -35\naddx 1\naddx 24\naddx -19\naddx 1\naddx 16\naddx -11\nnoop\nnoop\naddx 21\naddx -15\nnoop\nnoop\naddx -3\naddx 9\naddx 1\naddx -3\naddx 8\naddx 1\naddx 5\nnoop\nnoop\nnoop\nnoop\nnoop\naddx -36\nnoop\naddx 1\naddx 7\nnoop\nnoop\nnoop\naddx 2\naddx 6\nnoop\nnoop\nnoop\nnoop\nnoop\naddx 1\nnoop\nnoop\naddx 7\naddx 1\nnoop\naddx -13\naddx 13\naddx 7\nnoop\naddx 1\naddx -33\nnoop\nnoop\nnoop\naddx 2\nnoop\nnoop\nnoop\naddx 8\nnoop\naddx -1\naddx 2\naddx 1\nnoop\naddx 17\naddx -9\naddx 1\naddx 1\naddx -3\naddx 11\nnoop\nnoop\naddx 1\nnoop\naddx 1\nnoop\nnoop\naddx -13\naddx -19\naddx 1\naddx 3\naddx 26\naddx -30\naddx 12\naddx -1\naddx 3\naddx 1\nnoop\nnoop\nnoop\naddx -9\naddx 18\naddx 1\naddx 2\nnoop\nnoop\naddx 9\nnoop\nnoop\nnoop\naddx -1\naddx 2\naddx -37\naddx 1\naddx 3\nnoop\naddx 15\naddx -21\naddx 22\naddx -6\naddx 1\nnoop\naddx 2\naddx 1\nnoop\naddx -10\nnoop\nnoop\naddx 20\naddx 1\naddx 2\naddx 2\naddx -6\naddx -11\nnoop\nnoop\nnoop"
biggerInstructions = parse biggerSample

# For debugging
stateToStr = \state ->
    when Str.fromUtf8 (Encode.toBytes state json) is 
        Ok str -> str
        Err _ -> crash "unable to encode state to Json"
