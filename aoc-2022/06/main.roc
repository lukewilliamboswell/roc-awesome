app "aoc"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.1.0/vPU-UZbWGIXsAfcJvAnmU3t3SWlHoG_GauZpqzJiBKA.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Task,
        "./input-day-6.txt" as fileInput : List U8,
    ]
    provides [main] to pf

main =
    {} <- process "Part 1 - Four unique packets" fileInput 4 |> Task.await
    {} <- process "Part 2 - Fourteen unique packets" fileInput 14 |> Task.await

    Stdout.line "Completed processing"

process = \name, sample, countUniqueRequired ->

    answer = when detectUniquePacketIndex sample countUniqueRequired is
        Ok num -> num |> Num.toStr
        Err NotFound -> crash "Not detected in input"

    Stdout.line "\(name) detected at index \(answer)"

detectUniquePacketIndex : List U8, Nat -> Result Nat [NotFound]
detectUniquePacketIndex = \buffer, countUniqueRequired ->
    uniqueIndex =
        List.walkUntil buffer 0 \index, _ ->
            uniqueCount =
                buffer
                |> List.sublist { start: index, len: countUniqueRequired }
                |> Set.fromList
                |> Set.len

            if uniqueCount == countUniqueRequired then
                Break (index + countUniqueRequired)
            else
                Continue (index + 1)

    if uniqueIndex == List.len buffer then
        Err NotFound
    else
        Ok uniqueIndex

# Part 1
expect detectUniquePacketIndex (Str.toUtf8 "mjqjpqmgbljsphdztnvjfqwrcgsmlb") 4 == Ok 7
expect detectUniquePacketIndex (Str.toUtf8 "bvwbjplbgvbhsrlpgdmjqwftvncz") 4 == Ok 5
expect detectUniquePacketIndex (Str.toUtf8 "nppdvjthqldpwncqszvftbrmjlhg") 4 == Ok 6
expect detectUniquePacketIndex (Str.toUtf8 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") 4 == Ok 10
expect detectUniquePacketIndex (Str.toUtf8 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") 4 == Ok 11

# Part 2
expect detectUniquePacketIndex (Str.toUtf8 "mjqjpqmgbljsphdztnvjfqwrcgsmlb") 14 == Ok 19
expect detectUniquePacketIndex (Str.toUtf8 "bvwbjplbgvbhsrlpgdmjqwftvncz") 14 == Ok 23
expect detectUniquePacketIndex (Str.toUtf8 "nppdvjthqldpwncqszvftbrmjlhg") 14 == Ok 23
expect detectUniquePacketIndex (Str.toUtf8 "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") 14 == Ok 29
expect detectUniquePacketIndex (Str.toUtf8 "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") 14 == Ok 26
