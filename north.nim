import std/[rdstdin, strutils]

var stack = newSeqOfCap[string](256)
var line: string
var num: int

while true:
  let ok = readLineFromStdin("north> ", line)
  if not ok: break
  if line.len > 0:
    try:
        discard line.parseInt
        stack.add(line)
        echo stack
    except ValueError:
        if line == "+":
            let a = stack.pop.parseInt
            let b = stack.pop.parseInt
            let c = a + b
            stack.add($c)
            echo stack

echo "bye"
echo stack

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
