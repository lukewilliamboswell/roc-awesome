app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [ main ] to pf

main : Task {} []
main =
    
    dbg (round { current : 0, monkeys : sampleMonkeys, round : 0 })
    # |> .monkeys
    # |> Dict.toList
    # |> List.map \T _ monkey -> monkey.inspectionCount
    # |> List.sortDesc
    # |> \counts ->
    #     when counts is 
    #         [first, second, ..] -> first*second
    #         _ -> crash "expected more monkeys!!"
    # |> Num.toStr
    # |> \ans -> Stdout.line "Part 1 Sample: the level of monkey business is \(ans)"

    Stdout.line "h"

# Hardcoding this... wasted waaayyy too much time on parsers :D
sampleMonkeys = 
    Dict.empty 
    |> Dict.insert 0 { items: [79,98], op : \n -> n * 19, test : \n -> if n % 23 == 0 then 2 else 3, inspectionCount : 0 }
    |> Dict.insert 1 { items: [54,65,75,74], op : \n -> n + 6, test : \n -> if n % 19 == 0 then 2 else 0, inspectionCount : 0 }
    |> Dict.insert 2 { items: [79,60,97], op : \n -> n * n, test : \n -> if n % 13 == 0 then 1 else 3, inspectionCount : 0 }
    |> Dict.insert 3 { items: [74], op : \n -> n + 3, test : \n -> if n % 17 == 0 then 0 else 1, inspectionCount : 0 }

Monkey : {items : List U64, op : (U64 -> U64), test : (U64 -> Nat), inspectionCount : U64 }
State : {
    round : Nat,
    current : Nat,
    monkeys : Dict Nat Monkey,
}

updateMonkey : State, Nat, ([Present Monkey, Missing] -> [Present Monkey, Missing]) -> State 
updateMonkey = \state, id, updateFn ->
    {state & monkeys : Dict.update state.monkeys id updateFn}

round : State -> State
round = \state ->
    if state.round >= 20 then 
        state
    else     
        # number of monkeys 
        monkeyCount = Dict.len state.monkeys

        # get the current monkey
        currentMonkey = monkeyOrCrash state.monkeys state.current

        when List.first currentMonkey.items is 
            Err _ ->
                # monkey has no more items increment round
                round {state & current : (state.current + 1) % monkeyCount, round : state.round + 1}
                
            Ok item -> 
                itemToThrow =
                    item 
                    |> currentMonkey.op
                    |> \n -> n // 3
                
                idToThrowItem = 
                    itemToThrow
                    |> currentMonkey.test

                updatedState = 
                    state
                    |> updateMonkey state.current bumpInspectionCount
                    |> updateMonkey state.current dropItemFromList
                    |> updateMonkey idToThrowItem (receiveItem itemToThrow)
                
                round {updatedState & round : state.round + 1}
                    
monkeyOrCrash = \monkeys, id ->
    when Dict.get monkeys id is 
        Ok m -> m 
        Err _ -> crash "couldn't find monkey"
    
bumpInspectionCount = \m -> 
    when m is 
        Present monkey -> Present {monkey & inspectionCount : monkey.inspectionCount + 1}
        Missing -> crash "expected monkey to bump inspection"

receiveItem = \item -> \m -> 
    when m is 
        Missing -> crash "expected monkey to receive item"
        Present monkey -> Present {monkey & items : List.append monkey.items item}

dropItemFromList = \m -> 
    when m is 
        Present monkey -> Present {monkey & items : List.dropFirst monkey.items}
        Missing -> crash "expected monkey to bump inspection"
