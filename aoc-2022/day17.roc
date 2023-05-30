app "aoc"
    packages { pf: "https://github.com/lukewilliamboswell/roc-tui/releases/download/0.0.1/-USoB6UCElR6j6h5GLJFbnEjipcdyA3S4SFPD_M4CxA.tar.br" }
    imports [
        pf.Event.{ Event, Bounds },
        pf.Elem.{ Elem },
    ]
    provides [program, Model] {} to pf

# Model
Model : {
    text : List U8,
    bounds : { height : U16, width : U16 },
}

# Initialise the Application
init : Bounds -> Model
init = \bounds -> {
    text: List.withCapacity 1000,
    bounds: bounds,
}

# Handle events from the platform
update : Model, Event -> Model
update = \model, event ->
    when event is
        Resize newBounds ->
            { model & bounds: newBounds }

        _ ->
            model

# Build views to render to the terminal
render : Model -> List Elem
render = \model ->
    text = [
            [Elem.styled "Hello" { fg: Green }],
            [Elem.styled "World" { fg: Green }],
        ]
    boundsStr = boundsToStr model.bounds
    helpBar = Elem.paragraph {
        text,
        block: Elem.blockConfig {
            title: Elem.styled "Press ESC to close application." { fg: Red, modifiers : [Bold] },
        },
    }

    [
        Elem.layout
            [
                helpBar,
            ]
            { constraints: [Min 3, Min 3, Ratio 1 1] },
    ]

program = { init, update, render }

boundsToStr : Bounds -> Str
boundsToStr = \{ height, width } ->
    h = Num.toStr height
    w = Num.toStr width

    "Current Window Bounds H: \(h), W:\(w)"

# Day 17 AOC STUFF

# RockType : [
#     HorizontalLine,
#     Plus, 
#     BackwardsL,
#     VerticalLine,
#     Square,
# ]

# ####

# .#.
# ###
# .#.

# ..#
# ..#
# ###

# #
# #
# #
# #

# ##
# ##

# RockChamber - 7 units wide
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# +-------+

# RockChamber : List {rock : RockType, posX : posY}

# renderRockChamber : RockChamber -> 