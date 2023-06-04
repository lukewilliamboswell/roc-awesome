interface TerminalColor
    exposes [Color, escape, withColor]
    imports []

Color : [
    Green,
    Red,
    Blue,
    Black,
]

escape : Color -> Str
escape = \color ->
    when color is
        Green -> "\u(001b)[32m"
        Red -> "\u(001b)[31m"
        Blue -> "\u(001b)[34m"
        Black -> "\u(001b)[30m"

# Resets to black after 
withColor : Str, Color -> Str 
withColor = \text, color ->
    code = escape color
    black = escape Black
    "\(code)\(text)\(black)"