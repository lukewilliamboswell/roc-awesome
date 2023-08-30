app "aoc"
     packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
    }
    imports [
        BingoBoard,
        pf.Stdout,
        "./input-day-4.txt" as fileBytes : List U8,
    ]
    provides [main] to pf

main =
    parsed = BingoBoard.parseInput fileBytes

    when parsed is
        Ok _ ->
            Stdout.line "Success"
        Err msg -> 
            Stdout.line msg
    