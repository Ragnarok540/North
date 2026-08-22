import std/[strutils, rdstdin]
import north

var
    stack = newSeqOfCap[string](256)
    line: string

while true:
    let ok = readLineFromStdin("north> ", line)
    if not ok: break
    if line.len > 0:
        let words = line.split(" ")
        for word in words:
            stack.eval(word)
            echo stack # debug

echo "bye"
echo stack

# mkdir -p bin
# nim c -o:bin/main main.nim 
# ./bin/main
