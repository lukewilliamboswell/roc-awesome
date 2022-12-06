app "parser-explorations"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        Parser.Core.{ Parser, parse, const, skip, keep, many, buildPrimitiveParser },
        Parser.Str.{ codeunit },
        Json,
    ]
    provides [
        main,
    ] to pf

float : Parser (List U8) F64
float = 
    buildPrimitiveParser \input ->
        digitState = 
            List.walkUntil input initDigitState \state, elem ->
                when elem is 
                    '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' -> state |> pushDigit elem |> Continue
                    '.' -> 
                        if state.decimalPoint then 
                            Break state
                        else 
                            state |> pushDecimal |> Continue
                    '_' -> state |> pushUnderscore |> Continue
                    _ -> Break state
        
        when Decode.fromBytes digitState.digits Json.fromUtf8 is
            Ok n -> Ok { val: n, input: List.drop input digitState.length }
            Err _ -> Err (ParsingFailure "Not a float")

DigitState : {
    digits : List U8,
    length : Nat,
    decimalPoint : Bool,
}

initDigitState : DigitState
initDigitState = {
    digits : List.withCapacity 12,
    length : 0,
    decimalPoint : Bool.false
}

pushDigit : DigitState, U8 -> DigitState
pushDigit = \state, digit ->
    {state & length : state.length + 1, digits : List.append state.digits digit}

pushDecimal : DigitState -> DigitState 
pushDecimal = \state ->
    {state & length : state.length + 1, digits : List.append state.digits '.', decimalPoint : Bool.true}

pushUnderscore : DigitState -> DigitState
pushUnderscore = \state ->
    {state & length : state.length + 1}

main : Task {} []
main =
    input = Str.toUtf8 "   100_000.000_560     "
    parser = 
        const (\a -> a)
        |> skip (many (codeunit ' '))
        |> keep float
        |> skip (many (codeunit ' '))

    task =
        when parse parser input List.isEmpty is 
            Ok number -> 
                age = Num.toStr (number)
                Stdout.line "Decoded age as \(age)"
            Err (ParsingFailure msg) -> crash "Parsing failure \(msg)"
            Err (ParsingIncomplete _) -> crash "Parsing incomplete"

    Task.onFail task \_ -> crash "Oops, something went wrong."

