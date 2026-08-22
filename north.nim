import std/[strutils, tables, sugar]

func addition(a: int, b: int): int =
    return a + b

func subtraction(a: int, b: int): int =
    return b - a

func multiplication(a: int, b: int): int =
    return a * b

func division(a: int, b: int): int =
    return b div a

var dictionary = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
    }.toTable

proc eval*(stack: var seq[string], word: string) =
    if word in ["+", "-", "*", "/"]:
        let a = stack.pop.parseInt
        let b = stack.pop.parseInt
        proc passAandB(f: (int, int) -> int): int = f(a, b)
        let c = passAandB(dictionary[word])
        stack.add($c)
    elif word == ".":
        let a = stack.pop
        echo a
    else:
        stack.add(word)

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
