app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.6.0/QOQW08n38nHHrVVkJNiPIjzjvbR3iMjXeFY5w1aT46w.tar.br",
        parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.2.0/dJQSsSmorujhiPNIvJKlQoI92RFIG_JQwUfIxZsCSwE.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Stderr,
        parser.Core.{Parser, parse, buildPrimitiveParser, keep, const, oneOrMore},
        "./input-day-1.txt" as fileContents : Str,
    ]
    provides [main] to pf

main =

    # note elf parser wants a trailing empty line to get the last elf
    input = Str.split fileContents "\n" |> List.append "" 
    parser = oneOrMore elfParser
    answer = 
        elfCalories <- parse parser input List.isEmpty |> Result.map 
        
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

elfParser : Parser (List Str) (List U64)
elfParser =
    const (\foods -> \_ -> foods)
    |> keep (oneOrMore foodParser)
    |> keep emptyLineParser

foodParser : Parser (List Str) U64
foodParser =
    input <- buildPrimitiveParser

    when List.first input is 
        Ok value -> 
            when Str.toU64 value is 
                Ok num -> Ok { val : num, input : List.dropFirst input 1 }
                Err _ -> Err (ParsingFailure value)
        Err ListWasEmpty -> 
            Err (ParsingFailure "empty list")
    

emptyLineParser : Parser (List Str) {}
emptyLineParser =
    input <- buildPrimitiveParser
    
    when List.first input is
        Ok value -> 
            if Str.isEmpty value then 
                Ok { val : {}, input : List.dropFirst input 1 }
            else
                Err (ParsingFailure value)
        Err ListWasEmpty -> 
            Err (ParsingFailure "empty list")
    
