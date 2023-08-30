app "aoc"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Task.{await},
        "./input.txt" as fileInput : List U8,
    ]
    provides [main] to pf

# Allocate enough nodes to hold the input which represents the heightmap
estimated = 3500 

Node : (I32, I32) # row col

State : {
    heights : Dict Node U8, # Height of each node, used to determine if we can move to it
    unvisited : Dict Node U16, # Nodes that haven't been 'visited' by Dijkstra's yet
    visited : Dict Node U16, # Nodes that have been 'visited' 
    previous : Dict Node Node, # Previous node in the shortest path
    start : Node,
    end : Node,
    rows: U8,
    cols: U8,
}

sampleInput =
    """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

main =
    initialState = {
        heights: Dict.withCapacity estimated,
        unvisited: Dict.withCapacity estimated,
        visited: Dict.withCapacity estimated,
        previous: Dict.withCapacity estimated,
        start: (0,0),
        end: (0,0),
        rows: 1, 
        cols: 0, 
    }

    # part1SampleAnswer = part1 (Str.toUtf8 sampleInput) initialState
    # part1FileAnswer = part1 fileInput initialState
    part2SampleAnswer = part2 (Str.toUtf8 sampleInput) initialState

    # {} <- Stdout.line part1SampleAnswer |> Task.await
    # {} <- Stdout.line part1FileAnswer |> Task.await
    {} <- Stdout.line part2SampleAnswer |> Task.await

    Task.succeed {}

    
part1 = \inputBytes, initialState ->

    # Parse the map state
    state = parseMap inputBytes initialState 0 0

    # Dijkstra's starting at Start
    final = mainHelp state state.start

    # Get the shortest path
    shortest = shortestHelp final.previous final.heights final.end []

    shortestSteps = 
        shortest
        |> List.len 
        |> Num.toStr
    
    "Part 1 - Shortest steps is: \(shortestSteps)"

part2 = \inputBytes, initialState ->

    # Parse the map state
    state = parseMap inputBytes initialState 0 0

    # Dijkstra's starting at Start
    final = mainHelp state state.start

    # Debug the previous state 
    # xxx = 
    #     Dict.toList final.previous
    #     |> List.map \(f, t) -> {f, t }
    # dbg xxx

    # Get the shortest path
    shortest = shortestHelp final.previous final.heights final.end []

    dbg shortest

    shortestSteps = 
        shortest
        |> List.walkUntil 0 \count, height ->
            if height == 0 then 
                Break (count + 1)
            else 
                Continue (count + 1)
        |> Num.toStr
    
    "Part 2 - Shortest steps is: \(shortestSteps)"

shortestHelp : Dict Node Node, Dict Node U8,  Node, List U8 -> List U8
shortestHelp = \previousNodes, heights, current, steps ->
    when (Dict.get previousNodes current, Dict.get heights current) is 
        (Ok previous, Ok height) -> 
            shortestHelp previousNodes heights previous (List.append steps height)
        (_,_) -> steps

mainHelp : State, Node -> State
mainHelp = \state, currentNode -> 
    if currentNode == state.end then
        state
    else 
        # Current node distance
        currentDistance = 
            state.unvisited
            |> Dict.get currentNode 
            |> Result.withDefault Num.maxU16

        # Get the neighbors of the current node
        neighbors = getNeighbors state.heights currentNode

        # Get the distance of each neighbor
        neighborChanges = 
            neighbor <- List.map neighbors 

            when Dict.get state.unvisited neighbor is 
                Err _ -> 
                    # Neighbor has already been visited
                    {neighbor, neighborChange: NoUpdate}
                Ok neighborDistance ->      
                    # If the neighbor's distance is greater than the current node's distance + 1
                    # then update the neighbor's distance
                    if neighborDistance > (currentDistance + 1) then
                        {neighbor, neighborChange: UpdateTo (currentDistance + 1)}
                    else
                        {neighbor, neighborChange: NoUpdate}
        
        # Update the neighbors' distances
        {unvisited: updatedUnvisitedNeighbors, previous: updatedPrevious} = 
            neighborChanges
            |> List.walk {unvisited: state.unvisited, previous: state.previous} \interimState, {neighbor, neighborChange} ->
                # Update the neighbor's distance
                when neighborChange is 
                    UpdateTo newDistance ->
                        {
                            unvisited: Dict.insert interimState.unvisited neighbor newDistance, 
                            previous: Dict.insert interimState.previous neighbor currentNode,
                        }
                    NoUpdate ->
                        interimState
                
                
        # Mark the current node as visited
        updatedUnvisitedCurrent =
            Dict.remove updatedUnvisitedNeighbors currentNode 

        updatedVisited = 
            Dict.insert state.visited currentNode currentDistance

        updatedState = { state & 
            unvisited: updatedUnvisitedCurrent,
            visited: updatedVisited,
            previous: updatedPrevious,
        }

        # Find the next lowest unvisited node
        lowest = lowestUnvisited updatedState.unvisited

        # Repeat until we've visited the end node
        mainHelp updatedState lowest

getNeighbors : Dict Node U8, Node -> List Node
getNeighbors = \heights, current -> 
    row = current.0 
    col = current.1

    # Consider all four directions, up, down, left, right
    [(row-1, col), (row+1, col), (row, col-1), (row, col+1)] 
    |> List.keepOks \possibleNode ->
        # Step 1 -> Check other node is in bounds
        if Dict.contains heights possibleNode then
            Ok possibleNode
        else 
            Err "node not in map"
    |> List.keepOks \possibleNode ->
        # Step 2 -> Check other node height at most one higher than current
        currentHeight = Dict.get heights current |> Result.withDefault 0
        possibleHeight = Dict.get heights possibleNode |> Result.withDefault 0

        if Num.subSaturated possibleHeight currentHeight <= 1 then
            Ok possibleNode
        else
            Err "node too high"

expect getNeighbors sampleHeights (0,0) == [(1,0), (0,1)]
expect getNeighbors sampleHeights (2,3) == [(1,3), (3,3), (2,2)]

# updateNeighbor : State, Node -> State

lowestUnvisited : Dict Node U16 -> Node
lowestUnvisited = \unvisited ->
    unvisited
    |> Dict.toList
    |> List.sortWith \a, b -> if a.1 == b.1 then EQ else if a.1 < b.1 then LT else GT 
    |> List.first
    |> Result.map .0
    |> Result.withDefault (0,0)

expect 
    lowest = 
        [((1,1),2),((3,3),4),((5,5),6)] 
        |> Dict.fromList
        |> lowestUnvisited 
    
    lowest == (1,1)

parseMap : List U8, State, I32, I32 -> State
parseMap = \input, state, row, col ->
    when input is
        [] -> state
        [a, ..] if a == '\n' ->
            # Next row, reset column
            # Assume all rows are same length
            updatedState = { state & 
                rows: state.rows + 1,
                cols: Num.toU8 col,
            }
            parseMap (List.dropFirst input) updatedState (row + 1) 0

        [a, ..] if a == 'S' ->
            # Add Start node            
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) ('a' - 'a'),
                unvisited: Dict.insert state.unvisited (row, col) 0,
                start: (row, col),
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

        [a, ..] if a == 'E' ->
            # Add End node            
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) ('z' - 'a'),
                unvisited: Dict.insert state.unvisited (row, col) Num.maxU16,
                end: (row, col),
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

        [a, ..] ->
            # Add node            
            updatedState = { state &
                heights: Dict.insert state.heights (row, col) (a - 'a'),
                unvisited: Dict.insert state.unvisited (row, col) Num.maxU16,
            }
            parseMap (List.dropFirst input) updatedState row (col + 1)

sampleHeights = Dict.fromList [((0, 0), 0), ((0, 1), 0), ((0, 2), 1), ((0, 3), 16), ((0, 4), 15), ((0, 5), 14), ((0, 6), 13), ((0, 7), 12), ((1, 0), 0), ((1, 1), 1), ((1, 2), 2), ((1, 3), 17), ((1, 4), 24), ((1, 5), 23), ((1, 6), 23), ((1, 7), 11), ((2, 0), 0), ((2, 1), 2), ((2, 2), 2), ((2, 3), 18), ((2, 4), 25), ((2, 5), 25), ((2, 6), 23), ((2, 7), 10), ((3, 0), 0), ((3, 1), 2), ((3, 2), 2), ((3, 3), 19), ((3, 4), 20), ((3, 5), 21), ((3, 6), 22), ((3, 7), 9), ((4, 0), 0), ((4, 1), 1), ((4, 2), 3), ((4, 3), 4), ((4, 4), 5), ((4, 5), 6), ((4, 6), 7), ((4, 7), 8)]