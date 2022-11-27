# Hello World used for template and check basic program compiles

app "app-euler-0"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.0/_V6HO2Dwez0xsSstgK8qC6wBLXSfNlVFyUTMg0cYiQQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
    ]
    provides [main] to pf

main : Task {} []
main =  
    Stdout.line "Hello World!"

