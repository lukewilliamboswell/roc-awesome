app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        Parser.Core.{ Parser, parsePartial, parse, map, many, oneOrMore, const, sepBy, oneOf, keep, skip, buildPrimitiveParser },
        Parser.Str.{ string, codeunit },
    ]
    provides [ main ] to pf

# CRASHES with 'internal error: entered unreachable code: symbol/layout `19.IdentId(52)`
# expect
#     got = parsePartial tokenP (Str.toUtf8 "new = old + 3")
#     got == Ok {val :[New, Equal, Old, Add, Number 3], input : []}

main : Task {} []
main =
    sampleMonkeys
    |> Dict.len
    |> Num.toStr
    |> \n -> "Number of monkeys \(n)"
    |> Stdout.line

monkeyP =
    const (\id -> \items -> \_func -> \_divisor -> \_trueMonkey -> \_falseMonkey -> {
        id,
        items : items, 
        op : \n -> n+1, # TODO fix me
        test : \n -> n-1, # TODO fix me
    })
    |> skip (string "Monkey ") 
    |> keep digits
    |> skip (string ":\n  Starting items: ")
    |> keep (sepBy digits (string ","))
    |> skip (string "\n  Operation: ")
    |> keep tokenP
    |> skip (string "\n  Test: divisible by ")
    |> keep (digits |> map Num.toI32)
    |> skip (string "\n    If true: throw to monkey ")
    |> keep digits
    |> skip (string "\n    If false: throw to monkey ")
    |> keep digits
    |> skip (string "\n\n")

sampleMonkeys = 
    when parse (many monkeyP) sampleInput List.isEmpty is  
        Ok monkeys ->
            dict, monkey <- List.walk monkeys Dict.empty 
            
            Dict.insert dict monkey.id monkey

        Err (ParsingFailure _) -> crash "Parsing sample failed"
        Err (ParsingIncomplete leftover) ->
            ls = leftover |> Str.fromUtf8 |> Result.withDefault ""
            crash "Parsing sample incomplete \(ls)"

sampleInput = 
    """
    Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1"  
    smaleMonkeys = parse sample
    """
    |> Str.toUtf8


Token : [New, Equal, Add, Times, Old, Number I32]

newP : Parser (List U8) Token
newP = string "new" |> map \_ -> New

equalP : Parser (List U8) Token
equalP = string "=" |> map \_ -> Equal

addP : Parser (List U8) Token
addP = string "+" |> map \_ -> Add

timesP : Parser (List U8) Token
timesP = string "*" |> map \_ -> Times

oldP : Parser (List U8) Token
oldP = string "old" |> map \_ -> Old

numberP : Parser (List U8) Token
numberP = digits |> map \n -> Number (Num.toI32 n)

anyTokenP : Parser (List U8) Token
anyTokenP = oneOf [newP, equalP, addP, timesP, oldP, numberP]

tokenP : Parser (List U8) (List Token)
tokenP = sepBy anyTokenP (codeunit ' ')

expect parsePartial newP (Str.toUtf8 "new") == Ok {val : New , input : []}
expect parsePartial equalP (Str.toUtf8 "=") == Ok {val : Equal , input : []}
expect parsePartial oldP (Str.toUtf8 "old") == Ok {val : Old , input : []}
expect parsePartial addP (Str.toUtf8 "+") == Ok {val : Add , input : []}
expect parsePartial timesP (Str.toUtf8 "*") == Ok {val : Times , input : []}
expect parsePartial numberP (Str.toUtf8 "32") == Ok {val : Number 32 , input : []}

# CUSTOM PARSERS
digits : Parser (List U8) Nat
digits =
    ds <- oneOrMore digit |> map
    
    List.walk ds 0 (\sum, d -> sum * 10 + d)

digit : Parser (List U8) Nat
digit =
    input <- buildPrimitiveParser

    first = List.first input
    rest = List.dropFirst input

    if first == Ok '0' then Ok { val: 0, input: rest }
    else if first == Ok '1' then Ok { val: 1, input: rest }
    else if first == Ok '2' then Ok { val: 2, input: rest }
    else if first == Ok '3' then Ok { val: 3, input: rest }
    else if first == Ok '4' then Ok { val: 4, input: rest }
    else if first == Ok '5' then Ok { val: 5, input: rest }
    else if first == Ok '6' then Ok { val: 6, input: rest }
    else if first == Ok '7' then Ok { val: 7, input: rest }
    else if first == Ok '8' then Ok { val: 8, input: rest }
    else if first == Ok '9' then Ok { val: 9, input: rest }
    else Err (ParsingFailure "not a number")