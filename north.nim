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
    dictionary = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
    }.toTable

while true:
    let ok = readLineFromStdin("north> ", line)
    if not ok: break
    if line.len > 0:
        let words = line.split(" ")
        for word in words:
            if word in ["+", "-", "*", "/"]:
                let a = stack.pop.parseInt
                let b = stack.pop.parseInt
                proc passAandB(f: (int, int) -> int): int = f(a, b)
                let c = passAandB(dictionary[word])
                stack.add($c)
                echo stack # debug
            elif word == ".":
                let a = stack.pop
                echo a
                echo stack # debug
            else:
                stack.add(word)
                echo stack # debug

echo "bye"
echo stack

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
