import std/[os, strutils, streams, rdstdin, tables]
import north

var
    stack = newSeqOfCap[string](256)
    line: string
    dictionary = {
        "debug": "0",
        "add1": "1 +",
        "square": "dup *",
        "append": "unit compose",
    }.toTable

func isWordDefinition(words: seq[string]): bool =
    return words[0] == ":" and words[^1] == ";" and len(words) >= 3

proc processLine(stack: var seq[string], line: string, dictionary: var Table[string, string]) =
    let words = line.split(" ")
    for word in words:
        if word == ":":
            if not isWordDefinition(words):
                echo "invalid word definition"
                break
            dictionary.defineWord(words)
            if dictionary["debug"] != "0":
                echo dictionary
            break
        stack.eval(word, dictionary)
        if dictionary["debug"] != "0":
            echo stack

if paramCount() >= 1:
    var strm = newFileStream(paramStr(1), fmRead)
    var l = ""
    if not isNil(strm):
        while strm.readLine(l):
            stack.processLine(l, dictionary)
        strm.close()

while true:
    let ok = readLineFromStdin("north> ", line)
    if not ok: break
    if line.len > 0:
        try:
            stack.processLine(line, dictionary)
        except ValueError:
            echo "operation not allowed"

echo "bye"
if dictionary["debug"] != "0":
    echo stack

# mkdir -p bin
# nim c -o:bin/main main.nim 
# ./bin/main
