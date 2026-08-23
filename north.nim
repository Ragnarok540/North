import std/[strutils, sugar, tables]

func addition(a: int, b: int): int =
    return a + b

func subtraction(a: int, b: int): int =
    return b - a

func multiplication(a: int, b: int): int =
    return a * b

func division(a: int, b: int): int =
    return b div a

func equal(a: int, b: int): int =
    if a == b:
        return -1
    return 0

var operations = {
        "+": addition,
        "-": subtraction,
        "*": multiplication,
        "/": division,
        "=": equal,
    }.toTable

proc unquote(word: var string) =
    assert word[0] == '['
    assert word[^1] == ']'
    word.removePrefix('[')
    word.removeSuffix(']')

proc eval*(stack: var seq[string], word: string, dictionary: Table[string, string]) =
    if word in ["+", "-", "*", "/", "="]:
        let a = stack.pop.parseInt
        let b = stack.pop.parseInt
        proc passAandB(f: (int, int) -> int): int = f(a, b)
        let c = passAandB(operations[word])
        stack.add($c)
    elif word == "dup":
        let n = stack.pop
        stack.add(n)
        stack.add(n)
    elif word == "drop":
        discard stack.pop
    elif word == "swap":
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n2)
        stack.add(n1)
    elif word == "over":
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n1)
        stack.add(n2)
        stack.add(n1)
    elif word == "rot":
        let n3 = stack.pop
        let n2 = stack.pop
        let n1 = stack.pop
        stack.add(n2)
        stack.add(n3)
        stack.add(n1)
    elif word == "apply":
        var a = stack.pop
        a.unquote
        for aa in a.split(" "):
            stack.eval(aa, dictionary)
    elif word == "compose":
        var a = stack.pop
        a.unquote
        var b = stack.pop
        b.unquote
        stack.add("[" & b & " " & a & "]")
    elif word == ".":
        let a = stack.pop
        echo a
    elif word == "":
        discard
    else:
        try:
            let definition = dictionary[word]
            let words = definition.split(" ")
            for w in words:
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
