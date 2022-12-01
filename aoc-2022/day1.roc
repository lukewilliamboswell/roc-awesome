app "app-aoc-2022-day-1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.{Parser},
    ]
    provides [main] to pf

main : Task {} []
main =
    task = 
        fileContents <- File.readUtf8 (Path.fromStr "input-day-1.txt") |> Task.await
        # note elf parser wants a trailing empty line to get the last elf
        input = Str.split fileContents "\n" |> List.append "" 
        parser = Parser.oneOrMore elfParser
        answer = 
            Parser.parse parser input List.isEmpty
            |> Result.map \elfCalories ->
                highestCals = 
                    elfCalories 
                    |> List.map List.sum
                    |> List.sortDesc
                    |> List.first
                    |> Result.map Num.toStr
                    |> Result.withDefault ""
                "The highest calories is \(highestCals)"
                        
        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure err) -> Str.concat "Parsing failre: " err |> Stderr.line 
            Err (ParsingIncomplete err) -> Str.concat "Parsing incomplete: " (Str.joinWith err ",") |> Stderr.line 

    Task.onFail task \_ -> crash "Oops, something went wrong."

elfParser : Parser (List Str) (List U64)
elfParser =
    Parser.const (\foods -> \_ -> foods)
    |> Parser.apply (Parser.oneOrMore foodParser)
    |> Parser.apply emptyLineParser

foodParser : Parser (List Str) U64
foodParser =
    Parser.buildPrimitiveParser (\input ->
        when List.first input is 
            Ok value -> 
                when Str.toU64 value is 
                    Ok num -> Ok { val : num, input : List.dropFirst input }
                    Err _ -> Err (ParsingFailure value)
            Err ListWasEmpty -> 
                Err (ParsingFailure "empty list")
    )

emptyLineParser : Parser (List Str) {}
emptyLineParser =
    Parser.buildPrimitiveParser (\input ->
        when List.first input is
            Ok value -> 
                if Str.isEmpty value then 
                    Ok { val : {}, input : List.dropFirst input }
                else
                    Err (ParsingFailure value)
            Err ListWasEmpty -> 
                Err (ParsingFailure "empty list")
    )
