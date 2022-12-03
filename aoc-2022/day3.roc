app "app-aoc-2022-day-3"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path.{ Path },
        Parser.{ Parser, const, apply, many, buildPrimitiveParser },
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
            Parser.parse parser input List.isEmpty
            |> Result.map \rucksacks ->
                sum =
                    rucksacks
                    |> List.map typesInBothCompartments
                    |> List.map \commonItems ->
                        when Set.toList commonItems is
                            [first] -> first
                            _ ->
                                items =
                                    commonItems
                                    |> Set.toList
                                    |> List.map rucksackToStr
                                    |> Str.joinWith ","

                                crash (Str.concat "more than one common item" items)
                    |> List.map itemPriority
                    |> List.sum
                    |> Num.toStr

                "The sum of rucksack commoin items is \(sum) "

        when answer is
            Ok msg -> Stdout.line msg
            Err (ParsingFailure _) -> Stderr.line "Parsing failure"
            Err (ParsingIncomplete leftover) ->
                ls = leftover |> Str.fromUtf8 |> Result.withDefault ""

                Stderr.line "Parsing incomplete \(ls)"

    Task.onFail task \_ -> crash "Oops, something went wrong."

itemPriority : RuckSackItem -> U64
itemPriority = \item ->
    when item is
        LowerCase char ->
            char - 'a' + 1 |> Num.toU64

        UpperCase char ->
            char - 'A' + 27 |> Num.toU64

typesInBothCompartments : { leftCompartnent : List RuckSackItem, rightCompartnent : List RuckSackItem } -> Set RuckSackItem
typesInBothCompartments = \{ leftCompartnent, rightCompartnent } ->
    # Wanted to use Set.intersection but I think it is blocked on [#4415](https://github.com/roc-lang/roc/pull/4415)
    List.walk
        leftCompartnent
        Set.empty
        \commonItems, item ->
            if List.contains rightCompartnent item then
                Set.insert commonItems item
            else
                commonItems

rucksackParser : Parser (List U8) { leftCompartnent : List RuckSackItem, rightCompartnent : List RuckSackItem }
rucksackParser =
    const
        (\items -> \_ ->
                { before, others } = List.split items (List.len items // 2)

                { leftCompartnent: before, rightCompartnent: others }
        )
    |> apply (many rucksaskItemParser)
    |> apply (codepoint '\n')

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

RuckSackItem : [LowerCase U8, UpperCase U8]

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

rucksackToStr : RuckSackItem -> Str
rucksackToStr = \item ->
    when item is
        UpperCase char ->
            Str.fromUtf8 [char] |> Result.withDefault ""

        LowerCase char ->
            Str.fromUtf8 [char] |> Result.withDefault ""
