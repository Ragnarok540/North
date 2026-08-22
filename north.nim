import std/[strutils, sugar, tables]

func addition(a: int, b: int): int =
    return a + b

func subtraction(a: int, b: int): int =
    return b - a

func multiplication(a: int, b: int): int =
    return a * b

func division(a: int, b: int): int =
    return b div a

var operations = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
    }.toTable

proc eval*(stack: var seq[string], word: string, dictionary: Table[string, string]) =
    if word in ["+", "-", "*", "/"]:
        let a = stack.pop.parseInt
        let b = stack.pop.parseInt
        proc passAandB(f: (int, int) -> int): int = f(a, b)
        let c = passAandB(operations[word])
        stack.add($c)
    elif word == ".":
        let a = stack.pop
        echo a
    else:
        try:
            let definition = dictionary[word]
            for w in definition.split(" "):
                stack.eval(w, dictionary)
        except KeyError:
            stack.add(word)

proc defineWord*(dictionary: var Table[string, string], words: seq[string]) =
    assert words[0] == ":"
    assert words[^1] == ";"
    let word = words[1]
    let definition = words[2..^2].join(" ")
    dictionary[word] = definition

# mkdir -p bin
# nim c -o:bin/north north.nim
# ./bin/north
