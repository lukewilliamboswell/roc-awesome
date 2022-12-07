app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        # pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        # Parser.{ Parser, const, apply, many, map, oneOrMore, buildPrimitiveParser },
        Day5,   
    ]
    provides [main] to pf

# Path.fromStr "input-day-4.txt"

PuzzleSetup : {
    name : Str, 
    sampleInput : Str, 
    sampleAnswer : Str, 
    fileInput : Str,
    part1 : List U8 -> Result Str Str,
    part2 : List U8 -> Result Str Str,
}

puzzleSetup : Dict Nat PuzzleSetup
puzzleSetup = 
    Dict.empty
    |> Dict.insert 5 {
        name : "Day 5", 
        sampleInput :  "    [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 \n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2", 
        sampleAnswer : "CMZ", 
        fileInput : "input-day-5.txt",
        part1 : Day5.part1,
        part2 : Day5.part2,
    }

main : Task {} []
main =

    day = when Dict.get puzzleSetup 5 is    
            Ok x -> x
            Err _ -> crash "failed to load puzzle setup"

    {} <- part1 day |> Task.await

    Stdout.line ""
    
part1Sample : PuzzleSetup -> Task {} [] 
part1Sample = \setup ->
    (when setup.part1 (Str.toUtf8 setup.sampleInput) is 
        Ok result -> "PASS \(setup.name) Part 1 sample input; answer is \(result)"
        Err msg -> "FAIL \(setup.name) Part 1; \(msg)")
    |> Stdout.line

    # task = part1 day
        # day = {
        #     name : "Day 5", 
        #     sampleInput :  "    [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 \n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2", 
        #     sampleAnswer : "CMZ", 
        #     fileInput : "input-day-5.txt",
        #     part1 : Day5.part1,
        #     part2 : Day5.part2,
        # }

        # Load files from memory
        # fileContents <- File.readUtf8 (Path.fromStr day.fileInput) |> Task.map Str.toUtf8 |> Task.await
        # {} <- Stdout.line "Results for Advent of Code 2022\n-------------------------------" |> Task.await

        # Run Part 1 Sample
        # msgPart1 =
        #     when day.part1 (Str.toUtf8 day.sampleInput) is 
        #         Ok result -> "PASS \(day.name) Part 1 sample input; answer is \(result)"
        #         Err msg -> "FAIL \(day.name) Part 1; \(msg)"
                
        # {} <- Stdout.line msgPart1 |> Task.await

        # Run Part 1 File Input
        # resultPart1File = day.part1 fileContents
        # {} <- Stdout.line "ANSWER \(day.name) Part 1 for file input is \(resultPart1File)" |> Task.await
        

        # Run Part 2 Sample

        # Run Part 2 File Input
        # Stdout.line "success"
    
