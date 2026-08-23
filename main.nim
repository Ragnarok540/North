import std/[strutils, rdstdin, tables]
import north

var
    stack = newSeqOfCap[string](256)
    line: string
    dictionary = {
        "add1": "1 +",
        "square": "dup *",
    }.toTable

while true:
    let ok = readLineFromStdin("north> ", line)
    if not ok: break
    if line.len > 0:
        let words = line.split(" ")
        for word in words:
            if word == ":":
                dictionary.defineWord(words)
                echo dictionary # debug
                break
            stack.eval(word, dictionary)
            echo stack # debug

echo "bye"
echo stack

# mkdir -p bin
# nim c -o:bin/main main.nim 
# ./bin/main
