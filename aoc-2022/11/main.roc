app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.1.0/xbO9bXdHi7E9ja6upN5EJXpDoYm7lwmJ8VzL7a5zhYE.tar.br",
        parser: "../Parser/main.roc",
    }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [ main, stateToStr ] to pf

main =

    {} <- part1 "Part 1 Sample:" { current : 0, monkeys : sampleMonkeys, roundsRemaining : 20 } |> Task.await
    {} <- part1 "Part 1 File Input:" { current : 0, monkeys : inputMonkeys, roundsRemaining : 20 } |> Task.await

    Stdout.line "Complete"

part1 : Str, _ -> Task {} []
part1 = \name, state ->
    state
    |> runRound 
    |> .monkeys
    |> Dict.toList
    |> List.map \(_, monkey) -> monkey.inspectionCount
    |> List.sortDesc
    |> \counts ->
        when counts is 
            [first, second, ..] -> (Num.toF64 first) * (Num.toF64 second)
            _ -> crash "expected more monkeys!!"
    |> Num.toStr
    |> \ans -> 
        Stdout.line "\(name) the level of monkey business is \(ans)"


Monkey : {
    items : List U64, 
    op : (U64 -> U64), 
    test : (U64 -> Nat), 
    inspectionCount : U16,
}

State : {
    roundsRemaining : Nat,
    current : Nat,
    monkeys : Dict Nat Monkey,
}

runRound : State -> State
runRound = \state ->
    if state.roundsRemaining == 0 then 
        state
    else     
        when Dict.get state.monkeys state.current is
            Err _ -> crash "couldn't find monkey"
            Ok currentMonkey ->  
                when List.first currentMonkey.items is
                    Err ListWasEmpty ->
                        # monkey has no more items start with the next monkey
                        # if we are on the last monkey then increment round
                        if state.current == Dict.len state.monkeys - 1 then
                            state
                            |> incrementCurrentMonkey
                            |> decrementRound
                            |> runRound
                        else
                            state
                            |> incrementCurrentMonkey
                            |> runRound
                        
                    Ok item -> 
                        # got an item, inspect it and throw to next monkey
                        itemToThrow = calcItemToThrow currentMonkey.op item                        
                        idToThrowItem = calcIdToThrow itemToThrow currentMonkey.test

                        state
                        |> updateMonkey state.current incrementInspection
                        |> updateMonkey state.current dropItem
                        |> updateMonkey idToThrowItem (receiveItem itemToThrow)
                        |> runRound

updateMonkey : State, Nat, ([Present Monkey, Missing] -> [Present Monkey, Missing]) -> State
updateMonkey = \state, id, updateFn ->
    {state & monkeys : Dict.update state.monkeys id updateFn}

incrementInspection : [Present Monkey, Missing] -> [Present Monkey, Missing]
incrementInspection = \m -> 
    when m is 
        Missing -> crash "expected monkey to bump inspection"
        Present monkey -> 
            Present {monkey & inspectionCount : monkey.inspectionCount + 1}

receiveItem : U64 -> ([Present Monkey, Missing] -> [Present Monkey, Missing])
receiveItem = \item -> \m -> 
    when m is 
        Missing -> crash "expected monkey to receive item"
        Present monkey -> 
            Present {monkey & items : List.append monkey.items item}

dropItem : [Present Monkey, Missing] -> [Present Monkey, Missing]
dropItem = \m ->
    when m is 
        Missing -> crash "expected monkey to bump inspection"
        Present monkey -> 
            Present {monkey & items : List.dropFirst monkey.items}

decrementRound : State -> State
decrementRound = \state -> {state & roundsRemaining : state.roundsRemaining - 1}

incrementCurrentMonkey : State -> State
incrementCurrentMonkey = \state -> 
    monkeyCount = Dict.len state.monkeys
    {state & current : (state.current + 1) % monkeyCount}

calcItemToThrow : (U64 -> U64), U64 -> U64
calcItemToThrow = \op, item -> item |> op |> \n -> n // 3

