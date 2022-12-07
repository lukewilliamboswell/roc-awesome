app "app-aoc-2022-day-7"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        # pf.File,
        # pf.Path.{ Path },
        Parser.Core.{ Parser, parsePartial, parse, const, oneOf, keep, skip, chompUntil },
        Parser.Str.{ string, codeunit },
    ]
    provides [
        main,
    ] to pf

main : Task {} []
main =

    task =
        # sampleInput = Str.toUtf8 "move 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2"
        # fileInput <- File.readUtf8 (Path.fromStr "input-day-5.txt") |> Task.map Str.toUtf8 |> Task.await
        # {} <- process "Part 1 CrateMover9000 Sample" sampleStacks (many moveParser) sampleInput moveOneAtATime |> Task.await
        # {} <- process "Part 1 CrateMover9000 Input" fileInputStacks (many moveParser) fileInput moveOneAtATime |> Task.await
        # {} <- process "Part 2 CrateMover9001 Sample" sampleStacks (many moveParser) sampleInput moveMultipleAtOnce |> Task.await
        # {} <- process "Part 2 CrateMover9001 Input" fileInputStacks (many moveParser) fileInput moveMultipleAtOnce |> Task.await
        Stdout.line "Completed processing"

    Task.onFail task \_ -> crash "Oops, something went wrong."

sampleInput =
    """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """

Command : [ChangeDirectory (List U8), ListDirectory (List U8)]

commandParser : Parser (List U8) Command
commandParser =
    const
        (\cmd -> \target ->
            when cmd is
                "cd " -> ChangeDirectory target
                "ls " -> ListDirectory target
                _ -> crash "unable to recognise cmd"
        )
    |> skip (string "$ ")
    |> keep (oneOf [string "cd ", string "ls "])
    |> keep (chompUntil '\n')
    |> skip (codeunit '\n')

expect 
    input = Str.toUtf8 "$ cd a.z\n"
    expected =  Ok { val : ChangeDirectory ['a','.','z'], input : [] }
    parsePartial commandParser input == expected

expect 
    input = Str.toUtf8 "$ ls z\nabc"
    expected =  Ok { val : ListDirectory ['z'], input : ['a','b','c'] }
    parsePartial commandParser input == expected

# process = \name, stackStart, parser, input, moveFn ->
#     instructions = when parse parser input List.isEmpty is
#         Ok a -> a
#         Err (ParsingFailure _) -> crash "Parsing sample failed"
#         Err (ParsingIncomplete leftover) ->
#             ls = leftover |> Str.fromUtf8 |> Result.withDefault ""
#             crash "Parsing sample incomplete \(ls)"
#     # Used for debugging to print out the parsed instructions
#     # {} <- Stdout.line (instructionsToStr instructions) |> Task.await
#     answer =
#         List.walk instructions stackStart moveFn
#         |> stacksToStr
#     Stdout.line "\(name) stack after moving\n\(answer)"
