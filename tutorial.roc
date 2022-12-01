app "html"
    packages { pf: "https://github.com/lukewilliamboswell/basic-cli/releases/download/0.0.1/Y8nEWrqIRltuueRSwL_MYOWydd3Jt6CSGNEYjCbWo0s.tar.br" }
    imports [
        pf.Process,
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path,
        pf.Html.{ html, text, Attribute, h1, h2, head, p, code, input, meta, ol, li, title, section, link, label, body, footer, div, nav, a },
    ]
    provides [main] to pf

# Setup
path = Path.fromStr "out.html"
renderTask = File.writeUtf8 path (Html.renderStatic view)

# Main
main : Task {} []
main =
    Task.attempt renderTask \result ->
        when result is
            Ok _ ->
                {} <- Stdout.line "Success" |> Task.await
                Process.exit 0

            Err _ ->
                {} <- Stderr.line "Fail" |> Task.await
                Process.exit 1

# VIEW
view =
    html
        [HtmlAttr "lang" "en"]
        [
            head [] [
                meta [HtmlAttr "charset" "utf-8"] [],
                title [] [text "Roc Tutorial"],
                meta [HtmlAttr "name" "description", HtmlAttr "content" "Learn how to use the Roc programming language."] [],
                meta [HtmlAttr "name" "viewport", HtmlAttr "content" "width=device-width"] [],
                link [HtmlAttr "rel" "stylesheet", HtmlAttr "href" "/site.css"] [],
                link [HtmlAttr "rel" "icon", HtmlAttr "href" "/favicon.svg"] [],
            ],
            body [] [
                div [HtmlAttr "id" "top-bar"] [
                    nav [] [
                        a [HtmlAttr "class" "home-link", HtmlAttr "href" "/", HtmlAttr "title" "The Roc Programming Language"] [text "roc"],
                        div [HtmlAttr "id" "top-bar-links"] [
                            a [HtmlAttr "href" "/tutorial"] [text "tutorial"],
                            a [HtmlAttr "href" "/install"] [text "install"],
                            a [HtmlAttr "href" "/repl"] [text "repl"],
                            a [HtmlAttr "href" "/builtins/Bool"] [text "docs"],
                        ],
                    ],
                ],
                mainView,
                footer [] [text "Made by people who like to make nice things. © 2022"],
            ],
        ]

mainView =
    Html.main
        []
        [divTutorialStart]

divTutorialStart =
    div [HtmlAttr "id" "tutorial-start"] [
        input [HtmlAttr "id" "tutorial-toc-toggle", HtmlAttr "name" "tutorial-toc-toggle", HtmlAttr "type" "checkbox"] [],
        nav [HtmlAttr "id" "tutorial-toc"] [
            label [HtmlAttr "id" "close-tutorial-toc", HtmlAttr "for" "tutorial-toc-toggle"] [text "close"],
            input [HtmlAttr "id" "toc-search", HtmlAttr "type" "text", HtmlAttr "placeholder" "Search"] [],
            ol [] tocLinks,
        ],
        tutorialIntro,
    ]

tocLinks =
    [
        { tag: "installation", value: "Installation" },
        { tag: "strings-and-numbers", value: "Strings and Numbers" },
        { tag: "building-an-application", value: "Building an Application" },
        { tag: "defining-functions", value: "Defining Functions" },
        { tag: "if-then-else", value: "if-then-else" },
        { tag: "records", value: "Records" },
        { tag: "debugging", value: "Debugging" },
        { tag: "tags", value: "Tags &amp; Pattern Matching" },
        { tag: "booleans", value: "Booleans" },
        { tag: "lists", value: "Lists" },
        { tag: "types", value: "Types" },
        { tag: "crashing", value: "Crashing" },
        { tag: "tests-and-expectations", value: "Tests and Expectations" },
        { tag: "modules", value: "Modules" },
        { tag: "modules", value: "Platforms and Packages" },
        { tag: "tasks", value: "Tasks" },
        { tag: "abilities", value: "Abilities" },
        { tag: "advanced-concepts", value: "Advanced Concepts" },
        { tag: "operator-desugaring-table", value: "Operator Desugaring Table" },
    ]
    |> List.map (\{ tag, value } -> li [] [a [HtmlAttr "href" (Str.concat "#" tag)] [text value]])

tutorialIntro =
    div [HtmlAttr "id" "tutorial-intro"] [
        section [] [
            h1 [] [
                text "Tutorial",
                label [HtmlAttr "id" "tutorial-toc-toggle-label", HtmlAttr "for" "tutorial-toc-toggle"] [text "contents"],
            ],
            p [] [text "Welcome to Roc!"],
            p [] [text "This tutorial will teach you how to build Roc applications. Along the way, you'll learn how to write tests, use the REPL, and optionally annotate your types."],
        ],
        section [] [
            h2 [HtmlAttr "id" "installation"] [a [HtmlAttr "href" "#installation"] [text "Installation"]],
            p [] [
                text "Roc doesn't have a numbered release or an installer yet, but you can download a nightly release of the",
                code [] [text "roc"],
                text " command-line executable from the ",
                a [HtmlAttr "href" "https://github.com/roc-lang/roc/releases"] [text "Releases page"],
                text "(under \"Assets\"). After you ",
                a [HtmlAttr "href" "https://kinsta.com/knowledgebase/unzip-tar-gz/"] [text "unzip it"],
                text ", be sure to add <code>roc</code> to your ",
                a [HtmlAttr "href" "https://www.java.com/en/download/help/path.html"] [text "PATH"],
                text ".",
            ],
            p [] [
                text "You'll know it worked when you can run ",
                code [] [text "roc version"],
                text "in your terminal and see it print out some version information.",
            ],
            p [] [
                text "If you get stuck, friendly people will be happy to help if you open a topic in ",
                a [HtmlAttr "href" "https://roc.zulipchat.com/#narrow/stream/231634-beginners"] [text "#beginners"],
                text " on ",
                a [HtmlAttr "href" "https://roc.zulipchat.com/"] [text "Roc Zulip Chat"],
                text " and ask for assistance!",
            ],
        ],
    ]
