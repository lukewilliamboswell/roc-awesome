app "aoc-2021-day-1"
    packages { pf: "cli-platform/main.roc" }
    imports [
        pf.Program.{ Program },
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
    ]
    provides [main] to pf

main : Program
main =
    "input-day-1.txt"
    |> Path.fromStr
    |> File.readUtf8
    |> Task.map parseInput
    |> Task.map countDepthIncreases
    |> Task.map Num.toStr
    |> Task.await (\count -> Stdout.line "The number of depth increases is: \(count)")
    |> Program.quick

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
