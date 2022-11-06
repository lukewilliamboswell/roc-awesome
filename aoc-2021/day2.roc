app "app-aoc-2021-day-2"
    packages { pf: "../cli-platform/main.roc" }
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
    "input-day-2.txt"
    |> Path.fromStr
    |> File.readUtf8
    |> Task.map parseInput
    |> Task.map process
    |> Task.await
        (\{ h, d } ->
            hs = h |> Num.toStr
            ds = d |> Num.toStr
            rs = (h * d) |> Num.toStr

            Stdout.line "Final position is h:\(hs),d:\(ds), result:\(rs)")
    |> Program.quick

maybeMove : Str, Str -> Result U64 [InvalidNumStr, NotFound]
maybeMove = \line, direction ->
    line
    |> Str.replaceFirst direction ""
    |> Result.map Str.trim
    |> Result.try Str.toU64

expect Str.replaceFirst "forward 12" "forward" "" == Ok " 12"
expect maybeMove "forward 12" "forward" == Ok 12

parseInput : Str -> List [Fd U64, Up U64, Dn U64]
parseInput = \content ->
    content
    |> Str.split "\n"
    |> List.keepOks \line ->
        maybeForward = maybeMove line "forward"
        maybeDown = maybeMove line "down"
        maybeUp = maybeMove line "up"

        when Triple maybeForward maybeDown maybeUp is
            Triple (Ok x) _ _ -> Ok (Fd x)
            Triple _ (Ok x) _ -> Ok (Dn x)
            Triple _ _ (Ok x) -> Ok (Up x)
            Triple _ _ _ -> Err ""

expect parseInput "" == []
expect parseInput "forward 12" == [Fd 12]
expect parseInput "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2" == [Fd 5, Dn 5, Fd 8, Up 3, Dn 8, Fd 2]

process : List [Fd U64, Up U64, Dn U64] -> { h : U64, d : U64, a : U64 }
process = \movements ->
    movements
    |> List.walk
        { h: 0, d: 0, a: 0 }
        \state, current ->
            when current is
                Fd x -> { state & h: state.h + x, d: state.d + (x * state.a) }
                Up x -> { state & a: state.a - x }
                Dn x -> { state & a: state.a + x }

expect process [Fd 5, Dn 5, Fd 8, Up 3, Dn 8, Fd 2] == { h: 15, d: 60, a: 10 }
