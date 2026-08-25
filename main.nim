import std/[os, strutils, streams, rdstdin, tables]
import north

var
    stack = newSeqOfCap[string](256)
    line: string
    dictionary = {
        "add1": "1 +",
        "square": "dup *",
        "append": "unit compose",
    }.toTable

proc processLine(stack: var seq[string], line: string, dictionary: var Table[string, string]) =
    let words = line.split(" ")
    for word in words:
        if word == ":":
            dictionary.defineWord(words)
            echo dictionary # debug
            break
        stack.eval(word, dictionary)
        echo stack # debug

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
        stack.processLine(line, dictionary)

echo "bye"
echo stack # debug

# mkdir -p bin
# nim c -o:bin/main main.nim 
# ./bin/main
