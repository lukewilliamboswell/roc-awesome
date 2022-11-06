# Hello World used for template and check basic program compiles

app "problem000"
    packages { pf: "../cli-platform/main.roc" }
    imports [
        pf.Stdout,
        pf.Program.{ Program },
    ]
    provides [main] to pf

main : Program
main =  
    Stdout.line "Hello World!" |> Program.quick

