app "aoc-2021-day-2"
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
    "input-day-2.txt"
    |> Path.fromStr
    |> File.readUtf8
    |> Task.map parseInput
    |> Task.await
        (\_ ->
            h = "10"
            d = "12"
            r = "120"

            Stdout.line "Final position is h:\(h),d:\(d), result:\(r)")
    |> Program.quick

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
            Triple (Ok x) _ _ -> Fd x
            Triple _ (Ok x) _ -> Dn x
            Triple _ _ (Ok x) -> Up x
            Triple _ _ _ -> Fd 0

expect parseInput "" == []
expect parseInput "forward 12" == [Fd 12]
expect parseInput "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2" == [Fd 5, Dn 5, Fd 8, Up 3, Dn 8, Fd 2]
