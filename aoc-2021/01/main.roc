app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
    }
    imports [
        pf.Stdout,
        "./input-day-1.txt" as fileContents : Str,
    ]
    provides [main] to pf

main =

    parsedInput = parseInput fileContents

    part1 = 
        parsedInput 
        |> countDepthIncreases 
        |> Num.toStr

    part2 = 
        parsedInput 
        |> slidingWindow 
        |> countDepthIncreases 
        |> Num.toStr

    Stdout.line "The number of depth increases is Part 1:\(part1) Part 2:\(part2)"

parseInput : Str -> List U64
parseInput = \content ->
    content
    |> Str.split "\n"
    |> List.keepOks Str.toU64

expect parseInput "not-a-number\n123\n345\n678\n" == [123, 345, 678]

countDepthIncreases : List U64 -> U64
countDepthIncreases = \depths ->
    depths
    |> List.walk
        { last: 0, count: 0 }
        \state, depth ->
            next = { state & last: depth }

            when state.last is
                0 -> next
                l if l < depth -> { next & count: state.count + 1 }
                _ -> next
    |> .count

expect countDepthIncreases [] == 0
expect countDepthIncreases [10, 15, 10] == 1
expect countDepthIncreases [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] == 7

slidingWindow : List U64 -> List U64
slidingWindow = \depths ->
    depths
    |> List.walk
        { n1: Nothing, n2: Nothing, filtered: [] }
        \state, depth ->
            when Pair state.n1 state.n2 is
                Pair Nothing Nothing -> { n1: Just depth, n2: Nothing, filtered: [] }
                Pair (Just n1) Nothing -> { n1: Just depth, n2: Just n1, filtered: [] }
                Pair (Just n1) (Just n2) ->
                    { n1: Just depth, n2: Just n1, filtered: List.append state.filtered (n1 + n2 + depth) }

                Pair _ _ -> state
    |> .filtered

expect slidingWindow [1, 2, 3, 4, 5, 6] == [6, 9, 12, 15]
expect slidingWindow [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] == [607, 618, 618, 617, 647, 716, 769, 792]
