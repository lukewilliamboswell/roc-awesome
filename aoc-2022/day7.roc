app "app-aoc-2022-day-7"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{ Parser, parsePartial, parse, const, sepBy, oneOf, keep, skip, chompUntil, chompWhile },
        Parser.Str.{ string, codeunit },
        Decode,
        Json,
        TerminalColor.{ Color, withColor },
    ]
    provides [
        main,
    ] to pf

main : Task {} []
main =

    task =
        fileInput <- File.readUtf8 (Path.fromStr "input-day-7.txt") |> Task.map Str.toUtf8 |> Task.await
        {} <- process (withColor "Part 1 Sample:" Green) sampleInput part1 |> Task.await
        {} <- process (withColor "Part 1 File Input:" Green) fileInput part1 |> Task.await
        # {} <- process "Part 2 CrateMover9001 Sample" sampleStacks (many moveParser) sampleInput moveMultipleAtOnce |> Task.await
        # {} <- process "Part 2 CrateMover9001 Input" fileInputStacks (many moveParser) fileInput moveMultipleAtOnce |> Task.await
        Stdout.line "Completed processing"

    Task.onFail task \_ -> crash "Oops, something went wrong."

# process : Str, List U8, (FileSystem -> U64) -> Task {} []
process = \name, input, calc ->
    lineOutput = when parse lineOutputParser input List.isEmpty is
        Ok a -> a
        Err (ParsingFailure _) -> crash "Parsing sample failed"
        Err (ParsingIncomplete leftover) ->
            ls = leftover |> Str.fromUtf8 |> Result.withDefault ""
            crash "Parsing sample incomplete \(ls)"
    
    # lines =
    #     lineOutput
    #     |> List.map lineToStr
    #     |> Str.joinWith "\n"
    # lineCount = lineOutput |> List.len |> Num.toStr
    # {} <- Stdout.line "LINE COUNT:\(lineCount)" |> Task.await

    answer = 
        buildDirectoryListing lineOutput
        |> calc
        |> Num.toStr

    Stdout.line "\(name)\(answer)"

part1 : FileSystem -> U64
part1 = \fs ->
    fs 
    |> Dict.values
    |> List.keepOks \{type} -> 
        when type is 
            Folder name -> Ok (dirSize fs name)
            _ -> Err ""
    |> List.keepIf \size -> size <= 100_000
    |> List.sum

FileSystem : Dict Str {
    parent : Str,
    type : [File U64 Str, Folder Str]
}

Context : {
    cwd : Str,
    fs : FileSystem,
}

root : Str 
root = "/"

dirSize : FileSystem, Str -> U64
dirSize = \fs, name ->
    fs
    |> Dict.values 
    |> List.keepOks \{parent, type} ->
        if parent == name then 
            when type is 
                File size _ -> Ok size
                Folder name2 -> Ok (dirSize fs name2)
        else
            Err "not subdirectory"
    |> List.sum

buildDirectoryListing : List LineOutput -> FileSystem 
buildDirectoryListing = \lineOutputs ->
    startingFs =
        Dict.empty 
        |> Dict.insert root {parent : "", type : Folder root}
    
    state = 
        List.walk 
            lineOutputs 
            { cwd : root, fs : startingFs }
            reduceFileSystem

    state.fs

reduceFileSystem : Context, LineOutput -> Context
reduceFileSystem = \{cwd, fs}, line ->
    when line is
        ChangeDirectory name -> 
            {cwd : name, fs}
        ChangeDirectoryOutOneLevel ->
            when Dict.get fs cwd is 
                Ok current -> {cwd : current.parent, fs}
                Err _ -> crash "couldn't find directory"
        DirectoryListing name -> 
            xfs = Dict.insert fs name {parent : cwd, type : Folder name}
            {cwd, fs : xfs}
        FileListing size name ->
            xfs = Dict.insert fs name {parent : cwd, type : File size name}
            {cwd, fs : xfs}
        _ -> 
            {cwd, fs}

