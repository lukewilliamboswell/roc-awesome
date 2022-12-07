app "app-aoc-2022-day-1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{Parser, parse, buildPrimitiveParser, keep, const, oneOrMore},
    ]
    provides [main] to pf

main : Task {} []
main =
    task = 
        fileContents <- File.readUtf8 (Path.fromStr "input-day-1.txt") |> Task.await
        # note elf parser wants a trailing empty line to get the last elf
        input = Str.split fileContents "\n" |> List.append "" 
        parser = oneOrMore elfParser
        answer = 
            parse parser input List.isEmpty
            |> Result.map \elfCalories ->
                sortedCals = 
                    elfCalories 
                    |> List.map List.sum
                    |> List.sortDesc

                highestCals = 
                    sortedCals
                    |> List.first
                    |> Result.map Num.toStr
                    |> Result.withDefault ""

                topThree = 
                    when sortedCals is
                        [first, second, third, ..] -> first + second + third |> Num.toStr
                        _ -> crash "should have more than three elves"
                
                "The highest calories is \(highestCals), and top three is \(topThree)"
                        
        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure err) -> Str.concat "Parsing failre: " err |> Stderr.line 
            Err (ParsingIncomplete err) -> Str.concat "Parsing incomplete: " (Str.joinWith err ",") |> Stderr.line 

    Task.onFail task \_ -> crash "Oops, something went wrong."

elfParser : Parser (List Str) (List U64)
elfParser =
    const (\foods -> \_ -> foods)
    |> keep (oneOrMore foodParser)
    |> keep emptyLineParser

foodParser : Parser (List Str) U64
foodParser =
    buildPrimitiveParser (\input ->
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
    buildPrimitiveParser (\input ->
        when List.first input is
            Ok value -> 
                if Str.isEmpty value then 
                    Ok { val : {}, input : List.dropFirst input }
                else
                    Err (ParsingFailure value)
            Err ListWasEmpty -> 
                Err (ParsingFailure "empty list")
    )
