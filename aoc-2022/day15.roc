app "aoc-2022"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.2/3bKbbmgtIfOyC6FviJ9o8F8xqKutmXgjCJx3bMfVTSo.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        # pf.File,
        # pf.Path.{ Path },
        Parser.Core.{ Parser, parsePartial, parse, oneOrMore, maybe, const, sepBy, keep, skip, buildPrimitiveParser },
        Parser.Str.{ codeunit },
        Json,
        TerminalColor.{ Color, withColor },
    ]
    provides [ main, stateToStr ] to pf

main : Task {} []
main =

    task =
        part1 (withColor "Part 1 Sample:" Green) {initialState & data : sampleData} 10 |> Stdout.line

    Task.onFail task \_ -> crash "Oops, something went wrong."

initialState = {
    data : [],
    minX : 0, 
    maxX : 0,
    minY : 0,
    maxY : 0
}

part1 = \name, state, rowNumber ->
    
    sensorData =
        state 
        |> updateRanges
        |> calculateSensorRanges
        |> .data

    List.range {start : At state.minX, end : At state.maxX }
    |> List.map \x -> {x : x, y : rowNumber}
    |> checkSensorInRange sensorData
    |> Num.toStr 
    |> \answer -> "\(name) there are \(answer) positions where a beacon cannot be present."

checkSensorInRange = \dataPoints, sensorData ->
    List.walk dataPoints 0 \rowCount, {x,y} ->
        List.walk sensorData 0 \count, {sx, sy, range} ->

            pointToSensor = calculateDistance x y sx sy

            if range > pointToSensor then 
                # data point is in range of sensor, 
                # => a beacon cannot be present here
                count + 1
            else 
                count
        |> Num.add rowCount
    
    # TODO check if any beacons in this row??

calculateSensorRanges = \state ->
    data = 
        elem <- List.map state.data
        {elem & range : calculateDistance elem.sx elem.sy elem.bx elem.by}

    {state & data}

calculateDistance = \x1, y1, x2, y2 ->
    x = if x1 < x2 then x2 - x1 else x1 - x2
    y = if y1 < y2 then y2 - y1 else y1 - y2

    x + y

expect calculateDistance 0 0 6 6 == 12
expect calculateDistance -2 0 -8 6 == 12

updateRanges = \state ->
    
    sxRange = getMinMax state.data .sx  
    syRange = getMinMax state.data .sy  
    bxRange = getMinMax state.data .bx  
    byRange = getMinMax state.data .by

    xRanges = 
        [state.minX, state.maxX] 
        |> List.concat sxRange
        |> List.concat bxRange
        |> List.sortAsc
    
    yRanges = 
        [state.minY, state.maxY] 
        |> List.concat syRange
        |> List.concat byRange
        |> List.sortAsc

    minX = List.first xRanges |> Result.withDefault 0
    maxX = List.last xRanges |> Result.withDefault 0
    minY = List.first yRanges |> Result.withDefault 0
    maxY = List.last yRanges |> Result.withDefault 0
    
    {state & minX, maxX, minY, maxY}

testRanges = updateRanges {initialState & data : sampleData }

expect testRanges.minX == -2
expect testRanges.maxX == 25
expect testRanges.minY == 0
expect testRanges.maxY == 22

getMinMax = \data, selector ->
    sorted = 
        List.map data selector 
        |> List.sortAsc
    
    when sorted is 
        [smallest, .. ,biggest] -> [smallest, biggest]
        _ -> crash "expected more than two numbers"

expect
    result = getMinMax sampleData .bx
    result == [-2, 25]

sampleData =
    when parse inputParser (Str.toUtf8 sampleInput) List.isEmpty is 
        Ok data -> data 
        Err (ParsingFailure msg) -> crash "Oops, something went wrong parsing input:\(msg)"
        Err (ParsingIncomplete leftover) -> 
            l = leftover |> Str.fromUtf8 |> Result.withDefault "badUtf8"
            crash "Oops, didn't parse everything, leftover:\(l)"

expect List.get sampleData 0 == Ok {sx: 2, sy : 18, bx : -2, by : 15, range : 0}

inputParser =

    stuff = chompWhile (notDigitOrDash)
    
    line = 
        const (\sx -> \sy -> \bx -> \by ->
            {sx, sy, bx, by, range : 0}
        )
        |> skip stuff
        |> keep int 
        |> skip stuff
        |> keep int 
        |> skip stuff
        |> keep int 
        |> skip stuff
        |> keep int

    sepBy line (codeunit '\n')


sampleInput =
    """
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    """

chompWhile : (a -> Bool) -> Parser (List a) {} | a has Eq
chompWhile = \check ->
    input <- buildPrimitiveParser

    index = List.walkUntil input 0 \i, elem ->
        if check elem then 
            Continue (i + 1)
        else 
            Break i

    Ok {
        val : {},
        input : List.drop input index,
    }

notDigitOrDash = \i -> 
    when i is 
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' | '-' -> Bool.false
        _ -> Bool.true

expect 
    result = parsePartial (chompWhile (notDigitOrDash)) (Str.toUtf8 "abc -") 
    result == Ok {val : {}, input : ['-']}

digit : Parser (List U8) Nat
digit =
    input <- buildPrimitiveParser

    when input is
        [ c, .. ] if c >= '0' && c <= '9' -> Ok { val: Num.toNat (c - '0'), input: List.dropFirst input }
        _ -> Err (ParsingFailure "not a digit")
            
int : Parser (List U8) I64
int =
    const (\maybeDash -> \digits -> 
        sign = when maybeDash is 
            Ok _ -> -1
            Err _ -> 1
        
        List.walk digits 0 (\sum, d -> sum * 10 + d)
        |> Num.toI64
        |> Num.mul sign
    )
    |> keep (maybe (codeunit '-'))
    |> keep (oneOrMore digit)

expect 
    result = parsePartial int (Str.toUtf8 "-123456789abc") 
    result == Ok {val : -123456789i64, input : ['a', 'b', 'c']}

stateToStr = \state ->
    when Str.fromUtf8 (Encode.toBytes state Json.toUtf8) is 
        Ok str -> str
        Err _ -> crash "unable to encode state to Json"
