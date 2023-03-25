app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3/5CcipdhTTAtISf4FwlBNHmyu1unYAV8b0MKRwYiEHys.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{ Parser, parse, const, apply, many },
        Parser.Str.{ string, digits, codeunit },
    ]
    provides [
        main,
        instructionsToStr, # only needed for debugging, putting here to silence warning
    ] to pf

MoveInstruction : { count : Nat, fromIndex : Nat, toIndex : Nat }
Stack : List Str

# Hardcode stack starting state becuase this looks like a challenge to parse 
#     [D]
# [N] [C]
# [Z] [M] [P]
#  1   2   3
sampleStacks =
    Dict.empty {}
    |> Dict.insert 1 (["Z", "N"] |> List.reverse)
    |> Dict.insert 2 (["M", "C", "D"] |> List.reverse)
    |> Dict.insert 3 (["P"])

#         [G]         [D]     [Q]
# [P]     [T]         [L] [M] [Z]
# [Z] [Z] [C]         [Z] [G] [W]
# [M] [B] [F]         [P] [C] [H] [N]
# [T] [S] [R]     [H] [W] [R] [L] [W]
# [R] [T] [Q] [Z] [R] [S] [Z] [F] [P]
# [C] [N] [H] [R] [N] [H] [D] [J] [Q]
# [N] [D] [M] [G] [Z] [F] [W] [S] [S]
#  1   2   3   4   5   6   7   8   9
fileInputStacks =
    Dict.empty {}
    |> Dict.insert 1 (["N", "C", "R", "T", "M", "Z", "P"] |> List.reverse)
    |> Dict.insert 2 (["D", "N", "T", "S", "B", "Z"] |> List.reverse)
    |> Dict.insert 3 (["M", "H", "Q", "R", "F", "C", "T", "G"] |> List.reverse)
    |> Dict.insert 4 (["G", "R", "Z"] |> List.reverse)
    |> Dict.insert 5 (["Z", "N", "R", "H"] |> List.reverse)
    |> Dict.insert 6 (["F", "H", "S", "W", "P", "Z", "L", "D"] |> List.reverse)
    |> Dict.insert 7 (["W", "D", "Z", "R", "C", "G", "M"] |> List.reverse)
    |> Dict.insert 8 (["S", "J", "F", "L", "H", "W", "Z", "Q"] |> List.reverse)
    |> Dict.insert 9 (["S", "Q", "P", "W", "N"] |> List.reverse)

main : Task {} []
main =

    task =
        sampleInput = Str.toUtf8 "move 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2"
        fileInput <- File.readUtf8 (Path.fromStr "input-day-5.txt") |> Task.map Str.toUtf8 |> Task.await

        {} <- process "Part 1 CrateMover9000 Sample" sampleStacks (many moveParser) sampleInput moveOneAtATime |> Task.await
        {} <- process "Part 1 CrateMover9000 Input" fileInputStacks (many moveParser) fileInput moveOneAtATime |> Task.await
        {} <- process "Part 2 CrateMover9001 Sample" sampleStacks (many moveParser) sampleInput moveMultipleAtOnce |> Task.await
        {} <- process "Part 2 CrateMover9001 Input" fileInputStacks (many moveParser) fileInput moveMultipleAtOnce |> Task.await

        Stdout.line "Completed processing"

    Task.onFail task \_ -> crash "Oops, something went wrong."

process = \name, stackStart, parser, input, moveFn ->
    instructions = when parse parser input List.isEmpty is
        Ok a -> a
        Err (ParsingFailure _) -> crash "Parsing sample failed"
        Err (ParsingIncomplete leftover) ->
            ls = leftover |> Str.fromUtf8 |> Result.withDefault ""

            crash "Parsing sample incomplete \(ls)"

    # Used for debugging to print out the parsed instructions
    # {} <- Stdout.line (instructionsToStr instructions) |> Task.await

    answer =
        List.walk instructions stackStart moveFn
        |> stacksToStr

    Stdout.line "\(name) stack after moving\n\(answer)"

# implement stack operations
pop : Stack -> { stack : Stack, value : Str }
pop = \stack ->
    when List.first stack is
        Ok value -> { stack: List.dropFirst stack, value }
        Err _ -> crash "invalid movement, popping empty stack"

push : Stack, Str -> Stack
push = \stack, value ->
    List.prepend stack value

expect pop ["D", "C", "M"] == { stack: ["C", "M"], value: "D" }
expect push ["C", "M"] "D" == ["D", "C", "M"]

moveMultipleAtOnce : Dict Nat Stack, MoveInstruction -> Dict Nat Stack
moveMultipleAtOnce = \stacks, { count, fromIndex, toIndex } ->
    fromStack =
        when Dict.get stacks fromIndex is
            Ok a -> a
            Err _ -> crash "getting empty from stack"

    toStack =
        when Dict.get stacks toIndex is
            Ok a -> a
            Err _ -> crash "getting empty to stack"

    values = List.takeFirst fromStack count

    updatedFromStack = List.drop fromStack count
    updatedToStack = List.concat values toStack

    stacks
    |> Dict.insert fromIndex updatedFromStack
    |> Dict.insert toIndex updatedToStack

moveOneAtATime : Dict Nat Stack, MoveInstruction -> Dict Nat Stack
moveOneAtATime = \stacks, { count, fromIndex, toIndex } ->
    if count == 0 then
        stacks
    else
        when Dict.get stacks fromIndex is
            Err _ ->
                ss = stacksToStr stacks
                id = Num.toStr fromIndex

                crash "invalid move from stack index \(id), stacks \(ss)"

            Ok a if List.len a == 0 ->
                stacks # trying to move from an empty stack, do nothing

            Ok fromStack ->
                toStack =
                    when Dict.get stacks toIndex is
                        Ok a -> a
                        Err _ -> []
                # id = Num.toStr toIndex
                # crash "invalid move to stack index \(id)"
                { stack: updatedFromStack, value } = pop fromStack
                updatedToStack = push toStack value

                updatedStacks =
                    stacks
                    |> Dict.insert fromIndex updatedFromStack
                    |> Dict.insert toIndex updatedToStack

                moveOneAtATime updatedStacks { count: count - 1, fromIndex, toIndex }

moveParser : Parser (List U8) MoveInstruction
moveParser =
    const (\_ -> \_ -> \count -> \_ -> \fromIndex -> \_ -> \toIndex -> { count, fromIndex, toIndex })
    |> apply (many (codeunit '\n'))
    |> apply (string "move ")
    |> apply (digits)
    |> apply (string " from ")
    |> apply (digits)
    |> apply (string " to ")
    |> apply (digits)

expect
    result = parse moveParser (Str.toUtf8 "move 1 from 2 to 1") List.isEmpty
    result == Ok { count: 1, fromIndex: 2, toIndex: 1 }


# Helpers for debugging to pretty print
stacksToStr : Dict Nat Stack -> Str
stacksToStr = \stacks ->
    state, k, v <- Dict.walk stacks ""
    
    stackNumber = Num.toStr k
    stackContents =
        v
        |> List.reverse
        |> List.map \x -> Str.joinWith ["[", x, "]"] ""
        |> Str.joinWith ","

    Str.concat state "\(stackNumber) : \(stackContents)\n"

instructionsToStr : List MoveInstruction -> Str
instructionsToStr = \instructions ->
    instructions
    |> List.map \{ count, fromIndex, toIndex } ->
        c = Num.toStr count
        fi = Num.toStr fromIndex
        ti = Num.toStr toIndex

        "move \(c) from \(fi) to \(ti)"
    |> Str.joinWith "\n"
