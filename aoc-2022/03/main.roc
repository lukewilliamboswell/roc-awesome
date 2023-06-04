app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
        parser: "../Parser/main.roc",
    }
    imports [
        pf.Stdout,
        pf.Stderr,
        parser.Core.{ Parser, parse, const, keep, many, buildPrimitiveParser },
        "./input-day-3.txt" as fileContents : List U8,
    ]
    provides [main] to pf

main = 
    input = fileContents |> List.append '\n'
    parser = many rucksackParser
    answer = 
        rucksacks <- parse parser input List.isEmpty |> Result.map 

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
    commonItems, item <- List.walk first (Set.empty {})
        
    inSecond = List.contains second item
    inThird = List.contains third item

    if inSecond && inThird then
        Set.insert commonItems item
    else
        commonItems

rucksackParser : Parser (List U8) RuckSack
rucksackParser =
    const (\items -> \_ ->
                { before, others } = List.split items (List.len items // 2)

                { leftCompartnent: before, rightCompartnent: others }
    )
    |> keep (many rucksaskItemParser)
    |> keep (codepoint '\n')

rucksaskItemParser : Parser (List U8) RuckSackItem
rucksaskItemParser =
    input <- buildPrimitiveParser
    
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
    input <- buildPrimitiveParser
    
    when List.first input is
        Ok value ->
            if x == value then
                Ok { val: x, input: List.dropFirst input }
            else
                Err (ParsingFailure "")

        Err ListWasEmpty ->
            Err (ParsingFailure "empty list")

getCommonItem = \commonItems ->
    when commonItems |> Set.toList |> List.first is
        Ok value -> value
        Err _ -> crash "more than one common item"
