app "app-aoc-2022-day-3"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.Core.{ Parser, parse, const, keep, many, buildPrimitiveParser },
    ]
    provides [main] to pf

main : Task {} []
main =
    task =
        fileContents <- File.readUtf8 (Path.fromStr "input-day-3.txt") |> Task.await
        input = Str.toUtf8 fileContents |> List.append '\n'
        # input = Str.toUtf8 "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw\n"
        parser = many rucksackParser
        answer =
            parse parser input List.isEmpty
            |> Result.map \rucksacks ->
                part1 =
                    rucksacks
                    |> List.map typesInBothCompartments
                    |> List.map getCommonItem
                    |> List.map itemPriority
                    |> List.sum
                    |> Num.toStr

                part2 =
                    rucksacks
                    |> groupRucksackIntoThrees []
                    |> List.map detectGroupType
                    |> List.map getCommonItem
                    |> List.map itemPriority
                    |> List.sum
                    |> Num.toStr

                "The sum of rucksack items part 1: \(part1), part 2: \(part2)"

        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure _) -> Stderr.line "Parsing failure"
            Err (ParsingIncomplete leftover) ->
                ls = leftover |> Str.fromUtf8 |> Result.withDefault ""

                Stderr.line "Parsing incomplete \(ls)"

    Task.onFail task \_ -> crash "Oops, something went wrong."

RuckSack : { leftCompartnent : List RuckSackItem, rightCompartnent : List RuckSackItem }
RuckSackGroup : { first : List RuckSackItem, second : List RuckSackItem, third : List RuckSackItem }
RuckSackItem : [LowerCase U8, UpperCase U8]

groupRucksackIntoThrees : List RuckSack, List RuckSackGroup -> List RuckSackGroup
groupRucksackIntoThrees = \rucksacks, groups ->
    when rucksacks is
        [first, second, third, ..] ->
            group = {
                first: List.concat first.leftCompartnent first.rightCompartnent,
                second: List.concat second.leftCompartnent second.rightCompartnent,
                third: List.concat third.leftCompartnent third.rightCompartnent,
            }

            groupRucksackIntoThrees (List.drop rucksacks 3) (List.append groups group)

        _ -> groups

itemPriority : RuckSackItem -> U64
itemPriority = \item ->
    when item is
        LowerCase char ->
            char - 'a' + 1 |> Num.toU64

        UpperCase char ->
            char - 'A' + 27 |> Num.toU64

typesInBothCompartments : RuckSack -> Set RuckSackItem
typesInBothCompartments = \{ leftCompartnent, rightCompartnent } ->
    left = Set.fromList leftCompartnent
    right = Set.fromList rightCompartnent

    Set.intersection right left

detectGroupType : RuckSackGroup -> Set RuckSackItem
detectGroupType = \{ first, second, third } ->
    List.walk
        first
        Set.empty
        \commonItems, item ->
            inSecond = List.contains second item
            inThird = List.contains third item

            if inSecond && inThird then
                Set.insert commonItems item
            else
                commonItems

rucksackParser : Parser (List U8) RuckSack
rucksackParser =
    const
        (\items -> \_ ->
                { before, others } = List.split items (List.len items // 2)

                { leftCompartnent: before, rightCompartnent: others }
        )
    |> keep (many rucksaskItemParser)
    |> keep (codepoint '\n')

rucksaskItemParser : Parser (List U8) RuckSackItem
rucksaskItemParser =
    buildPrimitiveParser \input ->
        when List.first input is
            Ok x ->
                if x >= 'a' && x <= 'z' then
                    Ok { val: LowerCase x, input: List.dropFirst input }
                else if x >= 'A' && x <= 'Z' then
                    Ok { val: UpperCase x, input: List.dropFirst input }
                else
                    Err (ParsingFailure "")

            Err ListWasEmpty ->
                Err (ParsingFailure "empty list")

codepoint : U8 -> Parser (List U8) U8
codepoint = \x ->
    buildPrimitiveParser \input ->
        when List.first input is
            Ok value ->
                if x == value then
                    Ok { val: x, input: List.dropFirst input }
                else
                    Err (ParsingFailure "")

            Err ListWasEmpty ->
                Err (ParsingFailure "empty list")

getCommonItem = \commonItems ->
    when (Set.toList commonItems |> List.first) is
        Ok value -> value
        Err _ -> crash "more than one common item"
