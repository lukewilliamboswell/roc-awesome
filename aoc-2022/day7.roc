app "app-aoc-2022-day-7"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        # pf.File,
        # pf.Path.{ Path },
        Parser.Core.{ Parser, parsePartial, parse, const,sepBy, oneOf,many,keep, skip, chompUntil, chompWhile },
        Parser.Str.{ string, codeunit },
        Decode,
        Json,
        TerminalColor.{Color, withColor},
    ]
    provides [
        main,
    ] to pf

main : Task {} []
main =

    task =
        # fileInput <- File.readUtf8 (Path.fromStr "input-day-5.txt") |> Task.map Str.toUtf8 |> Task.await
        {} <- process (withColor "Part 1 Sample\n" Green) sampleInput |> Task.await
        # {} <- process "Part 1 CrateMover9000 Input" fileInputStacks (many moveParser) fileInput moveOneAtATime |> Task.await
        # {} <- process "Part 2 CrateMover9001 Sample" sampleStacks (many moveParser) sampleInput moveMultipleAtOnce |> Task.await
        # {} <- process "Part 2 CrateMover9001 Input" fileInputStacks (many moveParser) fileInput moveMultipleAtOnce |> Task.await
        Stdout.line (withColor "Completed processing" Green)

    Task.onFail task \_ -> crash "Oops, something went wrong."

process : Str, List U8 -> Task {} []
process = \name, input ->
    # lineOutput = when parse lineOutputParser input List.isEmpty is
    #     Ok a -> a
    #     Err (ParsingFailure _) -> crash "Parsing sample failed"
    #     Err (ParsingIncomplete leftover) ->
    #         ls = leftover |> Str.fromUtf8 |> Result.withDefault ""
    #         crash "Parsing sample incomplete \(ls)"
    # # Used for debugging to print out the parsed instructions
    # # lines = 
    #     lineOutput 
    #     |> List.map lineToStr
    #     |> Str.joinWith "\n"
    
    # Stdout.line "\(name)\(lines)"
    Stdout.line ""

Name : List U8

nameToStr = \name -> when Str.fromUtf8 name is 
    Ok a -> a
    Err _ -> crash "couldn't convert name to string"

LineOutput : [
    ChangeDirectory Name,
    ChangeDirectoryOutOneLevel,
    ListDirectory, 
    DirectoryListing Name, 
    FileListing U128 Name,
]

# lineOutputParser =
#     lineContent = 
#         oneOf [
#             changeDirectoryParser,
#             listDirectoryParser,
#             directoryListingParser,
#             fileListingParser,
#         ]
    
#     lineEnding =
#         codeunit '\n'

#     sepBy lineContent lineEnding

expect 
    input = Str.toUtf8 "a\na"
    parser = sepBy (codeunit 'a') (codeunit '\n')
    expected = Ok { val : ['a','a'], input : [] }
    parsePartial parser input == expected

# Mostly used for debuggind and testing
lineToStr : LineOutput -> Str 
lineToStr = \line ->
    when line is 
        ChangeDirectoryOutOneLevel ->
            "$ cd .."
        ChangeDirectory name -> 
            n = nameToStr name
            "$ cd \(n)"
        ListDirectory -> 
            "$ ls"
        DirectoryListing name ->
            n = nameToStr name
            "dir \(n)"
        FileListing size name ->
            s = Num.toStr size
            n = nameToStr name
            "\(s) \(n)"

changeDirectoryParser : Parser (List U8) LineOutput
changeDirectoryParser =
    const (\target ->
        if target == ['.','.'] then 
            ChangeDirectoryOutOneLevel
        else 
            ChangeDirectory target
    )
    |> skip (string "$ cd \n")
    |> keep (chompUntil '\n')

expect 
    input = Str.toUtf8 "$ cd a.z"
    expected =  Ok { val : ChangeDirectory ['a','.','z'], input : ['\n'] }
    parsePartial changeDirectoryParser input == expected

# expect 
#     input = Str.toUtf8 "$ cd ..\n"
#     expected =  Ok { val : ChangeDirectoryOutOneLevel, input : ['\n'] }
#     parsePartial changeDirectoryParser input == expected

# expect 
#     input = Str.toUtf8 "$ cd \\"
#     expected =  Ok { val : ChangeDirectory ['\\'], input : [] }
#     parsePartial changeDirectoryParser input == expected

# listDirectoryParser : Parser (List U8) LineOutput
# listDirectoryParser =
#     const (\_-> ListDirectory)
#     |> keep (string "$ ls")
#     |> skip (chompUntil '\n')

# expect 
#     input = Str.toUtf8 "$ ls\nab"
#     expected =  Ok { val : ListDirectory, input : ['\n','a','b'] }
#     parsePartial listDirectoryParser input == expected

# directoryListingParser : Parser (List U8) LineOutput
# directoryListingParser =
#     const (\name -> DirectoryListing name)
#     |> skip (string "dir ")
#     |> keep (chompUntil '\n')

# expect 
#     input = Str.toUtf8 "dir z\n"
#     expected =  Ok { val : DirectoryListing ['z'], input : [] }
#     parsePartial directoryListingParser input == expected

# fileListingParser : Parser (List U8) LineOutput
# fileListingParser =
#     const (\sizeUtf8 -> \name ->
#         size = when Decode.fromBytes sizeUtf8 Json.fromUtf8 is
#             Ok n -> n 
#             Err _ -> crash "failed to parse size"

#         FileListing size name 
#     )
#     |> keep (chompWhile isDigit)
#     |> skip (string " ")
#     |> keep (chompUntil '\n')

# expect 
#     input = Str.toUtf8 "1234 abc"
#     expected = Ok { val : FileListing 1234 ['a','b','c'], input : [] }
#     parsePartial fileListingParser input == expected

# isDigit : U8 -> Bool
# isDigit = \char ->
#     when char is 
#         '0' | '1' | '2' | '3' | '4' | '5' |'6' | '7' | '8' | '9' -> Bool.true
#         _ -> Bool.false


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
    |> Str.toUtf8