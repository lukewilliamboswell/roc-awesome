app "aoc"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        pf.Process,
        BingoBoard,
    ]
    provides [main] to pf

main : Task {} []
main =
    task = 
        fileContents <- File.readUtf8 (Path.fromStr "input-day-4.txt") |> Task.await

        parsed = BingoBoard.parseInput (Str.toUtf8 fileContents)

        when parsed is
            # Ok {bingoNumbers,bingoBoards} ->
            Ok _ ->
                Stdout.line "Success"
            Err msg -> 
                Stdout.line msg
    
    Task.attempt task \result ->
        when result is
            Ok {} -> Process.exit 0
            Err _ -> Process.exit 1