import std/[rdstdin, strutils, tables, sugar]

func addition(a: int, b: int): int =
    return a + b

func subtraction(a: int, b: int): int =
    return b - a

func multiplication(a: int, b: int): int =
    return a * b

func division(a: int, b: int): int =
    return b div a

var
    stack = newSeqOfCap[string](256)
    line: string
    env = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
    }.toTable

while true:
  let ok = readLineFromStdin("north> ", line)
  if not ok: break
  if line.len > 0:
    try:
        discard line.parseInt
        stack.add(line)
        echo stack
    except ValueError:
        let a = stack.pop.parseInt
        let b = stack.pop.parseInt
        proc passAandB(f: (int, int) -> int): int = f(a, b)
        let c = passAandB(env[line])
        stack.add($c)
        echo stack

echo "bye"
echo stack

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