LineOutput : [
    ChangeDirectory Str,
    ChangeDirectoryOutOneLevel,
    ListDirectory,
    DirectoryListing Str,
    FileListing U64 Str,
]

lineOutputParser =
    lineContent =
        oneOf [
            changeDirectoryParser,
            listDirectoryParser,
            directoryListingParser,
            fileListingParser,
        ]

    lineEnding =
        codeunit '\n'

    sepBy lineContent lineEnding

# For debuggind and testing
# lineToStr : LineOutput -> Str
# lineToStr = \line ->
#     when line is
#         ChangeDirectoryOutOneLevel -> "$ cd .."
#         ChangeDirectory name -> "$ cd \(name)"
#         ListDirectory -> "$ ls"
#         DirectoryListing name -> "dir \(name)"
#         FileListing size name ->
#             s = Num.toStr size
#             "\(s) \(name)"

changeDirectoryParser : Parser (List U8) LineOutput
changeDirectoryParser =
    const
        (\target ->
            if target == ['.', '.'] then
                ChangeDirectoryOutOneLevel
            else
                ChangeDirectory (strOrCrash target)
        )
    |> skip (string "$ cd ")
    |> keep (chompWhile isPermittedFileName)

expect
    input = Str.toUtf8 "$ cd a\n"
    expected = Ok { val: ChangeDirectory "a", input: ['\n'] }
    parsePartial changeDirectoryParser input == expected

expect
    input = Str.toUtf8 "$ cd ..\n"
    expected = Ok { val: ChangeDirectoryOutOneLevel, input: ['\n'] }

    parsePartial changeDirectoryParser input == expected

expect
    input = Str.toUtf8 "$ cd /"
    expected = Ok { val: ChangeDirectory root, input: [] }

    parsePartial changeDirectoryParser input == expected

listDirectoryParser : Parser (List U8) LineOutput
listDirectoryParser =
    const (\_ -> ListDirectory)
    |> keep (string "$ ls")
    |> skip (chompUntil '\n')

expect
    input = Str.toUtf8 "$ ls\nab"
    expected = Ok { val: ListDirectory, input: ['\n', 'a', 'b'] }

    parsePartial listDirectoryParser input == expected

directoryListingParser : Parser (List U8) LineOutput
directoryListingParser =
    const (\name -> DirectoryListing (strOrCrash name))
    |> skip (string "dir ")
    |> keep (chompWhile isPermittedFileName)

expect
    input = Str.toUtf8 "dir z\n"
    expected = Ok { val: DirectoryListing "z", input: ['\n'] }
    parsePartial directoryListingParser input == expected

fileListingParser : Parser (List U8) LineOutput
fileListingParser =
    const
        (\sizeUtf8 -> \name ->
                size = when Decode.fromBytes sizeUtf8 Json.fromUtf8 is
                    Ok n -> n
                    Err _ -> crash "failed to parse size"

                FileListing size (strOrCrash name)
        )
    |> keep (chompWhile isDigit)
    |> skip (string " ")
    |> keep (chompWhile isPermittedFileName)

expect
    input = Str.toUtf8 "1234 abc"
    expected = Ok { val: FileListing 1234 "abc", input: [] }

    parsePartial fileListingParser input == expected

isDigit : U8 -> Bool
isDigit = \char ->
    when char is
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> Bool.true
        _ -> Bool.false

isPermittedFileName : U8 -> Bool
isPermittedFileName = \char ->
    lowercase = char >= 'a' && char <= 'z'
    uppercase = char >= 'A' && char <= 'Z'
    decimal = char == '.'
    slash = char == '/'

    if lowercase || uppercase || decimal || slash then
        Bool.true
    else
        Bool.false

expect List.map ['a', '.', 'z', '\n'] isPermittedFileName == [Bool.true, Bool.true, Bool.true, Bool.false]

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

strOrCrash : List U8 -> Str 
strOrCrash = \input ->
    when (Str.fromUtf8 input) is 
        Ok str -> str
        Err _ -> crash "couldn't make string"