calcIdToThrow : U64, (U64 -> Nat) -> Nat
calcIdToThrow = \item, test -> test item 

expect calcItemToThrow (\n -> n * 19) 79 == 500
expect calcIdToThrow 500 (\n -> if n % 23 == 0 then 2 else 3) == 3
expect calcItemToThrow (\n -> n * 19) 98 == 620
expect calcIdToThrow 620 (\n -> if n % 23 == 0 then 2 else 3) == 3
expect  
    got = 
        { current : 0, monkeys : sampleMonkeys, roundsRemaining : 0 }
        |> updateMonkey 0 incrementInspection
        |> updateMonkey 0 (receiveItem 999)
        |> updateMonkey 0 dropItem
        |> updateMonkey 0 dropItem

    first = when Dict.get got.monkeys 0 is 
        Ok m -> m
        Err _ -> crash "expected a monkey"

    first.inspectionCount == 1 && List.first first.items == Ok 999

# Hardcoding this... wasted waaayyy too much time on parsers :D
sampleMonkeys : Dict Nat Monkey
sampleMonkeys = 
    Dict.empty {}
    |> Dict.insert 0 { items: [79,98], op : \n -> n * 19, test : \n -> if n % 23 == 0 then 2 else 3, inspectionCount : 0 }
    |> Dict.insert 1 { items: [54,65,75,74], op : \n -> n + 6, test : \n -> if n % 19 == 0 then 2 else 0, inspectionCount : 0 }
    |> Dict.insert 2 { items: [79,60,97], op : \n -> n * n, test : \n -> if n % 13 == 0 then 1 else 3, inspectionCount : 0 }
    |> Dict.insert 3 { items: [74], op : \n -> n + 3, test : \n -> if n % 17 == 0 then 0 else 1, inspectionCount : 0 }

# For debugging
stateToStr : State -> Str
stateToStr = \state ->
    round = Num.toStr state.roundsRemaining
    monkeys = 
        state.monkeys
        |> Dict.toList 
        |> List.map \(id, monkey) -> 
            idStr = Num.toStr id
            items = List.map monkey.items Num.toStr |> Str.joinWith ","
            inspectionCount = Num.toStr monkey.inspectionCount
            "        id:\(idStr), inspections:\(inspectionCount), items:[\(items)]"
        |> Str.joinWith "\n"

    "{\n    round:\(round),\n    monkeys:\n\(monkeys)\n}"


inputMonkeys : Dict Nat Monkey
inputMonkeys =
    Dict.empty {}
    |> Dict.insert 0 { items: [71, 56, 50, 73], op : \n -> n * 11, test : \n -> if n % 13 == 0 then 1 else 7, inspectionCount : 0 }
    |> Dict.insert 1 { items: [70, 89, 82], op : \n -> n + 1, test : \n -> if n % 7 == 0 then 3 else 6, inspectionCount : 0 }
    |> Dict.insert 2 { items: [52, 95], op : \n -> n * n, test : \n -> if n % 3 == 0 then 5 else 4, inspectionCount : 0 }
    |> Dict.insert 3 { items: [94, 64, 69, 87, 70], op : \n -> n + 2, test : \n -> if n % 19 == 0 then 2 else 6, inspectionCount : 0 }
    |> Dict.insert 4 { items: [98, 72, 98, 53, 97, 51], op : \n -> n + 6, test : \n -> if n % 5 == 0 then 0 else 5, inspectionCount : 0 }
    |> Dict.insert 5 { items: [79], op : \n -> n + 7, test : \n -> if n % 2 == 0 then 7 else 0, inspectionCount : 0 }
    |> Dict.insert 6 { items: [77, 55, 63, 93, 66, 90, 88, 71], op : \n -> n * 7, test : \n -> if n % 11 == 0 then 2 else 4, inspectionCount : 0 }
    |> Dict.insert 7 { items: [54, 97, 87, 70, 59, 82, 59], op : \n -> n + 8, test : \n -> if n % 17 == 0 then 1 else 3, inspectionCount : 0 }
    